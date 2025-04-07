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

}

class AuthenticationState{
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();

}