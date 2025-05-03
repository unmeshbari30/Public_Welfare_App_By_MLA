// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

// class CertificateScreen extends StatefulWidget {
//   const CertificateScreen({super.key});

//   @override
//   State<CertificateScreen> createState() => _CertificateScreenState();
// }

// class _CertificateScreenState extends State<CertificateScreen> {
//   final GlobalKey _globalKey = GlobalKey();

//   Future<Uint8List> _captureWidgetAsImage() async {
//     RenderRepaintBoundary boundary =
//         _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

//     ui.Image image = await boundary.toImage(pixelRatio: 3.0);
//     ByteData? byteData =
//         await image.toByteData(format: ui.ImageByteFormat.png);

//     return byteData!.buffer.asUint8List();
//   }

//   Future<Uint8List> _generateCertificate() async {
//     final imageBytes = await _captureWidgetAsImage();
//     final pdf = pw.Document();

//     final capturedImage = pw.MemoryImage(imageBytes);

//     pdf.addPage(
//   pw.Page(
//     pageFormat: PdfPageFormat.a4.landscape,
//     build: (context) {
//       return pw.Image(
//         capturedImage, 
//         fit: pw.BoxFit.contain, // This will ensure the image fills the page
//         width: PdfPageFormat.a4.width, // Use the width of A4 landscape
//         // height: PdfPageFormat.a4.height, // Use the height of A4 landscape
//       );
//     },
//   ),
// );

//     return pdf.save();
//   }

//   Widget _buildCertificateWidget() {
//     return RepaintBoundary(
//       key: _globalKey,
//       child: Container(
//         width: 1600,

//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.orange, width: 5),
//           color: Colors.white,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Image.asset('lib/assets/Icons/app_icon.jpeg', width: 60, height: 60),
//                 const Text(
//                   'CERTIFICATE',
//                   style: TextStyle(
//                     fontSize: 30,
//                     color: Colors.orange,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Image.asset('lib/assets/Icons/app_icon.jpeg', width: 60, height: 60),
//               ],
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               "चिंटू मिंटू",
//               style: TextStyle(fontSize: 18),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               "प्रदेश ____ को आज दिनांक ____ को मोदी मित्र नियुक्त होने पर हार्दिक अभिनंदन।",
//               style: TextStyle(fontSize: 16),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 15),
//             const Text(
//               "आशा है कि आप विश्व नेता यशस्वी प्रधानमंत्री श्री नरेंद्र मोदी जी द्वारा भारत को विश्व गुरु बनाने में सहभागि बनेंगे।",
//               style: TextStyle(fontSize: 16),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 30),
//             Image.asset('lib/assets/Icons/app_icon.jpeg', width: 60, height: 60),
//             const SizedBox(height: 10),
//             const Text(
//               'BHARATIYA JANATA PARTY\nMINORITY MORCHA',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 5),
//             const Text(
//               'www.rajeshDada.bjp.org',
//               style: TextStyle(fontSize: 14),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Certificate No: ____',
//               style: TextStyle(fontSize: 14),
//             ),
//             const SizedBox(height: 30),
//             const Align(
//               alignment: Alignment.centerRight,
//               child: Text(
//                 "जावेद सिद्दीकी\nराष्ट्रीय अध्यक्ष",
//                 style: TextStyle(fontSize: 14),
//                 textAlign: TextAlign.right,
//               ),
//             ),
//             const SizedBox(height: 20),
//             const Divider(),
//             const Text(
//               'CENTRAL OFFICE: 6-A, Pandit Deen Dayal Upadhyaya Marg, New Delhi-110002.',
//               style: TextStyle(fontSize: 12),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Certificate Generator')),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               const SizedBox(height: 20),
//               _buildCertificateWidget(),
//               const SizedBox(height: 40),
//               ElevatedButton(
//                 onPressed: () async {
//                   final pdfData = await _generateCertificate();
//                   await Printing.layoutPdf(
//                       onLayout: (PdfPageFormat format) async => pdfData);
//                 },
//                 child: const Text('Generate Certificate PDF'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
