import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rajesh_dada_padvi/controllers/Screens/rajesh_info_controller.dart';
import 'package:rajesh_dada_padvi/models/Files/mla_info_model.dart';
import 'package:rajesh_dada_padvi/widgets/app_page_frame.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class RajeshDadaInfoScreen extends ConsumerStatefulWidget {
  const RajeshDadaInfoScreen({super.key});

  @override
  ConsumerState<RajeshDadaInfoScreen> createState() =>
      _RajeshDadaInfoScreenState();
}

class _RajeshDadaInfoScreenState extends ConsumerState<RajeshDadaInfoScreen> {
  Widget getScaffold(RajeshInfoState state) {
    return AppPageFrame(
      title: 'आपले राजेश दादा',
      subtitle: 'Profile and background information.',
      icon: Icons.account_box_rounded,
      child: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(rajeshInfoControllerProvider);
          await ref.read(rajeshInfoControllerProvider.future);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: FutureBuilder<MlaInfoModel?>(
            future: state.mlaInfoModel,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: Shimmer(
                        child: Container(
                          height: 280,
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(26),
                      child: Shimmer(
                        child: Container(
                          height: 320,
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ],
                );
              }
              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(
                  child: Text('Failed to load data. Pull down to refresh.'),
                );
              }
              final model = snapshot.data!;
              Uint8List? imageBytes;
              try {
                imageBytes = model.mlaInfo?.base64Data == null
                    ? null
                    : base64Decode(model.mlaInfo!.base64Data!);
              } catch (_) {
                imageBytes = null;
              }
              return Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: imageBytes == null
                        ? Image.asset(
                            'lib/assets/Icons/broken_image.png',
                            height: 280,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Image.memory(
                            imageBytes,
                            height: 280,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                    child: Text(
                      formatParagraphs(model.mlaInfo?.aboutText ?? ''),
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        height: 1.6,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  String formatParagraphs(String text) {
    final indent = '\u00A0\u00A0\u00A0\u00A0';
    return text.split('\n').map((paragraph) => '$indent$paragraph').join('\n');
  }

  @override
  Widget build(BuildContext context) {
    final rajeshInfoStateAsync = ref.watch(rajeshInfoControllerProvider);
    return rajeshInfoStateAsync.when(
      data: (state) => getScaffold(state),
      error: (error, stackTrace) =>
          const Scaffold(body: Text('Something Went Wrong')),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
