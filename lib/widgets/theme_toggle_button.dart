import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rajesh_dada_padvi/providers/theme_provider.dart';

class ThemeToggleButton extends ConsumerWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return IconButton(
      tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
      onPressed: () => ref.read(themeModeProvider.notifier).toggleTheme(),
      icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
    );
  }
}
