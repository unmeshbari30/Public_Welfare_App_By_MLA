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
import 'package:test_app/models/registration_payload_model.dart';
import 'package:test_app/models/registration_response_model.dart';
import 'package:test_app/providers/shared_preferences_provider.dart';
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

//   Future getDeviceAndNetworkInfo() async {
//   var currentState = state.value;
//   final deviceInfoPlugin = DeviceInfoPlugin();
//   final networkInfo = NetworkInfo();
//   final packageInfo = await PackageInfo.fromPlatform();
//   final connectivityResults = await Connectivity().checkConnectivity();
//   var connectionType = 'None';
//   if (connectivityResults.contains(ConnectivityResult.wifi)) {
//     connectionType = 'WiFi';
//   } else if (connectivityResults.contains(ConnectivityResult.mobile)) {
//     connectionType = 'Mobile';
//   } else if (connectivityResults.contains(ConnectivityResult.ethernet)) {
//     connectionType = 'Ethernet';
//   } else if (connectivityResults.contains(ConnectivityResult.bluetooth)) {
//     connectionType = 'Bluetooth';
//   } else if (connectivityResults.contains(ConnectivityResult.vpn)) {
//     connectionType = 'VPN';
//   } else if (connectivityResults.contains(ConnectivityResult.other)) {
//     connectionType = 'Other';
//   } else if (connectivityResults.contains(ConnectivityResult.none)) {
//     connectionType = 'No Connection';
//   }
//   // Prepare fields outside update
//   String? platform;
//   String? version;
//   String? deviceModel;
//   String? manufacturer;
//   String? deviceName;
//   String? wifiName;
//   String? wifiBSSID;
//   String? ipAddress;
//   String? note;
//   if (Platform.isAndroid) {
//     final androidInfo = await deviceInfoPlugin.androidInfo;
//     platform = 'Android';
//     version = androidInfo.version.release;
//     deviceModel = androidInfo.model;
//     manufacturer = androidInfo.manufacturer;
//     deviceName = androidInfo.device;
//   } else if (Platform.isIOS) {
//     final iosInfo = await deviceInfoPlugin.iosInfo;
//     platform = 'iOS';
//     version = iosInfo.systemVersion;
//     deviceModel = iosInfo.utsname.machine;
//     manufacturer = 'Apple';
//     deviceName = iosInfo.name;
//   }
//   if (connectivityResults.contains(ConnectivityResult.wifi)) {
//     wifiName = await networkInfo.getWifiName() ?? 'Unavailable';
//     wifiBSSID = await networkInfo.getWifiBSSID() ?? 'Unavailable';
//     ipAddress = await networkInfo.getWifiIP() ?? 'Unavailable';
//   } else if (connectivityResults.contains(ConnectivityResult.mobile)) {
//     ipAddress = await networkInfo.getWifiIP() ?? 'Unavailable';
//     note = 'Connected via mobile data. WiFi info not available.';
//   } else {
//     note = 'No active network connection.';
//   }
//   update((p0) {
//     p0.appVersion = '${packageInfo.version}+${packageInfo.buildNumber}';
//     p0.connectionType = connectionType;
//     p0.platform = platform;
//     p0.version = version;
//     p0.deviceModel = deviceModel;
//     p0.manufacturer = manufacturer;
//     p0.deviceName = deviceName;
//     p0.wifiName = wifiName;
//     p0.wifiBSSID = wifiBSSID;
//     p0.ipAddress = ipAddress;
//     p0.note = note;
//     return p0;
//   });
// }

  // Future<LoginPayloadModel?> loginUser() async {
  //   var repository = await ref.read(repositoryProvider.future);
  //   await getDeviceAndNetworkInfo();
  //   var currentState = state.value;
  //   if (currentState != null) {
  //     DeviceInfoModel deviceInfo  = DeviceInfoModel(
  //       appVersion: currentState.appVersion,
  //       connectionType: currentState.connectionType,
  //       deviceName: currentState.deviceName,
  //       ipAddress: currentState.ipAddress,
  //       manufacturer: currentState.manufacturer,
  //       deviceModel: currentState.deviceModel,
  //       note: currentState.note,
  //       platform: currentState.platform,
  //       version: currentState.version,
  //       wifiBssid: currentState.wifiBSSID,
  //       wifiName: currentState.wifiName,
  //     );
  //     LoginPayloadModel loginPayload = LoginPayloadModel(
  //         deviceInfo: deviceInfo,
  //         userName: currentState.userName.text ?? "nullUserName",
  //         password: currentState.password.text);
  //     var loginResult = await repository.loginUser(loginPayload: loginPayload);
  //     return loginResult;
  //   }
  //   return null;
  // }

 Future<LoginPayloadModel?> loginUser() async {
  var repository = await ref.read(repositoryProvider.future);

  // Collect device and network info
  final deviceInfoPlugin = DeviceInfoPlugin();
  final networkInfo = NetworkInfo();
  final packageInfo = await PackageInfo.fromPlatform();
  final connectivityResults = await Connectivity().checkConnectivity();

  String connectionType = 'None';
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
  } else {
    connectionType = 'No Connection';
  }

  // Prepare fields
  String? platform;
  String? version;
  String? deviceModel;
  String? manufacturer;
  String? deviceName;
  String? wifiName;
  String? wifiBSSID;
  String? ipAddress;
  String? note;

  if (Platform.isAndroid) {
    final androidInfo = await deviceInfoPlugin.androidInfo;
    platform = 'Android';
    version = androidInfo.version.release;
    deviceModel = androidInfo.model;
    manufacturer = androidInfo.manufacturer;
    deviceName = androidInfo.device;
  } else if (Platform.isIOS) {
    final iosInfo = await deviceInfoPlugin.iosInfo;
    platform = 'iOS';
    version = iosInfo.systemVersion;
    deviceModel = iosInfo.utsname.machine;
    manufacturer = 'Apple';
    deviceName = iosInfo.name;
  }

  if (connectivityResults.contains(ConnectivityResult.wifi)) {
    wifiName = await networkInfo.getWifiName() ?? 'Unavailable';
    wifiBSSID = await networkInfo.getWifiBSSID() ?? 'Unavailable';
    ipAddress = await networkInfo.getWifiIP() ?? 'Unavailable';
  } else if (connectivityResults.contains(ConnectivityResult.mobile)) {
    ipAddress = await networkInfo.getWifiIP() ?? 'Unavailable';
    note = 'Connected via mobile data. WiFi info not available.';
  } else {
    note = 'No active network connection.';
  }

  // Fetch current state
  var currentState = state.value;
  if (currentState != null) {
    DeviceInfoModel deviceInfo = DeviceInfoModel(
      appVersion: '${packageInfo.version}+${packageInfo.buildNumber}',
      connectionType: connectionType,
      platform: platform,
      version: version,
      deviceModel: deviceModel,
      manufacturer: manufacturer,
      deviceName: deviceName,
      wifiName: wifiName,
      wifiBssid: wifiBSSID,
      ipAddress: ipAddress,
      note: note,
    );

    LoginPayloadModel loginPayload = LoginPayloadModel(
      deviceInfo: deviceInfo,
      userName: currentState.userName.text ?? "nullUserName",
      password: currentState.password.text,
    );

    var loginResult = await repository.loginUser(loginPayload: loginPayload);
    currentState.loginResult = loginResult;

    if (loginResult != null) {
      var prefs = await ref.read(sharedPreferencesProvider.future);

      prefs.setString(PrefrencesKeyEnum.firstName.key, loginResult.firstName ?? "");
      prefs.setString(PrefrencesKeyEnum.lastName.key, loginResult.lastName ?? "");
      prefs.setString(PrefrencesKeyEnum.mobileNumber.key, loginResult.mobileNumber ?? "");
      prefs.setString(PrefrencesKeyEnum.taluka.key, loginResult.taluka ?? "");
      prefs.setString(PrefrencesKeyEnum.gender.key, loginResult.gender ?? "");
      prefs.setString(PrefrencesKeyEnum.bloodGroup.key, loginResult.bloodGroup ?? "");
      prefs.setInt(PrefrencesKeyEnum.age.key, loginResult.age ?? 0);
      prefs.setString(PrefrencesKeyEnum.mailId.key, loginResult.mailId ?? "");
    }

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

  Future<RegistrationResponseModel?> userRegistration() async {
    try{
      var repository = await ref.read(repositoryProvider.future);
      var currentState = state.value;

      RegistrationPayloadModel loginPayload = RegistrationPayloadModel(
      age: int.tryParse(currentState?.ageController.text ?? "0") ?? 0,
      bloodGroup: currentState?.bloodGroupController.selectedItem,
      firstName: currentState?.firstNameController.text,
      gender: currentState?.gendersController.selectedItem,
      lastName: currentState?.lastNameController.text ,
      mailId: currentState?.emailController.text,
      mobileNumber: currentState?.mobileNumberController.text,
      taluka: currentState?.tehsilController.selectedItem,
      username: currentState?.mobileNumberController.text,
      whatsappNumber: currentState?.whatsappNumberController.text,
      password: currentState?.passwordController.text,
    );

      var temp = await repository.registerUser(loginPayload);
     
      return temp;

    }catch(e){
      return null;
    }
  }
}

class AuthenticationState {

  LoginPayloadModel? loginResult;

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

  //Login Credentials  on SignIn Screen
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();

  //New Registration Details
  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController whatsappNumberController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController emailController = TextEditingController();


  //Sign Up Details
  TextEditingController newUserName = TextEditingController();
  DropdownValueController<String?> gendersController =
      DropdownValueController<String?>();
  DropdownValueController<String?> tehsilController =
      DropdownValueController<String?>();
  DropdownValueController<String?> bloodGroupController=
      DropdownValueController<String?>();

  //Lists
  Future<List<String>> gendersList =
      Future.value(["Male", "Female", "Unknown"]);
  Future<List<String>> tehsilList = Future.value([
    "Shahada",
    "Taloda",
  ]);

  Future<List<String>> bloodGroup =
      Future.value([
       "A+",
       "A-",
       "B+",
       "B-",
       "AB+",
       "AB-",
       "O+",
       "O-"
       ]);
}
