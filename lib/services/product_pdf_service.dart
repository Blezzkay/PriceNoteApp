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
  // ── Brand colors ──────────────────────────────────────────────────────────
  static const _brand       = PdfColor.fromInt(0xFF4F46E5);
  static const _brandLight  = PdfColor.fromInt(0xFFEEEDFD);
  static const _dark        = PdfColor.fromInt(0xFF111827);
  static const _grey        = PdfColor.fromInt(0xFF6B7280);
  static const _greyLight   = PdfColor.fromInt(0xFFF3F4F6);
  static const _divider     = PdfColor.fromInt(0xFFE5E7EB);
  static const _white       = PdfColors.white;
  static const _rowAlt      = PdfColor.fromInt(0xFFFAFAFF);

  Future<Map<String, pw.Font>> _loadFonts() async {
    return {
      'bold':     pw.Font.ttf(await rootBundle.load('assets/fonts/Figtree-Bold.ttf')),
      'semiBold': pw.Font.ttf(await rootBundle.load('assets/fonts/Figtree-SemiBold.ttf')),
      'medium':   pw.Font.ttf(await rootBundle.load('assets/fonts/Figtree-Medium.ttf')),
      'regular':  pw.Font.ttf(await rootBundle.load('assets/fonts/Figtree-Regular.ttf')),
      'italic':   pw.Font.ttf(await rootBundle.load('assets/fonts/Figtree-Italic.ttf')),
      'alt':      pw.Font.ttf(await rootBundle.load('assets/fonts/NotoSans-Regular.ttf')),
      'altBold':  pw.Font.ttf(await rootBundle.load('assets/fonts/NotoSans-Bold.ttf')),
    };
  }

  Future<Uint8List> generatePdfBytes({
    required String title,
    required List<ProductItem> items,
    required String currencySymbol,
  }) async {
    final pdf   = pw.Document();
    final fonts = await _loadFonts();
    final fmt   = NumberFormat.currency(symbol: currencySymbol, decimalDigits: 0);
    final total = items.fold<int>(0, (s, i) => s + i.amount);
    final now   = DateFormat('dd MMM yyyy  •  hh:mm a').format(DateTime.now());

    // ── Text styles ──────────────────────────────────────────────────────────
    final sTitle      = pw.TextStyle(font: fonts['bold'],    fontSize: 22, color: _white);
    final sSubtitle   = pw.TextStyle(font: fonts['regular'], fontSize: 10, color: _white.flatten());
    final sColHead    = pw.TextStyle(font: fonts['semiBold'],fontSize: 10, color: _grey);
    final sRowTitle   = pw.TextStyle(font: fonts['medium'],  fontSize: 11, color: _dark);
    final sRowAmt     = pw.TextStyle(font: fonts['alt'],     fontSize: 11, color: _dark);
    final sTotalLabel = pw.TextStyle(font: fonts['semiBold'],fontSize: 12, color: _grey);
    final sTotalAmt   = pw.TextStyle(font: fonts['altBold'], fontSize: 16, color: _brand);
    final sFooter     = pw.TextStyle(font: fonts['italic'],  fontSize: 9,  color: _grey);
    final sBadge      = pw.TextStyle(font: fonts['semiBold'],fontSize: 9,  color: _brand);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (ctx) => [

          // ── Hero header band ─────────────────────────────────────────────
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.fromLTRB(32, 36, 32, 30),
            decoration: const pw.BoxDecoration(color: _brand),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      child: pw.Text(title, style: sTitle),
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: pw.BoxDecoration(
                        color: _white.flatten(),
                        borderRadius: pw.BorderRadius.circular(20),
                      ),
                      child: pw.Text(
                        '${items.length} item${items.length == 1 ? '' : 's'}',
                        style: sBadge,
                      ),
                    ),
                  ],
                ),

                pw.SizedBox(height: 8),

                pw.Row(
                  children: [
                    pw.Text('Generated  $now', style: sSubtitle),
                  ],
                ),

                pw.SizedBox(height: 20),

                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromInt(0x33FFFFFF),
                    borderRadius: pw.BorderRadius.circular(10),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'Total Value',
                        style: pw.TextStyle(font: fonts['medium'], fontSize: 11, color: _white.flatten()),
                      ),
                      pw.Text(
                        fmt.format(total),
                        style: pw.TextStyle(font: fonts['altBold'], fontSize: 15, color: _white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Body padding wrapper ─────────────────────────────────────────
          pw.Padding(
            padding: const pw.EdgeInsets.fromLTRB(32, 28, 32, 0),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [

                pw.Text(
                  'PRICE BREAKDOWN',
                  style: pw.TextStyle(
                    font: fonts['semiBold'],
                    fontSize: 9,
                    color: _brand,
                    letterSpacing: 1.4,
                  ),
                ),
                pw.SizedBox(height: 10),

                // ── Table ──────────────────────────────────────────────────
                pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: _divider, width: 1),
                    borderRadius: pw.BorderRadius.circular(10),
                  ),
                  child: pw.ClipRRect(
                    horizontalRadius: 10,
                    verticalRadius: 10,
                    child: pw.Column(
                      children: [

                        // Column headers
                        pw.Container(
                          color: _greyLight,
                          padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: pw.Row(
                            children: [
                              pw.Expanded(flex: 1, child: pw.Text('#', style: sColHead)),
                              pw.Expanded(flex: 6, child: pw.Text('Product', style: sColHead)),
                              pw.Expanded(
                                flex: 3,
                                child: pw.Text('Amount', style: sColHead, textAlign: pw.TextAlign.right),
                              ),
                            ],
                          ),
                        ),

                        // ── FIX: color moved inside BoxDecoration ──────────
                        ...List.generate(items.length, (i) {
                          final item     = items[i];
                          final isLast   = i == items.length - 1;
                          final rowColor = i.isEven ? _white : _rowAlt;

                          return pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                            decoration: pw.BoxDecoration(
                              color: rowColor,
                              border: isLast
                                  ? null
                                  : pw.Border(
                                bottom: pw.BorderSide(color: _divider, width: 0.5),
                              ),
                            ),
                            child: pw.Row(
                              children: [
                                pw.Expanded(
                                  flex: 1,
                                  child: pw.Text(
                                    '${i + 1}',
                                    style: pw.TextStyle(
                                      font: fonts['regular'],
                                      fontSize: 10,
                                      color: _grey,
                                    ),
                                  ),
                                ),
                                pw.Expanded(
                                  flex: 6,
                                  child: pw.Text(item.title, style: sRowTitle),
                                ),
                                pw.Expanded(
                                  flex: 3,
                                  child: pw.Text(
                                    fmt.format(item.amount),
                                    style: sRowAmt,
                                    textAlign: pw.TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),

                pw.SizedBox(height: 20),

                // ── Total row ──────────────────────────────────────────────
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: pw.BoxDecoration(
                    color: _brandLight,
                    borderRadius: pw.BorderRadius.circular(10),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Grand Total', style: sTotalLabel),
                          pw.SizedBox(height: 2),
                          pw.Text(
                            '${items.length} product${items.length == 1 ? '' : 's'} combined',
                            style: pw.TextStyle(
                              font: fonts['regular'],
                              fontSize: 9,
                              color: _grey,
                            ),
                          ),
                        ],
                      ),
                      pw.Text(fmt.format(total), style: sTotalAmt),
                    ],
                  ),
                ),
              ],
            ),
          ),

          pw.Spacer(),

          // ── Footer ────────────────────────────────────────────────────────
          pw.Padding(
            padding: const pw.EdgeInsets.fromLTRB(32, 0, 32, 24),
            child: pw.Column(
              children: [
                pw.Divider(color: _divider, thickness: 0.8),
                pw.SizedBox(height: 6),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Generated by Price Note', style: sFooter),
                    pw.Text(now, style: sFooter),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return pdf.save();
  }

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
    final dir  = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/price_breakdown_${DateTime.now().millisecondsSinceEpoch}.pdf';
    await File(path).writeAsBytes(bytes);
    return path;
  }

  Future<void> sharePdf(Uint8List bytes, {required String filename}) async {
    await Printing.sharePdf(bytes: bytes, filename: filename);
  }
}