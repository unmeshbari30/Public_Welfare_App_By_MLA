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
import 'package:rajesh_dada_padvi/l10n/app_localizations.dart';
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
  Uint8List? _cachedPdfBytes;

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
    if (_cachedPdfBytes != null) return _cachedPdfBytes!;

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
              pw.Positioned.fill(child: pw.Image(image, fit: pw.BoxFit.fitWidth)),
              pw.Positioned(
                top: 400,
                left: 0,
                right: 0,
                child: pw.Center(
                  child: pw.Text(
                    '${firstName ?? ''} ${lastName ?? ''}'.trim(),
                    style: pw.TextStyle(
                      font: pw.Font.timesBold(),
                      fontSize: 20,
                      color: PdfColors.black,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    _cachedPdfBytes = await pdf.save();
    return _cachedPdfBytes!;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    return AppPageFrame(
      title: l10n.certificate,
      subtitle: l10n.certificateSubtitle,
      icon: Icons.verified_rounded,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          children: [
            Expanded(
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: colorScheme.outlineVariant,
                  ),
                  color: colorScheme.surfaceContainerLow,
                ),
                child: PdfPreview(
                  build: _generatePdf,
                  allowPrinting: false,
                  allowSharing: false,
                  canChangePageFormat: false,
                  canChangeOrientation: false,
                  padding: EdgeInsets.zero,
                  pdfPreviewPageDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  Printing.layoutPdf(onLayout: _generatePdf);
                },
                icon: const Icon(Icons.download_rounded),
                label: Text(l10n.downloadCertificate),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
