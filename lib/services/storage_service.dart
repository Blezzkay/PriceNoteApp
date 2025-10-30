// storage_service.dart
// Extended Hive wrapper for saving rate, currencies, conversion items, and product price items.

import 'package:hive_flutter/hive_flutter.dart';
import '../models/conversion_item.dart';
import '../models/product_item.dart'; // 👈 create this model for price/product data

class StorageService {
  final String _boxName = 'konvbox';

  // ---------------------- EXCHANGE DATA ----------------------
  final String _rateKey = 'rate';
  final String _itemsKey = 'items';
  final String _localCurrencyKey = 'localCurrency';
  final String _foreignCurrencyKey = 'foreignCurrency';

  // 💱 Save rate (double)
  Future<void> saveRate(double value) async {
    final box = Hive.box(_boxName);
    await box.put(_rateKey, value);
  }

  // 💱 Retrieve rate
  Future<double?> getRate() async {
    final box = Hive.box(_boxName);
    final dynamic val = box.get(_rateKey);
    if (val == null) return null;

    // Handle double/int conversion
    if (val is int) return val.toDouble();
    if (val is double) return val;
    return double.tryParse(val.toString());
  }

  // 💵 Save items (list of ConversionItem)
  Future<void> saveItems(List<ConversionItem> items) async {
    final box = Hive.box(_boxName);
    final list = items.map((e) => e.toMap()).toList();
    await box.put(_itemsKey, list);
  }

  // 💵 Retrieve items
  Future<List<ConversionItem>> getItems() async {
    final box = Hive.box(_boxName);
    final dynamic raw = box.get(_itemsKey);
    if (raw == null) return [];

    try {
      final List loaded = raw as List;
      return loaded
          .map((e) => ConversionItem.fromMap(Map<dynamic, dynamic>.from(e)))
          .toList();
    } catch (e) {
      // If stored format is unexpected, return empty list
      return [];
    }
  }

  // 🌍 Save local currency code (e.g., "NGN")
  Future<void> saveLocalCurrency(String code) async {
    final box = Hive.box(_boxName);
    await box.put(_localCurrencyKey, code);
  }

  // 🌍 Get local currency code
  Future<String?> getLocalCurrency() async {
    final box = Hive.box(_boxName);
    final val = box.get(_localCurrencyKey);
    if (val == null) return null;
    return val.toString();
  }

  // 💶 Save foreign currency code (e.g., "USD")
  Future<void> saveForeignCurrency(String code) async {
    final box = Hive.box(_boxName);
    await box.put(_foreignCurrencyKey, code);
  }

  // 💶 Get foreign currency code
  Future<String?> getForeignCurrency() async {
    final box = Hive.box(_boxName);
    final val = box.get(_foreignCurrencyKey);
    if (val == null) return null;
    return val.toString();
  }

  // 🧹 Clear everything (optional reset)
  Future<void> clearAll() async {
    final box = Hive.box(_boxName);
    await box.delete(_itemsKey);
    await box.delete(_rateKey);
    await box.delete(_localCurrencyKey);
    await box.delete(_foreignCurrencyKey);
    await box.delete(_productItemsKey);
    await box.delete(_productCurrencyKey);
  }

  // ---------------------- PRODUCT PRICE DATA ----------------------

  final String _productItemsKey = 'productItems';
  final String _productCurrencyKey = 'productCurrency';

  // 🛍 Save product list (List<ProductItem>)
  Future<void> saveProductItems(List<ProductItem> items) async {
    final box = Hive.box(_boxName);
    final list = items.map((e) => e.toMap()).toList();
    await box.put(_productItemsKey, list);
  }

  // 🛍 Get product list
  Future<List<ProductItem>> getProductItems() async {
    final box = Hive.box(_boxName);
    final dynamic raw = box.get(_productItemsKey);
    if (raw == null) return [];

    try {
      final List loaded = raw as List;
      return loaded
          .map((e) => ProductItem.fromMap(Map<dynamic, dynamic>.from(e)))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // 💲 Save product currency (e.g., "USD")
  Future<void> saveProductCurrency(String code) async {
    final box = Hive.box(_boxName);
    await box.put(_productCurrencyKey, code);
  }

  // 💲 Get product currency
  Future<String?> getProductCurrency() async {
    final box = Hive.box(_boxName);
    final val = box.get(_productCurrencyKey);
    if (val == null) return null;
    return val.toString();
  }
}
