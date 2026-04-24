import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rajesh_dada_padvi/controllers/authentication_controller.dart';
import 'package:rajesh_dada_padvi/helpers/enum.dart';
import 'package:rajesh_dada_padvi/l10n/app_localizations.dart';
import 'package:rajesh_dada_padvi/providers/shared_preferences_provider.dart';
import 'package:rajesh_dada_padvi/screen/Login_Screens/sign_up_screen.dart';
import 'package:rajesh_dada_padvi/screen/home_screen.dart';
import 'package:rajesh_dada_padvi/widgets/custom_filled_text_field.dart';
import 'package:rajesh_dada_padvi/widgets/language_toggle_button.dart';
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
    final l10n = context.l10n;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: const [ThemeToggleButton(), LanguageToggleButton()],
      ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (exitCounter == 2) exit(0);
          exitCounter++;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.backToExit)),
          );
        },
        child: Stack(
          children: [
            // ── branded header band ──────────────────────────────────────────
            Container(
              height: 300,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primary,
                    colorScheme.primary.withValues(alpha: 0.75),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 460),
                    child: Column(
                      children: [
                        // ── logo + app name ───────────────────────────────
                        const SizedBox(height: 16),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorScheme.onPrimary,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.18),
                                blurRadius: 20,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'lib/assets/App Logos/final_app_logo.jpeg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          l10n.appBarTitle,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          l10n.appBarSubtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onPrimary.withValues(alpha: 0.8),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 28),

                        // ── form card ─────────────────────────────────────
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.10),
                                blurRadius: 32,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // greeting chip
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary.withValues(
                                    alpha: 0.10,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  l10n.loginGreeting,
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                l10n.loginTitle,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                l10n.loginSubtitle,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 28),
                              Form(
                                autovalidateMode: submitted
                                    ? AutovalidateMode.always
                                    : AutovalidateMode.disabled,
                                key: formKey,
                                child: Column(
                                  children: [
                                    CustomFilledTextField(
                                      controller: state.userName,
                                      labelText: l10n.mobileNumber,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return l10n.mobileRequired;
                                        }
                                        if (value.length != 10) {
                                          return l10n.mobileInvalid;
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    CustomFilledTextField(
                                      controller: state.password,
                                      obscureText: passwordVisible,
                                      labelText: l10n.passwordHint,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return l10n.passwordRequired;
                                        }
                                        return null;
                                      },
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          passwordVisible
                                              ? Icons.visibility_off_rounded
                                              : Icons.visibility_rounded,
                                        ),
                                        onPressed: () => setState(
                                          () => passwordVisible =
                                              !passwordVisible,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Theme(
                                      data: theme.copyWith(
                                        checkboxTheme: CheckboxThemeData(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                        ),
                                      ),
                                      child: CheckboxListTile(
                                        value: rememberMe,
                                        contentPadding: EdgeInsets.zero,
                                        dense: true,
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        title: Text(
                                          l10n.rememberMe,
                                          style: theme.textTheme.bodyMedium,
                                        ),
                                        onChanged: (value) => setState(
                                          () => rememberMe = value ?? false,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 52,
                                      child: FilledButton(
                                        style: FilledButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                        ),
                                        onPressed: () async {
                                          setState(() => submitted = true);
                                          if (!formKey.currentState!.validate()) {
                                            return;
                                          }
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
                                                sharedPreferencesProvider
                                                    .future,
                                              );
                                              await prefs.setBool(
                                                PrefrencesKeyEnum.rememberMe
                                                    .key,
                                                rememberMe,
                                              );
                                              await prefs.setBool(
                                                PrefrencesKeyEnum.isLoggedin
                                                    .key,
                                                true,
                                              );
                                              if (!mounted) return;
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content:
                                                      Text(l10n.loginSuccess),
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
                                                SnackBar(
                                                  content: Text(l10n.loginFailed2),
                                                ),
                                              );
                                            }
                                          } finally {
                                            EasyLoading.dismiss();
                                          }
                                        },
                                        child: Text(
                                          l10n.loginButton,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 52,
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                        ),
                                        onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const SignUpScreen(),
                                          ),
                                        ),
                                        child: Text(
                                          l10n.createAccount,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
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
          ],
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
      data: (state) => getScaffold(state),
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: AlertDialog(
            title: Text(context.l10n.somethingWentWrongTitle),
            content: Text(error.toString()),
          ),
        ),
      ),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
