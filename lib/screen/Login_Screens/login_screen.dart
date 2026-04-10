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
import 'package:rajesh_dada_padvi/widgets/theme_toggle_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  bool rememberMe = false;
  bool passwordVisible = true;
  int exitCounter = 1;
  bool submitted = false;

  Widget getScaffold(AuthenticationState state) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(actions: const [ThemeToggleButton()]),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (exitCounter == 2) {
            exit(0);
          }
          exitCounter++;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Press back again to exit')),
          );
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: theme.colorScheme.outlineVariant,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.account_balance_rounded,
                              color: theme.colorScheme.primary,
                              size: 30,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Welcome back',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Login to access citizen services, grievance support, and local updates.',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Form(
                            autovalidateMode: submitted
                                ? AutovalidateMode.always
                                : AutovalidateMode.disabled,
                            key: formKey,
                            child: Column(
                              children: [
                                CustomFilledTextField(
                                  controller: state.userName,
                                  labelText: 'Mobile Number',
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
                                  labelText: 'Password',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    return null;
                                  },
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      passwordVisible
                                          ? Icons.visibility_off_rounded
                                          : Icons.visibility_rounded,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        passwordVisible = !passwordVisible;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(height: 8),
                                CheckboxListTile(
                                  value: rememberMe,
                                  contentPadding: EdgeInsets.zero,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  title: const Text('Remember me'),
                                  onChanged: (value) {
                                    setState(() {
                                      rememberMe = value ?? false;
                                    });
                                  },
                                ),
                                const SizedBox(height: 12),
                                FilledButton(
                                  onPressed: () async {
                                    setState(() {
                                      submitted = true;
                                    });

                                    if (formKey.currentState!.validate()) {
                                      EasyLoading.show();
                                      try {
                                        final loginResult = await ref
                                            .read(
                                              authenticationControllerProvider
                                                  .notifier,
                                            )
                                            .loginUser();

                                        if (loginResult != null) {
                                          final prefs = await ref.watch(
                                            sharedPreferencesProvider.future,
                                          );
                                          await prefs.setBool(
                                            PrefrencesKeyEnum.rememberMe.key,
                                            rememberMe,
                                          );
                                          await prefs.setBool(
                                            PrefrencesKeyEnum.isLoggedin.key,
                                            true,
                                          );

                                          if (!mounted) return;
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text('Login successful'),
                                            ),
                                          );
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const HomeScreen(),
                                            ),
                                          );
                                        } else {
                                          if (!mounted) return;
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text('Login failed'),
                                            ),
                                          );
                                        }
                                      } finally {
                                        EasyLoading.dismiss();
                                      }
                                    }
                                  },
                                  child: const Text('Login'),
                                ),
                                const SizedBox(height: 12),
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SignUpScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text('Create New Account'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
    final asyncAuthenticationState = ref.watch(
      authenticationControllerProvider,
    );

    return asyncAuthenticationState.when(
      data: (authenticationState) => getScaffold(authenticationState),
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
