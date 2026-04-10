import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:rajesh_dada_padvi/controllers/home_controller.dart';
import 'package:rajesh_dada_padvi/helpers/enum.dart';
import 'package:rajesh_dada_padvi/widgets/app_page_frame.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CertificateScreen extends ConsumerStatefulWidget {
  const CertificateScreen({super.key});

  @override
  ConsumerState<CertificateScreen> createState() => _CertificateScreenState();
}

class _CertificateScreenState extends ConsumerState<CertificateScreen> {
  String? firstName;
  String? lastName;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      firstName = prefs.getString(PrefrencesKeyEnum.firstName.key);
      lastName = prefs.getString(PrefrencesKeyEnum.lastName.key);
    });
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    bool useFallbackImage = false;
    final homeState = await ref.read(homeControllerProvider.future);
    final certificate = await homeState.certificateDataResponse;
    final base64String = certificate?.files?.first.base64Data;
    Uint8List? imageBytes;

    if (base64String == null || base64String.trim().isEmpty) {
      useFallbackImage = true;
    } else {
      try {
        imageBytes = base64Decode(base64String);
      } catch (_) {
        useFallbackImage = true;
      }
    }

    final pdf = pw.Document();
    final image = useFallbackImage
        ? pw.MemoryImage(
            (await rootBundle.load(
              'lib/assets/Certificates/certificate_img.jpeg',
            )).buffer.asUint8List(),
          )
        : pw.MemoryImage(imageBytes!);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              pw.Positioned.fill(child: pw.Image(image, fit: pw.BoxFit.cover)),
              pw.Positioned(
                left: 200,
                top: 180,
                child: pw.Text(
                  '$firstName $lastName',
                  style: pw.TextStyle(font: pw.Font.timesBold(), fontSize: 24),
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return AppPageFrame(
      title: 'Certificate',
      subtitle: 'Preview and download your certificate.',
      icon: Icons.verified_rounded,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: PdfPreview(
                    build: _generatePdf,
                    allowPrinting: false,
                    allowSharing: true,
                    canChangePageFormat: false,
                    canChangeOrientation: false,
                    padding: const EdgeInsets.all(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                Printing.layoutPdf(onLayout: _generatePdf);
              },
              icon: const Icon(Icons.download_rounded),
              label: const Text('Download Certificate'),
            ),
          ],
        ),
      ),
    );
  }
}
