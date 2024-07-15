import 'dart:convert';

import 'package:flutter/foundation.dart';

class ShoppingItem {
  final String id;
  final String name;
  final int count;
  final double price;
  final bool bought;
  final List<int> imageData;
  ShoppingItem({
    required this.id,
    required this.name,
    required this.count,
    required this.price,
    required this.bought,
    required this.imageData,
  });

  ShoppingItem copyWith({
    String? id,
    String? name,
    int? count,
    double? price,
    bool? bought,
    List<int>? imageData,
  }) {
    return ShoppingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      count: count ?? this.count,
      price: price ?? this.price,
      bought: bought ?? this.bought,
      imageData: imageData ?? this.imageData,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'count': count,
      'price': price,
      'bought': bought,
      'imageData': imageData,
    };
  }

  factory ShoppingItem.fromMap(Map<String, dynamic> map) {
    return ShoppingItem(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      count: map['count']?.toInt() ?? 0,
      price: map['price']?.toDouble() ?? 0.0,
      bought: map['bought'] ?? false,
      imageData: List<int>.from(map['imageData']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ShoppingItem.fromJson(String source) => ShoppingItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ShoppingItem(id: $id, name: $name, count: $count, price: $price, bought: $bought, imageData: $imageData)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ShoppingItem &&
      other.id == id &&
      other.name == name &&
      other.count == count &&
      other.price == price &&
      other.bought == bought &&
      listEquals(other.imageData, imageData);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      count.hashCode ^
      price.hashCode ^
      bought.hashCode ^
      imageData.hashCode;
  }
}
