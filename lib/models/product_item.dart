import 'package:uuid/uuid.dart';

class ProductItem {
  String id;
  String title;
  int amount; // stored as integer, e.g. cents or naira

  ProductItem({
    required this.id,
    required this.title,
    required this.amount,
  });

  // Factory for new item
  factory ProductItem.create({required String title, required int amount}) {
    return ProductItem(id: const Uuid().v4(), title: title, amount: amount);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
    };
  }

  factory ProductItem.fromMap(Map<dynamic, dynamic> map) {
    return ProductItem(
      id: map['id'] as String,
      title: map['title'] as String,
      amount: map['amount'] as int,
    );
  }
}
