import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/controllers/authentication_controller.dart';
import 'package:test_app/helpers/enum.dart';
import 'package:test_app/helpers/validators.dart';
import 'package:test_app/providers/shared_preferences_provider.dart';
import 'package:test_app/screen/Login_Screens/local_pin_screen.dart';
import 'package:test_app/screen/Login_Screens/sign_up_screen.dart';
import 'package:test_app/widgets/custom_filled_text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {

  var formKey = GlobalKey<FormState>();
  bool rememberMe = false;
  
  Widget getScaffold(AuthenticationState state) {
    return Scaffold(
      // backgroundColor: Theme.of(context).primaryColor,
      backgroundColor: Colors.black,
      appBar: AppBar(
        // title: Text("Enter Credential", style: TextStyle(color: Theme.of(context).secondaryHeaderColor ),),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 220,
                  width: 220,
                  child: ClipOval(
                    child: Image.asset(
                      "lib/assets/Rajesh_Dada.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: CustomFilledTextField(
                      controller: state.userName,
                      labelText: "UserName",
                      validator: (value) {
                        return Validators.validateEmptyField(value);
                      }),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: CustomFilledTextField(
                    controller: state.password,
                    labelText: "Password",
                    validator: (value) {
                      return Validators.validateEmptyField(value);
                    },
                    
                  ),
                  
                ),
                SizedBox(height: 10),
              
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: rememberMe,
                      onChanged: (value) {
                        setState(() {
                          rememberMe = value ?? false;
                        });
                      },
                    ),
                    Text('Remember Me',style: TextStyle(color: Theme.of(context).secondaryHeaderColor )),
                  ],
                ),

                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      EasyLoading.show(status: 'Loading...');
                      var loginSuccessOrFailed = true;
                      // await ref
                      //     .read(authenticationControllerProvider.notifier)
                      //     .loginUser();

                      if (loginSuccessOrFailed != null) {
                      //  if (true) {
                        var prefs  =  await ref.watch(sharedPreferencesProvider.future);
                        prefs.setBool(PrefrencesKeyEnum.rememberMe.key, rememberMe);
                        prefs.setBool(PrefrencesKeyEnum.isLoggedin.key, true);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            "Login Successfully",
                            style: TextStyle(color: Colors.black),
                          ),
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.green.shade600,
                        ));
                        
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LocalPinScreen(),
                            ));
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            "Login Failed",
                            style: TextStyle(color: Colors.black),
                          ),
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.red.shade600,
                        ));
                      }
                      EasyLoading.dismiss();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 14),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(fontSize: 16, ),
                  ),
                ),

                SizedBox(height: 10,),

                    
                TextButton(onPressed: () {
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                    return SignUpScreen();
                  },));
                  
                },
                child: Text("New User ? ", 
                style: TextStyle(fontSize: 16,color: Theme.of(context).secondaryHeaderColor ),)
                )

              ],
            ),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    var asyncAuthenticationState = ref.watch(authenticationControllerProvider);

    return asyncAuthenticationState.when(
      data: (authenticationState) {
        return getScaffold(authenticationState);
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
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
