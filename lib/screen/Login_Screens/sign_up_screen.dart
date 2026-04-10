import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rajesh_dada_padvi/controllers/authentication_controller.dart';
import 'package:rajesh_dada_padvi/helpers/validators.dart';
import 'package:rajesh_dada_padvi/widgets/custom_filled_text_field.dart';
import 'package:rajesh_dada_padvi/widgets/future_filled_dropdown.dart';
import 'package:rajesh_dada_padvi/widgets/theme_toggle_button.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final formKey = GlobalKey<FormState>();

  Widget getScaffold(AuthenticationState state) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        actions: const [ThemeToggleButton()],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Create an account',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Register once to access public services, certificates, and grievance support.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 24),
                      CustomFilledTextField(
                        controller: state.firstNameController,
                        labelText: 'पहिले नाव / First Name *',
                        validator: Validators.validateEmptyField,
                      ),
                      const SizedBox(height: 14),
                      CustomFilledTextField(
                        controller: state.middleNameController,
                        labelText: 'मधले नाव / Middle Name',
                      ),
                      const SizedBox(height: 14),
                      CustomFilledTextField(
                        controller: state.lastNameController,
                        labelText: 'आडनाव / Last Name *',
                        validator: Validators.validateEmptyField,
                      ),
                      const SizedBox(height: 14),
                      Column(
                        children: [
                          FutureFilledDropdown(
                            items: state.gendersList,
                            controller: state.gendersController,
                            labelText: 'लिंग / Gender *',
                            titleBuilder: (item) => item,
                            validator: Validators.validateEmptyField,
                          ),
                          const SizedBox(height: 14),
                          FutureFilledDropdown(
                            items: state.tehsilList,
                            controller: state.tehsilController,
                            labelText: 'तालुका / Taluka *',
                            titleBuilder: (item) => item,
                            validator: Validators.validateEmptyField,
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final useTwoColumns = constraints.maxWidth >= 420;

                          if (!useTwoColumns) {
                            return Column(
                              children: [
                                CustomFilledTextField(
                                  controller: state.ageController,
                                  labelText: 'वय / Age *',
                                  keyboardType: TextInputType.number,
                                  validator: Validators.validateEmptyField,
                                ),
                                const SizedBox(height: 14),
                                FutureFilledDropdown(
                                  items: state.bloodGroup,
                                  controller: state.bloodGroupController,
                                  labelText: 'रक्त गट / Blood Group *',
                                  titleBuilder: (item) => item,
                                  validator: Validators.validateEmptyField,
                                ),
                              ],
                            );
                          }

                          return Row(
                            children: [
                              Expanded(
                                child: CustomFilledTextField(
                                  controller: state.ageController,
                                  labelText: 'वय / Age *',
                                  keyboardType: TextInputType.number,
                                  validator: Validators.validateEmptyField,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: FutureFilledDropdown(
                                  items: state.bloodGroup,
                                  controller: state.bloodGroupController,
                                  labelText: 'रक्त गट / Blood Group *',
                                  titleBuilder: (item) => item,
                                  validator: Validators.validateEmptyField,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 14),
                      CustomFilledTextField(
                        controller: state.emailController,
                        labelText: 'ईमेल / Email',
                      ),
                      const SizedBox(height: 14),
                      CustomFilledTextField(
                        controller: state.whatsappNumberController,
                        labelText: 'व्हॉट्सॲप नं. / Whatsapp No.',
                        validator: Validators.validateMobileNumber,
                      ),
                      const SizedBox(height: 14),
                      CustomFilledTextField(
                        controller: state.mobileNumberController,
                        labelText: 'मो. नंबर / Mobile Number *',
                        validator: Validators.validateMobileNumber,
                      ),
                      const SizedBox(height: 14),
                      CustomFilledTextField(
                        controller: state.passwordController,
                        labelText: 'नवीन पासवर्ड/ New Password *',
                        validator: Validators.validateEmptyField,
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            try {
                              EasyLoading.show();
                              final successful = await ref
                                  .read(
                                    authenticationControllerProvider.notifier,
                                  )
                                  .userRegistration();
                              if (successful?.isRegistered == true) {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      successful?.message ?? 'Registered',
                                    ),
                                  ),
                                );
                                Navigator.pop(context);
                              } else {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      successful?.message ??
                                          'Something went wrong',
                                    ),
                                  ),
                                );
                              }
                            } finally {
                              EasyLoading.dismiss();
                            }
                          }
                        },
                        child: const Text('रजिस्टर / Register'),
                      ),
                    ],
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
    final asyncSignUpState = ref.watch(authenticationControllerProvider);
    return asyncSignUpState.when(
      data: (state) => getScaffold(state),
      error: (error, stackTrace) {
        return Scaffold(
          body: Center(
            child: AlertDialog(
              title: const Text('Something went wrong'),
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
