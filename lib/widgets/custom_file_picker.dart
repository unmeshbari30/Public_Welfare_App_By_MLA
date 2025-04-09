import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class CustomFilePicker extends StatefulWidget {
  final TextEditingController? controller;
  final void Function(File? value)? didChange;
  final String? Function(String?)? validator;
  final String? labelText;

  const CustomFilePicker({
    super.key,
    this.controller,
    this.validator,
    this.labelText,
    this.didChange,
  });

  @override
  State<CustomFilePicker> createState() => _CustomFilePickerState();
}

class _CustomFilePickerState extends State<CustomFilePicker> {
  final String initMsg = "No File Chosen";
  final GlobalKey<FormFieldState<File>> _fileFormFieldKey = GlobalKey<FormFieldState<File>>();
  final FocusNode focusNode = FocusNode();
  final TextEditingController fileNameController = TextEditingController(text: "No File Chosen");

  void invokeDidChanged(FormFieldState<File?> field, File? file) {
    if (file != null) {
      widget.didChange?.call(file);
      field.didChange(file);
      fileNameController.text = file.path.split('/').last;
    } else {
      fileNameController.text = initMsg;
      field.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: const EdgeInsets.all(0),
      elevation: 2,
      // color: Theme.of(context).appBarTheme.backgroundColor,
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Transform.scale(
        scale: 1.01,
        child: FormField<File?>(
          onSaved: (newValue) {},
          builder: (field) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        flex: 8,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: TextField(
                            controller: fileNameController,
                            decoration: InputDecoration(
                              // fillColor: Theme.of(context).colorScheme.secondary,
                              labelText: widget.labelText,
                              labelStyle: const TextStyle(
                                fontSize: 17,
                              ),
                              filled: true,
                              border: InputBorder.none,
                              enabled: false,
                              // errorStyle: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
                              // floatingLabelStyle: TextStyle(
                              //   fontWeight: FontWeight.normal,
                              //   color: Colors.black.withOpacity(0.75),
                              // ),
                            ),
                            textAlign: TextAlign.start,
                            // style: const TextStyle(
                            //   fontSize: 17,
                            //  color: Colors.black,
                            // ),
                          ),
                        )),
                    Visibility(
                      visible: field.value != null,
                      child: IconButton(
                          onPressed: () {
                            invokeDidChanged(field, null);
                          },
                          icon: const Icon(
                            Icons.cancel,
                          )),
                    ),
                    InkWell(
                      onTap: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles();

                        if (result != null && result.files.single.path != null) {
                          File file = File(result.files.single.path!);
                          invokeDidChanged(field, file);
                        } else {
                          invokeDidChanged(field, null);
                        }
                      },
                      child: Card(
                          margin: EdgeInsets.all(0),
                          shape: LinearBorder(),
                          elevation: 0,
                          // color: Colors.transparent,
                          child: SizedBox(
                              height: 49.8,
                              width: 49.8,
                              child: Icon(
                                Icons.attach_file_rounded,
                                color: Theme.of(context).appBarTheme.foregroundColor,
                              ))),
                    ),
                  ],
                ),
                // Visibility(
                //   visible: field.value != null,
                //   child: Align(
                //     alignment: Alignment.centerRight,
                //     child: IconButton(
                //         onPressed: () {
                //           invokeDidChanged(field, null);
                //         },
                //         icon: const Icon(
                //           Icons.cancel,
                //         )),
                //   ),
                // )
              ],
            );
          },
        ),
      ),
    );
  }
}
