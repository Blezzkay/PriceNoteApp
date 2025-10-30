import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/product_item.dart';

class ProductPdfService {
  // Load fonts from assets
  Future<Map<String, pw.Font>> _loadFonts() async {
    final bold = pw.Font.ttf(await rootBundle.load('assets/fonts/Figtree-Bold.ttf'));
    final semiBold = pw.Font.ttf(await rootBundle.load('assets/fonts/Figtree-SemiBold.ttf'));
    final medium = pw.Font.ttf(await rootBundle.load('assets/fonts/Figtree-Medium.ttf'));
    final regular = pw.Font.ttf(await rootBundle.load('assets/fonts/Figtree-Regular.ttf'));
    final italic = pw.Font.ttf(await rootBundle.load('assets/fonts/Figtree-Italic.ttf'));
    final alt = pw.Font.ttf(await rootBundle.load('assets/fonts/NotoSans-Regular.ttf '));

    return {
      'bold': bold,
      'semiBold': semiBold,
      'medium': medium,
      'regular': regular,
      'italic': italic,
      'alt': alt,
    };
  }

  /// Generate PDF bytes for product & price breakdown
  Future<Uint8List> generatePdfBytes({
    required String title,
    required List<ProductItem> items,
    required String currencySymbol,
  }) async {
    final pdf = pw.Document();
    final fonts = await _loadFonts();

    final currencyFormat = NumberFormat.currency(symbol: currencySymbol, decimalDigits: 0);

    final headerStyle = pw.TextStyle(font: fonts['bold'], fontSize: 20);
    final subStyle = pw.TextStyle(font: fonts['regular'], fontSize: 12, color: PdfColor.fromInt(0xFF444444));
    final currencyStyle = pw.TextStyle(font: fonts['alt'], fontSize: 12, color: PdfColor.fromInt(0xFF444444));
    final tableHeader = pw.TextStyle(font: fonts['semiBold'], fontSize: 12);
    final totalStyle = pw.TextStyle(font: fonts['alt'], fontSize: 12, fontWeight: pw.FontWeight.bold);
    final smallItalic = pw.TextStyle(font: fonts['italic'], fontSize: 10);

    // Compute total
    final total = items.fold<int>(0, (sum, item) => sum + item.amount);

    // Table data
    final tableData = items
        .map((it) => [it.title, currencyFormat.format(it.amount)])
        .toList();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(24),
        build: (ctx) => [
          // Header
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                pw.Text(title, style: headerStyle),
                pw.SizedBox(height: 6),
                pw.Text('Generated: ${DateFormat.yMMMd().add_Hm().format(DateTime.now())}', style: subStyle),
              ]),
            ],
          ),

          pw.SizedBox(height: 16),

          // Table header
          pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border(bottom: pw.BorderSide(width: 1, color: PdfColor.fromInt(0xFFDDDDDD))),
            ),
            padding: const pw.EdgeInsets.only(bottom: 6),
            child: pw.Row(children: [
              pw.Expanded(flex: 6, child: pw.Text('Product', style: tableHeader)),
              pw.Expanded(flex: 3, child: pw.Text('Amount', style: tableHeader, textAlign: pw.TextAlign.right)),
            ]),
          ),

          pw.SizedBox(height: 6),

          // Rows
          ...tableData.map((row) => pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 6),
            child: pw.Row(children: [
              pw.Expanded(flex: 6, child: pw.Text(row[0], style: subStyle)),
              pw.Expanded(flex: 3, child: pw.Text(row[1], style: currencyStyle, textAlign: pw.TextAlign.right)),
            ]),
          )),

          pw.Divider(),

          // Total
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Expanded(flex: 6, child: pw.Container()),
              pw.Expanded(
                flex: 3,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('Total', style: totalStyle),
                    pw.SizedBox(height: 4),
                    pw.Text(currencyFormat.format(total), style: totalStyle),
                  ],
                ),
              ),
            ],
          ),

          pw.Spacer(),
          pw.Divider(),
          pw.Align(
            alignment: pw.Alignment.centerLeft,
            child: pw.Text(
              'Generated offline by your product price breakdown app',
              style: smallItalic,
            ),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  /// Save PDF to file and return its path
  Future<String> generateAndSavePdf({
    required String title,
    required List<ProductItem> items,
    required String currencySymbol,
  }) async {
    final bytes = await generatePdfBytes(
      title: title,
      items: items,
      currencySymbol: currencySymbol,
    );

    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/price_breakdown_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File(path);
    await file.writeAsBytes(bytes);
    return path;
  }

  /// Share generated PDF
  Future<void> sharePdf(Uint8List bytes, {required String filename}) async {
    await Printing.sharePdf(bytes: bytes, filename: filename);
  }
}
