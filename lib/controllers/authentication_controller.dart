import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'authentication_controller.g.dart';

@riverpod
class AuthenticationController extends _$AuthenticationController{

  @override
  FutureOr<AuthenticationState> build() async{
    AuthenticationState newState = AuthenticationState();

    return newState;
  }

  Future<bool> loginUser({String? userName, String? password}){

    return Future.value(true);

  }

}

class AuthenticationState{

  //Login Credentials
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();

  //New Registration Details
  TextEditingController firstName = TextEditingController();
  TextEditingController middleName = TextEditingController();
  TextEditingController lastName = TextEditingController();

  //



}