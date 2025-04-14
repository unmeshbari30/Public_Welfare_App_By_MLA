import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/controllers/authentication_controller.dart';
import 'package:test_app/widgets/custom_filled_text_field.dart';
import 'package:test_app/widgets/future_filled_dropdown.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  var formKey = GlobalKey<FormState>();

  Widget getScaffold(AuthenticationState state) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register",
            style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: CustomFilledTextField(
                    controller: state.firstName,
                    labelText: "First Name",
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: CustomFilledTextField(
                    controller: state.middleName,
                    labelText: "Middle Name",
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: CustomFilledTextField(
                    controller: state.lastName,
                    labelText: "Last Name",
                  ),
                ),

                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                        child: FutureFilledDropdown(
                            items: state.gendersList,
                            controller: state.gendersController,
                            labelText: "Choose Gender",
                            titleBuilder: (item) => item),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: FutureFilledDropdown(
                          items: state.tehsilList,
                          controller: state.tehsilController,
                          labelText: "Select Taluka",
                          titleBuilder: (item) => item,
                        ),
                      ),
                    ),
                  ],
                ),

                //  Padding(
                //   padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                //   child: CustomFilledTextField(
                //     controller: state.newUserName,
                //     labelText: "Enter new UserName",
                //     validator: (value) {
                //       Validators.usernameOrEmailValidator(value);
                //     },
                //   ),
                //   )

                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {}
                      },
                      child: Text("Register")),
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
    var asyncSignUpState = ref.watch(authenticationControllerProvider);
    return asyncSignUpState.when(
      data: (state) {
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
        return Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
