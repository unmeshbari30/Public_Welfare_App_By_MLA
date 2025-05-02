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

part 'grievance_controller.g.dart';

@riverpod
class GrievanceController extends _$GrievanceController {
  @override
  FutureOr<GrievanceState> build() async {
    GrievanceState newState = GrievanceState();
    // newState.

    return newState;
  }


}

class GrievanceState {

 
}
