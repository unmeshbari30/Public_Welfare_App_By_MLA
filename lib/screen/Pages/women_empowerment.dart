import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rajesh_dada_padvi/controllers/Screens/women_empowerment_controller.dart';
import 'package:rajesh_dada_padvi/models/Files/files_response_model.dart';
import 'package:rajesh_dada_padvi/l10n/app_localizations.dart';
import 'package:rajesh_dada_padvi/widgets/app_page_frame.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class WomenEmpowermentScreen extends ConsumerStatefulWidget {
  const WomenEmpowermentScreen({super.key});

  @override
  ConsumerState<WomenEmpowermentScreen> createState() =>
      _WomenEmpowermentScreenState();
}

class _WomenEmpowermentScreenState
    extends ConsumerState<WomenEmpowermentScreen> {
  Widget getScaffold(WomenEmpowermentState state) {
    return AppPageFrame(
      title: context.l10n.womenEmpowermentTitle,
      subtitle: context.l10n.womenEmpowermentSubtitle,
      icon: Icons.groups_2_rounded,
      child: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(womenEmpowermentControllerProvider);
          await ref.read(womenEmpowermentControllerProvider.future);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: FutureBuilder<FileResponseModel?>(
            future: state.getWomenEmpowermentData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  children: List.generate(
                    3,
                    (_) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(26),
                        child: Shimmer(
                          color: Colors.grey.shade500,
                          colorOpacity: 0.8,
                          child: Container(
                            height: 240,
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
              final items = snapshot.data?.files ?? [];
              if (items.isEmpty) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.55,
                  child: const Center(
                    child: Text('Failed to load data.\nPull down to retry.',
                        textAlign: TextAlign.center),
                  ),
                );
              }
              return Column(
                children: items.map((item) {
                  Uint8List? imageBytes;
                  try {
                    imageBytes = item.base64Data == null
                        ? null
                        : base64Decode(item.base64Data!);
                  } catch (_) {
                    imageBytes = null;
                  }
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius: (item.description ?? '').trim().isEmpty
                              ? BorderRadius.circular(26)
                              : const BorderRadius.vertical(
                                  top: Radius.circular(26),
                                ),
                          child: imageBytes == null
                              ? Image.asset(
                                  'lib/assets/Icons/broken_image.png',
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                )
                              : Image.memory(
                                  imageBytes,
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                ),
                        ),
                        if ((item.description ?? '').trim().isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              item.description ?? '',
                              textAlign: TextAlign.justify,
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _errorScreen() {
    return AppPageFrame(
      title: context.l10n.womenEmpowermentTitle,
      subtitle: context.l10n.womenEmpowermentSubtitle,
      icon: Icons.groups_2_rounded,
      child: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(womenEmpowermentControllerProvider);
          await ref.read(womenEmpowermentControllerProvider.future);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.55,
              child: const Center(
                child: Text('Failed to load data.\nPull down to retry.',
                    textAlign: TextAlign.center),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final womenStateAsync = ref.watch(womenEmpowermentControllerProvider);
    return womenStateAsync.when(
      data: (state) => getScaffold(state),
      error: (error, stackTrace) => _errorScreen(),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
