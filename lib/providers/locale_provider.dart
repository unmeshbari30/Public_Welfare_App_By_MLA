import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rajesh_dada_padvi/helpers/enum.dart';
import 'package:rajesh_dada_padvi/providers/shared_preferences_provider.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier(ref);
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier(this.ref) : super(const Locale('mr')) {
    _loadLocale();
  }

  final Ref ref;

  Future<void> _loadLocale() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    final saved = prefs.getString(PrefrencesKeyEnum.language.key);
    state = saved != null ? Locale(saved) : const Locale('mr');
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setString(PrefrencesKeyEnum.language.key, locale.languageCode);
  }
}
