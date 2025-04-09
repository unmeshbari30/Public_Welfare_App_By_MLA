import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/controllers/authentication_controller.dart';
import 'package:test_app/widgets/custom_filled_text_field.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {


Widget getScaffold(AuthenticationState state){
  return Scaffold(
    appBar: AppBar(
      title: Text("Register", style:  TextStyle(color: Theme.of(context).secondaryHeaderColor )),
      centerTitle: true,
      backgroundColor: Colors.black,

    ),
    backgroundColor: Colors.black,
    body: Column(
      children: [
        SizedBox(height: 10,),

        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: CustomFilledTextField(
            controller: state.firstName,
            labelText: "First Name",
          ),
        ),

        SizedBox(height: 10,),

         Padding(
           padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
           child: CustomFilledTextField(
            controller: state.firstName,
            labelText: "Middle Name",
                   ),
         ),


        SizedBox(height: 10,),

         Padding(
           padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
           child: CustomFilledTextField(
            controller: state.firstName,
            labelText: "Last Name",
                   ),
         ),

         

        


      ],
    ),
  );

}










  @override
  Widget build(BuildContext context) {
  var asyncSignUpState = ref.watch(authenticationControllerProvider);
   return  asyncSignUpState.when(
      data:(state) {
        return getScaffold(state);
        
      }, 
      error: (error, stackTrace) {
        return Scaffold(
          body: Center(
            child: AlertDialog(
              title: const Text("Something went wrong"),
              content: Text(error.toString()),
            ),
          ),
        );
      }, 
      loading: () {
        return CircularProgressIndicator();
      },);
  }
}