import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/helpers/enum.dart';
import 'package:test_app/models/device_info_model.dart';
import 'package:test_app/models/login_payload_model.dart';
import 'package:test_app/repository/repository.dart';
import 'package:test_app/widgets/dropdown_value_controller.dart';

part 'authentication_controller.g.dart';

@riverpod
class AuthenticationController extends _$AuthenticationController {
  @override
  FutureOr<AuthenticationState> build() async {
    AuthenticationState newState = AuthenticationState();

    return newState;
  }

  Future getDeviceAndNetworkInfo() async {
    var currentState = state.value;
    final deviceInfoPlugin = DeviceInfoPlugin();
    final networkInfo = NetworkInfo();
    final packageInfo = await PackageInfo.fromPlatform();
    final androidInfo = await deviceInfoPlugin.androidInfo;
    currentState?.appVersion = '${packageInfo.version}+${packageInfo.buildNumber}';

    final connectivityResults = await Connectivity().checkConnectivity();
    var connectionType = 'None';

    if (connectivityResults.contains(ConnectivityResult.wifi)) {
      connectionType = 'WiFi';
    } else if (connectivityResults.contains(ConnectivityResult.mobile)) {
      connectionType = 'Mobile';
    } else if (connectivityResults.contains(ConnectivityResult.ethernet)) {
      connectionType = 'Ethernet';
    } else if (connectivityResults.contains(ConnectivityResult.bluetooth)) {
      connectionType = 'Bluetooth';
    } else if (connectivityResults.contains(ConnectivityResult.vpn)) {
      connectionType = 'VPN';
    } else if (connectivityResults.contains(ConnectivityResult.other)) {
      connectionType = 'Other';
    } else if (connectivityResults.contains(ConnectivityResult.none)) {
      connectionType = 'No Connection';
    }

    // Now you can use connectionType!
    currentState?.connectionType = connectionType;

    update(
      (p0) async {
        if (Platform.isAndroid) {
          p0.platform = 'Android';
          p0.version = androidInfo.version.release;
          p0.deviceModel = androidInfo.model;
          p0.manufacturer = androidInfo.manufacturer;
          p0.deviceName = androidInfo.device;
        } else if (Platform.isIOS) {
          final iosInfo = await deviceInfoPlugin.iosInfo;
          p0.platform = 'iOS';
          p0.version = iosInfo.systemVersion;
          p0.deviceModel = iosInfo.utsname.machine;
          p0.manufacturer = 'Apple';
          p0.deviceName = iosInfo.name;
        }

        if (connectivityResults.contains(ConnectivityResult.wifi)) {
          p0.wifiName = await networkInfo.getWifiName() ?? 'Unavailable';
          p0.wifiBSSID = await networkInfo.getWifiBSSID() ?? 'Unavailable';
          p0.ipAddress = await networkInfo.getWifiIP() ?? 'Unavailable';
        } else if (connectivityResults.contains(ConnectivityResult.mobile)) {
          p0.ipAddress = await networkInfo.getWifiIP() ?? 'Unavailable';
          p0.note = 'Connected via mobile data. WiFi info not available.';
        } else {
          p0.note = 'No active network connection.';
        }

        return p0;
      },
    );
  }

  Future<LoginPayloadModel?> loginUser() async {
    var repository = await ref.read(repositoryProvider.future);
    await getDeviceAndNetworkInfo();
    var currentState = state.value;
    if (currentState != null) {
      DeviceInfoModel deviceInfo = DeviceInfoModel(
        appVersion: currentState.appVersion,
        connectionType: currentState.connectionType,
        deviceName: currentState.deviceName,
        ipAddress: currentState.ipAddress,
        manufacturer: currentState.manufacturer,
        deviceModel: currentState.deviceModel,
        note: currentState.note,
        platform: currentState.platform,
        version: currentState.version,
        wifiBssid: currentState.wifiBSSID,
        wifiName: currentState.wifiName,
      );

      LoginPayloadModel loginPayload = LoginPayloadModel(
          deviceInfo: deviceInfo,
          userName: currentState.userName.text ?? "nullUserName",
          password: currentState.password.text);

      var loginResult = await repository.loginUser(loginPayload: loginPayload);

      return loginResult;
    }

    return null;
  }

  Future<bool> checkIsLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(PrefrencesKeyEnum.isLoggedin.key) ?? false;
  }

// Future<bool> setLoginStatus(bool data) async{
//   SharedPreferences pref = await SharedPreferences.getInstance();
//   return pref.setBool(PrefrencesKeyEnum.isLoggedin.key, data);
// }

  Future<bool> loggedOut() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove(PrefrencesKeyEnum.isLoggedin.key);
    pref.remove(PrefrencesKeyEnum.localPin.key);
    pref.remove(PrefrencesKeyEnum.accessToken.key);
    pref.remove(PrefrencesKeyEnum.refreshToken.key);
    pref.remove(PrefrencesKeyEnum.isfirstLocalPin.key);

    //  update((p0) {
    //   p0.userName.text = "";
    //   p0.password.text = "";
    //   return p0;
    // },);

    return true;
  }
}

class AuthenticationState {
  //Device info
  String? platform; // = 'Unknown';
  String? version; // = 'Unknown';
  String? deviceModel = 'Unknown';
  String? manufacturer; // = 'Unknown';
  String? deviceName; // = 'Unknown';
  String? connectionType; // = connectivityResult.toString();
  String? wifiName; // = 'N/A';
  String? wifiBSSID; // = 'N/A';
  String? ipAddress; // = 'N/A';
  String? note; // = '';
  String? appVersion;

  //Login Credentials
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();

  //New Registration Details
  TextEditingController firstName = TextEditingController();
  TextEditingController middleName = TextEditingController();
  TextEditingController lastName = TextEditingController();

  //Sign Up Details
  TextEditingController newUserName = TextEditingController();
  DropdownValueController<String?> gendersController =
      DropdownValueController<String?>();
  DropdownValueController<String?> tehsilController =
      DropdownValueController<String?>();

  //Lists
  Future<List<String>> gendersList =
      Future.value(["Male", "Female", "Unknown"]);
  Future<List<String>> tehsilList = Future.value([
    "Akkalkuwa",
    "Dhadgaon",
    "Nandurbar",
    "Navapur",
    "Shahada",
    "Taloda",
  ]);
}
