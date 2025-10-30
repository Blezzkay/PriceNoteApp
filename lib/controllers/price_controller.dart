import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/product_item.dart';
import '../services/storage_service.dart';
import '../services/product_pdf_service.dart';

class PriceController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();
  final ProductPdfService _pdfService = Get.find<ProductPdfService>();

  // Selected currency
  RxString currency = 'USD'.obs;

  // Supported currency symbols
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

  // Product list
  RxList<ProductItem> products = <ProductItem>[].obs;

  final NumberFormat numberFormat = NumberFormat('#,##0.00', 'en_US');

  @override
  void onInit() {
    super.onInit();
    _loadFromStorage();
  }

  // 🧩 Load persisted data
  Future<void> _loadFromStorage() async {
    final savedCurrency = await _storage.getProductCurrency();
    final savedProducts = await _storage.getProductItems();

    if (savedCurrency != null) currency.value = savedCurrency;
    products.assignAll(savedProducts);
  }

  // 💰 Change currency
  Future<void> setCurrency(String newCurrency) async {
    currency.value = newCurrency;
    await _storage.saveProductCurrency(newCurrency);
  }

  // ➕ Add new product
  Future<void> addProduct(ProductItem item) async {
    products.add(item);
    await _storage.saveProductItems(products.toList());
  }

  // ✏️ Update product
  Future<void> updateProduct(ProductItem updated) async {
    final index = products.indexWhere((e) => e.id == updated.id);
    if (index == -1) return;
    products[index] = updated;
    products.refresh();
    await _storage.saveProductItems(products.toList());
  }

  // 🗑️ Remove product
  Future<void> removeProduct(String id) async {
    products.removeWhere((e) => e.id == id);
    await _storage.saveProductItems(products.toList());
  }

  // 🧮 Total calculation
  int get totalAmount => products.fold(0, (sum, e) => sum + e.amount);

  // 💬 Formatting helpers
  String get currencySymbol => currencySymbols[currency.value] ?? '';

  String formattedAmount(int value) =>
      '$currencySymbol${numberFormat.format(value)}';

  // ================= 🧾 PDF =================

  /// Generate bytes for preview
  Future<Uint8List> getPdfBytesForPreview() async {
    return await _pdfService.generatePdfBytes(
      title: '${currency.value} Product Price Breakdown',
      items: products.toList(),
      currencySymbol: currencySymbol,
    );
  }

  /// Generate and save PDF to file
  Future<String> generatePdfAndSave() async {
    return await _pdfService.generateAndSavePdf(
      title: '${currency.value} Product Price Breakdown',
      items: products.toList(),
      currencySymbol: currencySymbol,
    );
  }

  /// Share generated PDF
  Future<void> sharePdf() async {
    final bytes = await getPdfBytesForPreview();
    await _pdfService.sharePdf(
      bytes,
      filename:
      'price_breakdown_${currency.value}_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }
}
