// conversion_item.dart
// Model for a conversion row / line item.
// Uses simple Map serialization for Hive storage.

import 'package:uuid/uuid.dart';

class ConversionItem {
  // Unique id for edits/deletes
  String id;
  String title;
  int localAmount; // stored as whole localAmount (int). Change to kobo if you want cents.

  ConversionItem({
    required this.id,
    required this.title,
    required this.localAmount,
  });

  // Create a new item with generated id
  factory ConversionItem.create({required String title, required int localAmount}) {
    return ConversionItem(id: const Uuid().v4(), title: title, localAmount: localAmount);
  }

  // Map conversion for storing in Hive box (no TypeAdapter)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'localAmount': localAmount,
    };
  }

  // Recreate from map
  factory ConversionItem.fromMap(Map<dynamic, dynamic> map) {
    return ConversionItem(
      id: map['id'] as String,
      title: map['title'] as String,
      localAmount: map['localAmount'] as int,
    );
  }
}
