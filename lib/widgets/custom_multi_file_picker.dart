import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class CustomMultiFilePicker extends StatefulWidget {
  final TextEditingController? controller;
  final void Function(List<File>? value)? didChange;
  final String? Function(String?)? validator;
  final String? labelText;
  final int? maxFiles;
  final bool onlyImages;

  const CustomMultiFilePicker({super.key, this.controller, this.validator, this.labelText, this.didChange, this.maxFiles,  this.onlyImages = false,});

  @override
  State<CustomMultiFilePicker> createState() => _CustomFilledMultiFilePickerState();
}

class _CustomFilledMultiFilePickerState extends State<CustomMultiFilePicker> {
  final String initMsg = "No File Chosen";
  final FocusNode focusNode = FocusNode();
  List<File> selectedFiles = [];

  void updateFiles(List<File>? files) {
    setState(() {
      selectedFiles = files ?? [];
    });
    widget.didChange?.call(selectedFiles);
  }

  void removeFile(File file) {
    setState(() {
      selectedFiles.remove(file);
    });
    widget.didChange?.call(selectedFiles);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: const EdgeInsets.all(0),
      elevation: 2,
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: TextEditingController(
                      text: 
                          selectedFiles.isNotEmpty
                              ? "Selected Files:" //selectedFiles.map((f) => f.path.split('/').last).join(', ')
                              : initMsg,
                    ),
                    decoration: InputDecoration(
                      labelText: widget.labelText,
                      // filled: true,
                      // border: InputBorder.,
                      enabled: false,
                    ),
                  ),
                ),

                // InkWell(
                //   onTap: () async {
                //     FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true, );

                //     if (result != null && result.paths.isNotEmpty) {
                //       List<File> files = result.paths.whereType<String>().map((path) => File(path)).toList();
                //       updateFiles(files);
                //     }
                //   },
                //   child: const Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.attach_file_rounded)),
                // ),

                 InkWell(
                  onTap: () async {
                    final int? max = widget.maxFiles;
                    final int currentCount = selectedFiles.length;

                    if (max != null && currentCount >= max) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("You can only select up to $max files.")),
                      );
                      return;
                    }

                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                      allowMultiple: true,
                      type: widget.onlyImages ? FileType.image : FileType.any,
                    );

                    if (result != null && result.paths.isNotEmpty) {
                      List<File> newFiles = result.paths
                          .whereType<String>()
                          .map((path) => File(path))
                          .toList();

                      if (max != null) {
                        int remaining = max - currentCount;
                        if (newFiles.length > remaining) {
                          newFiles = newFiles.sublist(0, remaining);
                        }
                      }

                      updateFiles([...selectedFiles, ...newFiles]);
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.attach_file_rounded),
                  ),
                ),
              ],
            ),
          ),
          if (selectedFiles.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    selectedFiles
                        .map(
                          (file) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(file.path.split('/').last),
                              ),
                              IconButton(onPressed: () => removeFile(file), icon: const Icon(Icons.close)),
                            ],
                          ),
                        )
                        .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
