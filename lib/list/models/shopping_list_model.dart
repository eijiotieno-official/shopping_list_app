import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:shopping_list_app/item/models/shopping_item_model.dart';

class ShoppingList {
  final String id;
  final String name;
  final Color? color;
  final List<ShoppingItem> items;
  ShoppingList({
    required this.id,
    required this.name,
    this.color,
    required this.items,
  });
 

  ShoppingList copyWith({
    String? id,
    String? name,
    Color? color,
    List<ShoppingItem>? items,
  }) {
    return ShoppingList(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color?.value,
      'items': items.map((x) => x.toMap()).toList(),
    };
  }

  factory ShoppingList.fromMap(Map<String, dynamic> map) {
    return ShoppingList(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      color: map['color'] != null ? Color(map['color']) : null,
      items: List<ShoppingItem>.from(map['items']?.map((x) => ShoppingItem.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ShoppingList.fromJson(String source) => ShoppingList.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ShoppingList(id: $id, name: $name, color: $color, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ShoppingList &&
      other.id == id &&
      other.name == name &&
      other.color == color &&
      listEquals(other.items, items);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      color.hashCode ^
      items.hashCode;
  }
}
