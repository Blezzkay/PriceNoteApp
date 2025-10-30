import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/conversion_item.dart';
import '../services/storage_service.dart';
import '../services/pdf_service.dart';
import 'dart:typed_data';

class ConversionController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();
  final PdfService _pdfService = Get.find<PdfService>();

  // Exchange rate: localCurrency = rate × foreignCurrency(1)
  RxDouble rate = 1000.0.obs;

  // Selected currencies
  RxString localCurrency = 'NGN'.obs;
  RxString foreignCurrency = 'USD'.obs;

  // Symbols map (add more if you like)
  final Map<String, String> currencySymbols = {
    'USD': '\$',    // US Dollar
    'NGN': '₦',    // Nigerian Naira
    'EUR': '€',    // Euro
    'GBP': '£',    // British Pound
    'GHS': '₵',    // Ghanaian Cedi
    'ZAR': 'R',    // South African Rand
    'KES': 'KSh',  // Kenyan Shilling
    'INR': '₹',    // Indian Rupee
    'JPY': '¥',    // Japanese Yen
  };

  // Observable list of ConversionItem
  RxList<ConversionItem> items = <ConversionItem>[].obs;

  final NumberFormat numberFormat = NumberFormat('#,##0.00', 'en_US');

  @override
  void onInit() {
    super.onInit();
    _loadFromStorage();
  }

  // 🧩 Load persisted rate + currency settings + items
  Future<void> _loadFromStorage() async {
    final savedRate = await _storage.getRate();
    final savedLocal = await _storage.getLocalCurrency();
    final savedForeign = await _storage.getForeignCurrency();
    final savedItems = await _storage.getItems();

    if (savedRate != null) rate.value = savedRate;
    if (savedLocal != null) localCurrency.value = savedLocal;
    if (savedForeign != null) foreignCurrency.value = savedForeign;
    items.assignAll(savedItems);
  }

  // 🏦 Set currencies and persist
  Future<void> setLocalCurrency(String newCurrency) async {
    localCurrency.value = newCurrency;
    await _storage.saveLocalCurrency(newCurrency);
  }

  Future<void> setForeignCurrency(String newCurrency) async {
    foreignCurrency.value = newCurrency;
    await _storage.saveForeignCurrency(newCurrency);
  }

  // 💱 Set exchange rate (local = rate × 1 foreign)
  Future<void> setRate(double newRate) async {
    if (newRate <= 0) return;
    rate.value = newRate;
    await _storage.saveRate(newRate);
  }

  // 🧾 CRUD: Items
  Future<void> addItem(ConversionItem item) async {
    items.add(item);
    await _storage.saveItems(items);
  }

  Future<void> updateItem(ConversionItem updated) async {
    final index = items.indexWhere((e) => e.id == updated.id);
    if (index == -1) return;
    items[index] = updated;
    items.refresh();
    await _storage.saveItems(items);
  }

  Future<void> removeItem(String id) async {
    items.removeWhere((e) => e.id == id);
    await _storage.saveItems(items);
  }

  // 🧮 Totals
  int get totalLocal => items.fold(0, (s, e) => s + e.localAmount); // rename to local
  double get totalForeign =>
      (rate.value > 0) ? (totalLocal / rate.value) : 0.0;

  // 💬 Formatted text for UI
  String get localSymbol => currencySymbols[localCurrency.value] ?? '';
  String get foreignSymbol => currencySymbols[foreignCurrency.value] ?? '';

  String formattedLocal(int value) =>
      '$localSymbol${numberFormat.format(value)}';

  String formattedForeignFromLocal(int value) {
    double converted = (rate.value > 0) ? value / rate.value : 0.0;
    return '$foreignSymbol${numberFormat.format(converted)}';
  }

  // ================= PDF =================
  Future<Uint8List> getPdfBytesForPreview() async {
    return await _pdfService.generatePdfBytes(
      title:
      '${localCurrency.value} → ${foreignCurrency.value} Breakdown',
      rate: rate.value,
      items: items.toList(),
      totalLocalCurrency: totalLocal,
      totalUsd: totalForeign,
      localSymbol: localSymbol,
      foreignSymbol: foreignSymbol,
    );
  }

  Future<String> generatePdfAndSave() async {
    return await _pdfService.generateAndSavePdf(
      title:
      '${localCurrency.value} → ${foreignCurrency.value} Breakdown',
      rate: rate.value,
      items: items.toList(),
      totalLocalCurrency: totalLocal,
      totalUsd: totalForeign,
      localSymbol: localSymbol,
      foreignSymbol: foreignSymbol,
    );
  }

  Future<void> sharePdf() async {
    final bytes = await getPdfBytesForPreview();
    await _pdfService.sharePdf(
      bytes,
      filename:
      'breakdown_${localCurrency.value}_${foreignCurrency.value}_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }
}
