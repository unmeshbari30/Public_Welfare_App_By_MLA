import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rajesh_dada_padvi/controllers/home_controller.dart';
import 'package:rajesh_dada_padvi/helpers/validators.dart';
import 'package:rajesh_dada_padvi/l10n/app_localizations.dart';
import 'package:rajesh_dada_padvi/widgets/app_page_frame.dart';
import 'package:rajesh_dada_padvi/widgets/custom_filled_text_field.dart';
import 'package:rajesh_dada_padvi/widgets/custom_multi_file_picker.dart';
import 'package:rajesh_dada_padvi/widgets/future_filled_dropdown.dart';

class GrievanceScreen extends ConsumerStatefulWidget {
  const GrievanceScreen({super.key});

  @override
  ConsumerState<GrievanceScreen> createState() => _GrievanceScreenState();
}

class _GrievanceScreenState extends ConsumerState<GrievanceScreen> {
  final formKey = GlobalKey<FormState>();

  Widget getScaffold(HomeState state) {
    return AppPageFrame(
      title: context.l10n.grievanceTitle,
      subtitle: context.l10n.grievanceSubtitle,
      icon: Icons.edit_note_rounded,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: formKey,
          child: Column(
            children: [
              CustomFilledTextField(
                controller: state.fullNameController,
                labelText: 'पूर्ण नाव / Full Name *',
                validator: Validators.validateEmptyField,
              ),
              const SizedBox(height: 14),
              CustomFilledTextField(
                controller: state.mobileNumberController,
                labelText: 'मो. नंबर / Mobile Number *',
                validator: Validators.validateMobileNumber,
              ),
              const SizedBox(height: 14),
              FutureFilledDropdown(
                items: state.talukaList,
                controller: state.talukaController,
                titleBuilder: (item) => item,
                labelText: 'तालुका / Tehsil',
                validator: Validators.validateEmptyField,
              ),
              const SizedBox(height: 14),
              FutureFilledDropdown(
                items: state.gendersList,
                controller: state.gendersController,
                labelText: 'लिंग / Gender',
                titleBuilder: (item) => item,
              ),
              const SizedBox(height: 14),
              CustomFilledTextField(
                controller: state.addressController,
                labelText: 'पत्ता / Address',
                hintText: 'येथे पूर्ण पत्ता टाका...',
                maxLines: 3,
                validator: Validators.validateEmptyField,
              ),
              const SizedBox(height: 14),
              CustomFilledTextField(
                controller: state.yourMessageController,
                labelText: 'तुमचा मेसेज / Your Message',
                hintText: 'तक्रार नोंदवा...',
                maxLines: 5,
                validator: Validators.validateEmptyField,
              ),
              const SizedBox(height: 14),
              CustomMultiFilePicker(
                onlyImages: true,
                didChange: (files) {
                  ref
                      .read(homeControllerProvider.notifier)
                      .updateSelectedFile(files);
                },
                labelText: 'फाईल निवडा / Choose File',
                maxFiles: 2,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: FilledButton(
                        onPressed: () async {
                          if (formKey.currentState?.validate() ?? false) {
                            EasyLoading.show(status: 'Saving...');
                            try {
                              final temp = await ref
                                  .read(homeControllerProvider.notifier)
                                  .saveComplaint();

                              if (temp != null) {
                                if (!mounted) return;
                                await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Success'),
                                    content: const Text(
                                      'तुमची तक्रार नोंदवण्यात आली आहे. पुढील 48 तासांत ती आमच्या निदर्शनास घेतली जाईल.',
                                    ),
                                    actions: [
                                      FilledButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Failed to save'),
                                  ),
                                );
                              }
                            } finally {
                              EasyLoading.dismiss();
                            }
                          } else {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please fill all required fields',
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text('Submit'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          shape: const StadiumBorder(),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeStateAsync = ref.watch(homeControllerProvider);
    return homeStateAsync.when(
      data: (state) => getScaffold(state),
      error: (error, stackTrace) =>
          const Scaffold(body: Center(child: Text('Something Went Wrong'))),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
