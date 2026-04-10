import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rajesh_dada_padvi/controllers/Screens/achievements_controller.dart';
import 'package:rajesh_dada_padvi/models/Files/files_response_model.dart';
import 'package:rajesh_dada_padvi/widgets/app_page_frame.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class AchievementsScreen extends ConsumerStatefulWidget {
  const AchievementsScreen({super.key});

  @override
  ConsumerState<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends ConsumerState<AchievementsScreen> {
  Widget getScaffold(AchievementsState state) {
    return AppPageFrame(
      title: 'कामगिरी',
      subtitle: 'Highlights and development work.',
      icon: Icons.workspace_premium_rounded,
      child: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(achievementsControllerProvider);
          await ref.read(achievementsControllerProvider.future);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: FutureBuilder<FileResponseModel?>(
            future: state.achievementsResponse,
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

              final files = snapshot.data?.files ?? [];
              if (files.isEmpty) {
                return const Center(child: Text('No data found'));
              }

              return Column(
                children: files.map((file) {
                  Uint8List? imageBytes;
                  try {
                    imageBytes = file.base64Data == null
                        ? null
                        : base64Decode(file.base64Data!);
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
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(26),
                          ),
                          child: imageBytes == null
                              ? Image.asset(
                                  'lib/assets/Icons/broken_image.png',
                                  height: 220,
                                  fit: BoxFit.cover,
                                )
                              : Image.memory(
                                  imageBytes,
                                  height: 220,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        if ((file.description ?? '').trim().isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              file.description ?? '',
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

  @override
  Widget build(BuildContext context) {
    final achievementStateAsync = ref.watch(achievementsControllerProvider);
    return achievementStateAsync.when(
      data: (state) => getScaffold(state),
      error: (error, stackTrace) =>
          const Scaffold(body: Text('Something Went Wrong')),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
