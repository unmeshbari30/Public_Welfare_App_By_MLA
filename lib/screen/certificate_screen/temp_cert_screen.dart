import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';

class CertificateScreen extends StatelessWidget {
  const CertificateScreen({Key? key}) : super(key: key);

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document();
    final image = await imageFromAssetBundle('lib/assets/splash_screen_img.png');
    final marathiFont = await PdfGoogleFonts.notoSansDevanagariRegular();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              pw.Positioned.fill(child: pw.Image(image, fit: pw.BoxFit.cover)),

              // Marathi Text
              pw.Positioned(
                left: 150,
                top: 300,
                child: pw.Text(
                  'आपले हार्दिक अभिनंदन!',
                  style: pw.TextStyle(font: marathiFont, fontSize: 24),
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
    return Scaffold(
      appBar: AppBar(title: const Text("Certificate Generator")),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            Printing.layoutPdf(onLayout: _generatePdf);
          },
          icon: const Icon(Icons.download),
          label: const Text("Download Certificate"),
        ),
      ),
    );
  }
}
