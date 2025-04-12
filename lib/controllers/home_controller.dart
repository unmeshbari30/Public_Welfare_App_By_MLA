// import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/helpers/enum.dart';

part "home_controller.g.dart";

@riverpod
class HomeController extends _$HomeController{

@override
FutureOr<HomeState> build() async{

  HomeState newState = HomeState();

  

  return newState;

}

Future<bool> checkIsLogin() async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getBool(PrefrencesKeyEnum.isLogin.key) ?? false;
}

Future<bool> setLoginStatus(bool data) async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.setBool(PrefrencesKeyEnum.isLogin.key, data);
}

Future<bool> loggedOut() async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.remove(PrefrencesKeyEnum.isLogin.key);

}


}

class HomeState{



}