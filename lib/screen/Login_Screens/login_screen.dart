import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/controllers/authentication_controller.dart';
import 'package:test_app/widgets/custom_filled_text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {

  Widget getScaffold(AuthenticationState state){
      return Scaffold(
        appBar: AppBar(
          title: Text("Enter Credential"),
          centerTitle: true,
        ),

        backgroundColor: Colors.amber,
        body: Column(
          children: [
            Expanded(
              child: Image.asset("lib/assets/Rajesh_Dada.jpg"),
            ),

            CustomFilledTextField(
              controller: state.userName,
              labelText: "UserName",
            ),
            CustomFilledTextField(
              controller: state.password ,
              labelText: "Password",
            )



          ],
        ),
        
      );

  }


  @override
  Widget build(BuildContext context) {
    var asyncAuthenticationState  = ref.watch(authenticationControllerProvider);
    asyncAuthenticationState.when(
      data: (authenticationState) {
        return getScaffold(authenticationState);
        
      }, 
      error: (error, stackTrace) {
        return Scaffold(body: AlertDialog(
          title: Text("Something error "),
        ),);
      }, 
      loading: () => CircularProgressIndicator(),
      );
    return const Placeholder();
  }
}