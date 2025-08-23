import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rajesh_dada_padvi/controllers/authentication_controller.dart';
import 'package:rajesh_dada_padvi/helpers/enum.dart';
import 'package:rajesh_dada_padvi/providers/shared_preferences_provider.dart';
import 'package:rajesh_dada_padvi/screen/Login_Screens/sign_up_screen.dart';
import 'package:rajesh_dada_padvi/screen/home_screen.dart';
import 'package:rajesh_dada_padvi/widgets/custom_filled_text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  var formKey = GlobalKey<FormState>();
  bool rememberMe = false;
  bool passwordVisible = true;
  int exitCounter = 1;
  bool _submitted = false;

  Widget getScaffold(AuthenticationState state) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (exitCounter == 2) {
            exit(0);
          }
          exitCounter++;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Press back again to exit",
                style: TextStyle(color: Colors.black),
              ),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.amber,
            ),
          );
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 235, 143, 86),
                Color.fromARGB(255, 236, 105, 34),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      // autovalidateMode: AutovalidateMode.onUserInteraction,
                      autovalidateMode: _submitted
                          ? AutovalidateMode.always
                          : AutovalidateMode.disabled,
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Welcome Back",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE65100), //Colors.deepPurple,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Login to your account",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          const SizedBox(height: 30),
                          CustomFilledTextField(
                            controller: state.userName,
                            labelText: "Mobile Number",
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Mobile number is required';
                              }
                              if (value.length != 10) {
                                return 'Enter a valid 10-digit number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomFilledTextField(
                            controller: state.password,
                            obscureText: passwordVisible,
                            labelText: "Password",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                            suffixIcon: IconButton(
                              icon: Icon(
                                passwordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                size: 24,
                              ),
                              onPressed: () {
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Checkbox(
                                value: rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    rememberMe = value ?? false;
                                  });
                                },
                              ),
                              Text("Remember Me"),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                _submitted =
                                    true; // Start validation after login is pressed
                              });

                              if (formKey.currentState!.validate()) {
                                EasyLoading.show();

                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) async {
                                  var loginSuccessOrFailed = await ref
                                      .read(
                                        authenticationControllerProvider
                                            .notifier,
                                      )
                                      .loginUser();

                                  try {
                                    if (loginSuccessOrFailed != null) {
                                      var prefs = await ref.watch(
                                        sharedPreferencesProvider.future,
                                      );
                                      prefs.setBool(
                                        PrefrencesKeyEnum.rememberMe.key,
                                        rememberMe,
                                      );
                                      prefs.setBool(
                                        PrefrencesKeyEnum.isLoggedin.key,
                                        true,
                                      );

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Login Successfully",
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          duration: Duration(seconds: 2),
                                          backgroundColor:
                                              Colors.green.shade600,
                                        ),
                                      );

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HomeScreen(),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Login Failed",
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          duration: Duration(seconds: 2),
                                          backgroundColor: Colors.red.shade600,
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          loginSuccessOrFailed?.message ??
                                              "Login Failed",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        duration: Duration(seconds: 2),
                                        backgroundColor: Colors.red.shade600,
                                      ),
                                    );
                                  }

                                  EasyLoading.dismiss();
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(234, 243, 88, 41),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 50,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Login",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUpScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "New User? Sign Up",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFFE65100),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
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
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
