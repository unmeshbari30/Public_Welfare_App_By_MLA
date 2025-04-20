// import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/controllers/authentication_controller.dart';
import 'package:test_app/helpers/enum.dart';
import 'package:test_app/widgets/dropdown_value_controller.dart';

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


void updateSelectedFile(List<File>? selectedFiles){
  update((p0) {
    p0.selectedFiles = selectedFiles;
    return p0;
  },);

}


}

class HomeState{

  String? userName;
  List<File>? selectedFiles;

  //TextFields Controller
  TextEditingController fullNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController complaintMessageController = TextEditingController();
  TextEditingController locationController = TextEditingController();


  //Dropdown Controllers
  DropdownValueController<String?> gendersController =
      DropdownValueController<String?>();
  DropdownValueController<String?> talukaController =
      DropdownValueController<String?>();

  //List
  Future<List<String>> gendersList =
      Future.value(["Male", "Female", "Unknown"]);
  Future<List<String>> TalukaList =
      Future.value(["Shahada", "Taloda"]); //"Akkalkuva", "Dhagaon", "Navapur", "Nandurbar", 
  




}