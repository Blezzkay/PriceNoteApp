// lib/services/pdf_service.dart
// Updated PdfService — parameter names match ConversionController calls exactly.

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/conversion_item.dart';

class PdfService {
  // Load fonts from assets (ensure these files exist & are declared in pubspec.yaml)
  Future<Map<String, pw.Font>> _loadFonts() async {
    final bold = pw.Font.ttf(await rootBundle.load('assets/fonts/Figtree-Bold.ttf'));
    final semiBold = pw.Font.ttf(await rootBundle.load('assets/fonts/Figtree-SemiBold.ttf'));
    final medium = pw.Font.ttf(await rootBundle.load('assets/fonts/Figtree-Medium.ttf'));
    final regular = pw.Font.ttf(await rootBundle.load('assets/fonts/Figtree-Regular.ttf'));
    final italic = pw.Font.ttf(await rootBundle.load('assets/fonts/Figtree-Italic.ttf'));
    final alt = pw.Font.ttf(await rootBundle.load('assets/fonts/NotoSans-Regular.ttf'));

    return {
      'bold': bold,
      'semiBold': semiBold,
      'medium': medium,
      'regular': regular,
      'italic': italic,
      'alt': alt,
    };
  }

  /// Generate PDF bytes
  ///
  /// NOTE: Parameter names match calls from ConversionController:
  /// - totallocalCurrency : int
  /// - totalUsd : double
  /// - localSymbol : String (e.g. '₦')
  /// - foreignSymbol : String (e.g. '$')
  Future<Uint8List> generatePdfBytes({
    required String title,
    required double rate,
    required List<ConversionItem> items,
    required int totalLocalCurrency,
    required double totalUsd,
    required String localSymbol,
    required String foreignSymbol,
  }) async {
    final pdf = pw.Document();
    final fonts = await _loadFonts();

    // Builds NumberFormat objects using provided symbols
    final localFormat = NumberFormat.currency(symbol: localSymbol, decimalDigits: 0);
    final foreignFormat = NumberFormat.currency(symbol: foreignSymbol, decimalDigits: 2);

    // Styles
    final headerStyle = pw.TextStyle(font: fonts['bold'], fontSize: 20);
    final subStyle = pw.TextStyle(font: fonts['regular'], fontSize: 12, color: PdfColor.fromInt(0xFF444444));
    final currencyStyle = pw.TextStyle(font: fonts['alt'], fontSize: 12, color: PdfColor.fromInt(0xFF444444));
    final tableHeader = pw.TextStyle(font: fonts['semiBold'], fontSize: 12);
    final totalStyle = pw.TextStyle(font: fonts['alt'], fontSize: 12, fontWeight: pw.FontWeight.bold);
    final smallItalic = pw.TextStyle(font: fonts['italic'], fontSize: 10);

    // Prepare rows
    final tableData = <List<String>>[];
    for (final it in items) {
      final converted = (rate > 0) ? (it.localAmount / rate) : 0.0;
      tableData.add([
        it.title,
        localFormat.format(it.localAmount),
        foreignFormat.format(converted),
      ]);
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(24),
        build: (ctx) => [
          // Header row
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                pw.Text(title, style: headerStyle),
                pw.SizedBox(height: 6),
                pw.Text('Generated: ${DateFormat.yMMMd().add_Hm().format(DateTime.now())}', style: subStyle),
              ]),
              pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
                pw.Text('Exchange Rate', style: tableHeader),
                pw.SizedBox(height: 4),
                // Display: 1 <foreign> = <local><rate>
                pw.Text('1 $foreignSymbol = $localSymbol${rate.toStringAsFixed(2)}', style: currencyStyle),
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
              pw.Expanded(flex: 6, child: pw.Text('Title', style: tableHeader)),
              pw.Expanded(flex: 2, child: pw.Text(localSymbol, style: tableHeader, textAlign: pw.TextAlign.right)),
              pw.Expanded(flex: 2, child: pw.Text(foreignSymbol, style: tableHeader, textAlign: pw.TextAlign.right)),
            ]),
          ),

          pw.SizedBox(height: 6),

          // Rows
          ...tableData.map((row) => pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 6),
            child: pw.Row(children: [
              pw.Expanded(flex: 6, child: pw.Text(row[0], style: subStyle)),
              pw.Expanded(flex: 2, child: pw.Text(row[1], style: currencyStyle, textAlign: pw.TextAlign.right)),
              pw.Expanded(flex: 2, child: pw.Text(row[2], style: subStyle, textAlign: pw.TextAlign.right)),
            ]),
          )),

          pw.Divider(),

          // Totals
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Expanded(flex: 6, child: pw.Container()),
              pw.Expanded(flex: 2, child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
                pw.Text('Total', style: totalStyle),
                pw.SizedBox(height: 4),
                pw.Text(localFormat.format(totalLocalCurrency), style: totalStyle),
              ])),
              pw.Expanded(flex: 2, child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
                pw.Text('', style: totalStyle),
                pw.SizedBox(height: 4),
                pw.Text(foreignFormat.format(totalUsd), style: totalStyle),
              ])),
            ],
          ),

          pw.Spacer(),
          pw.Divider(),
          pw.Align(alignment: pw.Alignment.centerLeft, child: pw.Text('This document was generated offline by your currency converter app', style: smallItalic)),
        ],
      ),
    );

    return pdf.save();
  }

  /// Save PDF to file and return path (signature matches controller expectations)
  Future<String> generateAndSavePdf({
    required String title,
    required double rate,
    required List<ConversionItem> items,
    required int totalLocalCurrency,
    required double totalUsd,
    required String localSymbol,
    required String foreignSymbol,
  }) async {
    final bytes = await generatePdfBytes(
      title: title,
      rate: rate,
      items: items,
      totalLocalCurrency: totalLocalCurrency,
      totalUsd: totalUsd,
      localSymbol: localSymbol,
      foreignSymbol: foreignSymbol,
    );

    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/breakdown_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File(path);
    await file.writeAsBytes(bytes);
    return path;
  }

  /// Share generated PDF bytes using printing package
  Future<void> sharePdf(Uint8List bytes, {required String filename}) async {
    await Printing.sharePdf(bytes: bytes, filename: filename);
  }
}
