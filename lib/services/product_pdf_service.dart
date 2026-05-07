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
  // ── Colors ────────────────────────────────────────────────────────────────
  static const _brand      = PdfColor.fromInt(0xFF3A6B4E);
  static const _brandLight = PdfColor.fromInt(0xFFE8F5EE);
  static const _dark       = PdfColor.fromInt(0xFF111827);
  static const _grey       = PdfColor.fromInt(0xFF6B7280);
  static const _divider    = PdfColor.fromInt(0xFFE5E7EB);
  static const _tableHead  = PdfColor.fromInt(0xFF3A6B4E);
  static const _rowAlt     = PdfColor.fromInt(0xFFF9FAFB);

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
    final now   = DateFormat('MMM d, yyyy').format(DateTime.now());

    // ── Styles ───────────────────────────────────────────────────────────────
    final sBrandLabel = pw.TextStyle(font: fonts['semiBold'], fontSize: 9,  color: _brand, letterSpacing: 1.2);
    final sTitle      = pw.TextStyle(font: fonts['bold'],     fontSize: 26, color: _dark);
    final sDate       = pw.TextStyle(font: fonts['regular'],  fontSize: 10, color: _grey);
    final sColHead    = pw.TextStyle(font: fonts['semiBold'], fontSize: 10, color: PdfColors.white);
    final sRowItem    = pw.TextStyle(font: fonts['regular'],  fontSize: 10, color: _dark);
    final sRowAmt     = pw.TextStyle(font: fonts['alt'],      fontSize: 10, color: _brand);
    final sTotalLabel = pw.TextStyle(font: fonts['bold'],     fontSize: 11, color: PdfColors.white, letterSpacing: 1.0);
    final sTotalAmt   = pw.TextStyle(font: fonts['altBold'],  fontSize: 13, color: PdfColors.white);
    final sFooter     = pw.TextStyle(font: fonts['italic'],   fontSize: 8,  color: _grey);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 48, vertical: 40),
        theme: pw.ThemeData.withFont(
          base:      fonts['regular']!,
          bold:      fonts['bold']!,
          italic:    fonts['italic']!,
          boldItalic: fonts['bold']!,
        ),
        build: (ctx) => [

          // ── Top bar: PRICENOTE branding ───────────────────────────────────
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Row(
                children: [
                  pw.Container(width: 3, height: 14, color: _brand),
                  pw.SizedBox(width: 6),
                  pw.Text('PRICENOTE', style: sBrandLabel),
                ],
              ),
            ],
          ),

          pw.SizedBox(height: 20),

          // ── Project title ─────────────────────────────────────────────────
          pw.Text(title, style: sTitle),
          pw.SizedBox(height: 6),
          pw.Text(now, style: sDate),

          pw.SizedBox(height: 6),

          // ── Divider under title ───────────────────────────────────────────
          pw.Container(height: 1, color: _divider),

          pw.SizedBox(height: 28),

          // ── Table ─────────────────────────────────────────────────────────
          pw.Table(
            columnWidths: {
              0: const pw.FixedColumnWidth(28),   // #
              1: const pw.FlexColumnWidth(6),     // Item
              2: const pw.FlexColumnWidth(3),     // Amount
            },
            children: [

              // Header row
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: _tableHead),
                children: [
                  _cell('#',      sColHead, pw.TextAlign.center, top: 10, bottom: 10, left: 12, right: 6),
                  _cell('Item',   sColHead, pw.TextAlign.left,   top: 10, bottom: 10, left: 8,  right: 8),
                  _cell('Total',  sColHead, pw.TextAlign.right,  top: 10, bottom: 10, left: 8,  right: 12),
                ],
              ),

              // Data rows
              ...List.generate(items.length, (i) {
                final item     = items[i];
                final rowColor = i.isEven ? PdfColors.white : _rowAlt;
                final isLast   = i == items.length - 1;

                return pw.TableRow(
                  decoration: pw.BoxDecoration(
                    color: rowColor,
                    border: pw.Border(
                      bottom: pw.BorderSide(
                        color: isLast ? _divider : _divider,
                        width: 0.5,
                      ),
                    ),
                  ),
                  children: [
                    _cell('${i + 1}', sRowItem.copyWith(color: _grey), pw.TextAlign.center, top: 11, bottom: 11, left: 12, right: 6),
                    _cell(item.title, sRowItem, pw.TextAlign.left,   top: 11, bottom: 11, left: 8,  right: 8),
                    _cell(fmt.format(item.amount), sRowAmt, pw.TextAlign.right, top: 11, bottom: 11, left: 8, right: 12),
                  ],
                );
              }),
            ],
          ),

          pw.SizedBox(height: 0),

          // ── Total bar ─────────────────────────────────────────────────────
          pw.Container(
            color: _brand,
            padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('TOTAL', style: sTotalLabel),
                pw.Text(fmt.format(total), style: sTotalAmt),
              ],
            ),
          ),

          pw.SizedBox(height: 32),
        ],

        // ── Footer on every page ─────────────────────────────────────────────
        footer: (ctx) => pw.Column(
          children: [
            pw.Divider(color: _divider, thickness: 0.5),
            pw.SizedBox(height: 4),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Generated by Price Note', style: sFooter),
                pw.Text(
                  'Page ${ctx.pageNumber} of ${ctx.pagesCount}',
                  style: sFooter,
                ),
              ],
            ),
          ],
        ),
      ),
    );

    return pdf.save();
  }

  // ── Helper: table cell ────────────────────────────────────────────────────
  static pw.Widget _cell(
      String text,
      pw.TextStyle style,
      pw.TextAlign align, {
        double top    = 8,
        double bottom = 8,
        double left   = 8,
        double right  = 8,
      }) {
    return pw.Padding(
      padding: pw.EdgeInsets.fromLTRB(left, top, right, bottom),
      child: pw.Text(text, style: style, textAlign: align),
    );
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