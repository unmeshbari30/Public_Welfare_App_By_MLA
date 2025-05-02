import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/controllers/home_controller.dart';
import 'package:test_app/helpers/validators.dart';
import 'package:test_app/widgets/custom_filled_text_field.dart';
import 'package:test_app/widgets/custom_multi_file_picker.dart';
import 'package:test_app/widgets/future_filled_dropdown.dart';

class GrievanceScreen extends ConsumerStatefulWidget {
  const GrievanceScreen({super.key});

  @override
  ConsumerState<GrievanceScreen> createState() => _GrievanceScreenState();
}

class _GrievanceScreenState extends ConsumerState<GrievanceScreen> {
  var formKey = GlobalKey<FormState>();

  Widget getScaffold(HomeState state) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFBA800),
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text("तक्रार / विनंती"),
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
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: CustomFilledTextField(
                  controller: state.fullNameController,
                  labelText: "पूर्ण नाव / Full Name *",
                  validator: (value) {
                    return Validators.validateEmptyField(value);
                  },
                ),
              ),

              Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: CustomFilledTextField(
                    controller: state.mobileNumberController,
                    labelText: "मो. नंबर / Mobile Number *",
                    validator: (value) {
                      return Validators.validateEmptyField(value);
                    },
                  )),

              Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: FutureFilledDropdown(
                    items: state.talukaList,
                    controller: state.talukaController,
                    titleBuilder: (item) => item,
                    labelText: "तालुका / Tehsil",
                    validator: (value) {
                      return Validators.validateEmptyField(value);
                    },
                  )),

              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: FutureFilledDropdown(
                    items: state.gendersList,
                    controller: state.gendersController,
                    labelText: "लिंग / Gender",
                    titleBuilder: (item) => item),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  maxLines: null,
                  minLines: 3,
                  controller: state.addressController,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    labelText: "पत्ता / Address",
                    hintText: "येथे पूर्ण पत्ता टाकावा...",
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    return Validators.validateEmptyField(value);
                  },
                ),
              ),

              // Padding(
              // padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              // child: CustomFilledTextField(
              //   maxLines: 5,
              //   controller: state.complaintMessageController,
              //   labelText: "Your Message...",
              //   hintText: "Type your grievance here....",
              //   keyboardType: TextInputType.multiline,
              //   )
              // ),

              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  maxLines: null,
                  minLines: 5,
                  keyboardType: TextInputType.multiline,
                  controller: state.yourMessageController,
                  decoration: InputDecoration(
                    labelText: 'तुमचा मेसेज / Your Message...',
                    hintText: 'तक्रार नोंदवा...',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    return Validators.validateEmptyField(value);
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: CustomMultiFilePicker(
                  didChange: (files) {
                    ref
                        .read(homeControllerProvider.notifier)
                        .updateSelectedFile(files);
                    if (files != null && files.isNotEmpty) {
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Selected Files:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          ...files.map((file) => Text(file.path)).toList(),
                        ],
                      );
                    } else {
                      const Text(
                        "No files selected.",
                        style: TextStyle(color: Colors.grey),
                      );
                    }
                  },
                  labelText: "फाईल निवडा / Choose File",
                  maxFiles: 2,
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child:
                  //     Padding(
                  //   padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                  //   child: ElevatedButton(
                  //     onPressed: () async {
                  //       EasyLoading.show(status: "Saving...");
                  //       print("Save pressed");
                  //       try {
                  //         final temp = await ref
                  //             .read(homeControllerProvider.notifier)
                  //             .saveComplaint();
                  //         if (temp != null) {
                  //           EasyLoading.dismiss();
                  //           await showDialog(
                  //             context: context,
                  //             builder: (context) => AlertDialog(
                  //               title: const Text(
                  //                 "Success",
                  //                 style: TextStyle(color: Colors.green),
                  //               ),
                  //               content: const Text(
                  //                 "तुमची तक्रार नोंदवण्यात आली आहे. पुढील ४८ तासांत तुमची तक्रार आमच्या निदर्शनास घेतली जाईल.",
                  //                 style: TextStyle(
                  //                     color: Colors.black,
                  //                     fontWeight: FontWeight.bold),
                  //               ),
                  //               actions: [
                  //                 TextButton(
                  //                   onPressed: () {
                  //                     Navigator.of(context).pop();
                  //                     Navigator.of(context).pop();
                  //                   },
                  //                   child: const Text("OK"),
                  //                 ),
                  //               ],
                  //             ),
                  //           );
                  //           // Navigator.of(context).pop();
                  //         } else {
                  //           ScaffoldMessenger.of(context).showSnackBar(
                  //             SnackBar(
                  //               content: const Text(
                  //                 "Failed To Save",
                  //                 style: TextStyle(color: Colors.black),
                  //               ),
                  //               duration: const Duration(seconds: 2),
                  //               backgroundColor: Colors.red.shade600,
                  //             ),
                  //           );
                  //         }
                  //       } catch (e) {
                  //         print("Unexpected error during save: $e");
                  //         ScaffoldMessenger.of(context).showSnackBar(
                  //           SnackBar(
                  //             content: const Text(
                  //               "Something went wrong",
                  //               style: TextStyle(color: Colors.black),
                  //             ),
                  //             duration: const Duration(seconds: 2),
                  //             backgroundColor: Colors.red.shade600,
                  //           ),
                  //         );
                  //       } finally {
                  //         EasyLoading.dismiss();
                  //       }
                  //     },
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: Colors.green,
                  //     ),
                  //     child: const Text(
                  //       "Submit",
                  //       style: TextStyle(color: Colors.black),
                  //     ),
                  //   ),
                  // )
                  
                  Padding(
  padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
  child: ElevatedButton(
    onPressed: () async {
      // Validate form first
      if (formKey.currentState?.validate() ?? false) {
        EasyLoading.show(status: "Saving...");

        print("Save pressed");

        try {
          final temp = await ref
              .read(homeControllerProvider.notifier)
              .saveComplaint();

          if (temp != null) {
            EasyLoading.dismiss();

            await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text(
                  "Success",
                  style: TextStyle(color: Colors.green),
                ),
                content: const Text(
                  "तुमची तक्रार नोंदवण्यात आली आहे. पुढील ४८ तासांत तुमची तक्रार आमच्या निदर्शनास घेतली जाईल.",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: const Text("OK"),
                  ),
                ],
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  "Failed To Save",
                  style: TextStyle(color: Colors.black),
                ),
                duration: const Duration(seconds: 2),
                backgroundColor: Colors.red.shade600,
              ),
            );
          }
        } catch (e) {
          print("Unexpected error during save: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                "Something went wrong",
                style: TextStyle(color: Colors.black),
              ),
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.red.shade600,
            ),
          );
        } finally {
          EasyLoading.dismiss();
        }
      } else {
        // Show validation error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              "Please fill all required fields",
              style: TextStyle(color: Colors.black),
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.orange.shade600,
          ),
        );
      }
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.green,
    ),
    child: const Text(
      "Submit",
      style: TextStyle(color: Colors.black),
    ),
  ),
)

                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    var homeStateAsync = ref.watch(homeControllerProvider);
    return homeStateAsync.when(
        data: (state) => getScaffold(state),
        error: (error, stackTrace) => const Scaffold(
              body: Text("Something Went Wrong"),
            ),
        loading: () => const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ));
  }
}
