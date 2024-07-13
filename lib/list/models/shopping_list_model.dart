import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:shopping_list_app/item/models/shopping_item_model.dart';

class ShoppingList {
  final String id;
  final String title;
  final Color? color;
  final List<ShoppingItem> items;
  ShoppingList({
    required this.id,
    required this.title,
    this.color,
    required this.items,
  });
 

  ShoppingList copyWith({
    String? id,
    String? title,
    Color? color,
    List<ShoppingItem>? items,
  }) {
    return ShoppingList(
      id: id ?? this.id,
      title: title ?? this.title,
      color: color ?? this.color,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'color': color?.value,
      'items': items.map((x) => x.toMap()).toList(),
    };
  }

  factory ShoppingList.fromMap(Map<String, dynamic> map) {
    return ShoppingList(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      color: map['color'] != null ? Color(map['color']) : null,
      items: List<ShoppingItem>.from(map['items']?.map((x) => ShoppingItem.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ShoppingList.fromJson(String source) => ShoppingList.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ShoppingList(id: $id, title: $title, color: $color, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ShoppingList &&
      other.id == id &&
      other.title == title &&
      other.color == color &&
      listEquals(other.items, items);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      color.hashCode ^
      items.hashCode;
  }
}
