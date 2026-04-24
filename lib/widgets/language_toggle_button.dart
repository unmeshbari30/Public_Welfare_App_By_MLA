import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rajesh_dada_padvi/providers/locale_provider.dart';

class LanguageToggleButton extends ConsumerWidget {
  const LanguageToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final isMr = locale.languageCode == 'mr';

    return IconButton(
      tooltip: isMr ? 'Switch to English' : 'मराठीत बदला',
      onPressed: () {
        ref
            .read(localeProvider.notifier)
            .setLocale(isMr ? const Locale('en') : const Locale('mr'));
      },
      icon: Text(
        isMr ? 'EN' : 'म',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
