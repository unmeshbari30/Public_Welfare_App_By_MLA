import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rajesh_dada_padvi/helpers/enum.dart';
import 'package:rajesh_dada_padvi/providers/shared_preferences_provider.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((
  ref,
) {
  return ThemeModeNotifier(ref);
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(this.ref) : super(ThemeMode.light) {
    _loadThemeMode();
  }

  final Ref ref;

  Future<void> _loadThemeMode() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    final savedMode = prefs.getString(PrefrencesKeyEnum.themeMode.key);
    if (savedMode == ThemeMode.dark.name) {
      state = ThemeMode.dark;
      return;
    }
    state = ThemeMode.light;
  }

  Future<void> toggleTheme() async {
    final nextMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    state = nextMode;
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setString(PrefrencesKeyEnum.themeMode.key, nextMode.name);
  }
}
