import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
  
  @override
  void dispose() {
    final state = ref.read(authenticationControllerProvider).value;

    state?.firstNameController.dispose();
    state?.middleNameController.dispose();
    state?.lastNameController.dispose();
    state?.whatsappNumberController.dispose();
    state?.mobileNumberController.dispose();
    state?.passwordController.dispose();
    state?.ageController.dispose();
    state?.emailController.dispose();

    super.dispose();
  }


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
                    controller: state.firstNameController,
                    labelText: "पहिले नाव / First Name",
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: CustomFilledTextField(
                    controller: state.middleNameController,
                    labelText: "मधले नाव / Middle Name",
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: CustomFilledTextField(
                    controller: state.lastNameController,
                    labelText: "आडनाव / Last Name",
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
                            labelText: "लिंग / Gender",
                            titleBuilder: (item) => item),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: FutureFilledDropdown(
                          items: state.tehsilList,
                          controller: state.tehsilController,
                          labelText: "तालुका  / Taluka",
                          titleBuilder: (item) => item,
                        ),
                      ),
                    ),
                  ],
                ),


                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                        child: CustomFilledTextField(
                        controller: state.ageController,
                        labelText: "वय / Age",
                        keyboardType: TextInputType.number,
                  ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: FutureFilledDropdown(
                          items: state.bloodGroup,
                          controller: state.bloodGroupController,
                          labelText: "रक्त गट / Blood Group",
                          titleBuilder: (item) => item,
                        ),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: CustomFilledTextField(
                    controller: state.emailController,
                    labelText: "ईमेल / Email",
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: CustomFilledTextField(
                    controller: state.whatsappNumberController,
                    labelText: "व्हाट्सअँप नं. / Whatsapp No.",
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: CustomFilledTextField(
                    controller: state.mobileNumberController,
                    labelText: "मो. नंबर / Mobile Number",
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: CustomFilledTextField(
                    controller: state.passwordController,
                    labelText: "पासवर्ड तयार करा / Create Password",
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: ElevatedButton(
                      onPressed: () async{
                        if (formKey.currentState!.validate()) {
                          try{
                            EasyLoading.show();
                            var successful = await ref.read(authenticationControllerProvider.notifier).userRegistration();
                            if(successful?.isRegistered == true){
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    successful?.message ?? "",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.green.shade600,
                                ),
                              );

                              Navigator.pop(context);


                            }else{

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    successful?.message ?? "",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.red.shade600,
                                ),
                              );
                            }


                          }catch(e){
                            print(e);

                          }finally{
                            EasyLoading.dismiss();
                            
                          }
                        }
                      },
                      child: Text("रजिस्टर / Register")),
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
