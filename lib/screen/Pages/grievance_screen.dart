import 'package:flutter/material.dart';
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

Widget getScaffold(HomeState state){
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Color(0xFFFBA800),
      automaticallyImplyLeading: true,
      centerTitle: true,
      title: Text("तक्रार / विनंती"),
    ),

    body: SafeArea(child: 
    SingleChildScrollView(
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: formKey,
        child: Column(
          children: [
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: CustomFilledTextField(
                controller: state.fullNameController,
                labelText: "Full Name *",
                validator: (value) {
                  return Validators.validateEmptyField(value);
                },
              ),
            ),

          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: CustomFilledTextField(
              controller: state.mobileNumberController,
              labelText: "Mobile Number *",
              validator: (value) {
                return Validators.validateEmptyField(value);
              },
              )
            ),

            Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: FutureFilledDropdown(
              items: state.TalukaList,
              controller: state.talukaController,
              titleBuilder: (item) => item,
              labelText: "Taluka",
              validator: (value) {
                return Validators.validateEmptyField(value);
              },
              )
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: FutureFilledDropdown(
                  items: state.gendersList,
                  controller: state.gendersController,
                  labelText: "Choose Gender",
                  titleBuilder: (item) => item),
            ),

            // Padding(
            // padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            // child: CustomFilledTextField(
            //   controller: state.locationController,
            //   labelText: "Location *",
            //   validator: (value) {
            //     return Validators.validateEmptyField(value);
            //   },
            //   )
            // ),

            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                  maxLines: null, 
                  minLines: 3,
                  
                  controller: state.locationController ,   
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    hintText: 'Enter Full Address here...',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  //  validator: (value) {
                  //     return Validators.validateEmptyField(value);
                  //   },
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
              child: TextField(
                  maxLines: null, 
                  minLines: 5,   
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    labelText: 'Your Message...',
                    hintText: 'Type your grievance here...',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),
            ),
        
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: CustomMultiFilePicker(
                // controller: ,
                didChange: (value) {
                  ref.read(homeControllerProvider.notifier).updateSelectedFile(value);
                  
                },
                labelText: "Choose File",
                maxFiles: 2,
              ),
            ),


            Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
        child: ElevatedButton(
          onPressed: () {
            print("Save pressed");
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
          child: const Text("Submit", style: TextStyle(color: Colors.black),),
        ),
      ),
    ),

    SizedBox(width: 10,),
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
          child: const Text("Cancel", style: TextStyle(color: Colors.black),),
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
      error:  (error, stackTrace) => const Scaffold(
              body: Text("Something Went Wrong"),
            ), 
      loading:  () => const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ));

  }
}