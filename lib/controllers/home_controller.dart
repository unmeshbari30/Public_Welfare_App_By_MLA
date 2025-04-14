// import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/controllers/authentication_controller.dart';
import 'package:test_app/helpers/enum.dart';

part "home_controller.g.dart";

@riverpod
class HomeController extends _$HomeController{

@override
FutureOr<HomeState> build() async{
  HomeState newState = HomeState();

  var data = await ref.read(authenticationControllerProvider.future);
  newState.userName = data.userName.text;



  

  return newState;

}

Future<bool> checkIsLogin() async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getBool(PrefrencesKeyEnum.isLoggedin.key) ?? false;
}

// Future<bool> setLoginStatus(bool data) async{
//   SharedPreferences pref = await SharedPreferences.getInstance();
//   return pref.setBool(PrefrencesKeyEnum.isLoggedin.key, data);
// }

Future<bool> loggedOut() async{
  SharedPreferences pref = await SharedPreferences.getInstance();
   pref.remove(PrefrencesKeyEnum.isLoggedin.key);
   pref.remove(PrefrencesKeyEnum.localPin.key);
   pref.remove(PrefrencesKeyEnum.accessToken.key);
   pref.remove(PrefrencesKeyEnum.refreshToken.key);
   pref.remove(PrefrencesKeyEnum.isfirstLocalPin.key);
  return true;


}


}

class HomeState{

  String? userName;
  



}