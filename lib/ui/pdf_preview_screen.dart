// pdf_preview_screen.dart
// Optional: simple screen that generates a PDF and opens the system preview via printing package.

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../controllers/conversion_controller.dart';

class PdfPreviewScreen extends StatelessWidget {
  const PdfPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ConversionController c = Get.find<ConversionController>();

    return Scaffold(
      appBar: AppBar(title: const Text('PDF Preview')),
      body: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            const Text('Preview the PDF before sharing or saving.'),
            SizedBox(height: 2.h),
            ElevatedButton(
              onPressed: () async {
                // Generate pdf bytes and preview
                // final bytes = await Get.find<ConversionController>()._pdfPreviewBytes(); // private helper not available
                // Note: The controller doesn't expose bytes directly in current implementation. If you want preview, use:
                final Uint8List pdfBytes = await Get.find<ConversionController>().getPdfBytesForPreview();
                await Printing.layoutPdf(onLayout: (format) => pdfBytes);
              },
              child: const Text('Preview PDF'),
            ),
          ],
        ),
      ),
    );
  }
}
