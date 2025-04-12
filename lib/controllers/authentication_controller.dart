import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:test_app/widgets/dropdown_value_controller.dart';

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

  //Sign Up Details
  TextEditingController newUserName = TextEditingController();
  DropdownValueController<String?> gendersController = DropdownValueController<String?>();
  DropdownValueController<String?> tehsilController = DropdownValueController<String?>();




  //Lists
  Future<List<String>> gendersList = Future.value(["Male", "Female", "Unknown"]);
  Future<List<String>> tehsilList = Future.value([
  "Akkalkuwa",
  "Dhadgaon",
  "Nandurbar",
  "Navapur",
  "Shahada",
  "Taloda",
 
]);




}