import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rajesh_dada_padvi/controllers/Screens/gallery_controller.dart';
import 'package:rajesh_dada_padvi/models/Files/files_response_model.dart';
import 'package:rajesh_dada_padvi/widgets/app_page_frame.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class GalleryScreen extends ConsumerStatefulWidget {
  const GalleryScreen({super.key});

  @override
  ConsumerState<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends ConsumerState<GalleryScreen> {
  Widget getScaffold(GalleryState state) {
    return AppPageFrame(
      title: 'गॅलरी',
      subtitle: 'Photos and moments from public programs.',
      icon: Icons.photo_library_rounded,
      child: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(galleryControllerProvider);
          await ref.read(galleryControllerProvider.future);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: FutureBuilder<FileResponseModel?>(
            future: state.galleryResponseData,
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
                return const Center(child: Text('No data in gallery'));
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

  @override
  Widget build(BuildContext context) {
    final galleryStateAsync = ref.watch(galleryControllerProvider);
    return galleryStateAsync.when(
      data: (state) => getScaffold(state),
      error: (error, stackTrace) =>
          const Scaffold(body: Text('Something Went Wrong')),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
