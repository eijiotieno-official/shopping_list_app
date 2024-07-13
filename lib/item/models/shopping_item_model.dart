import 'dart:convert';

class ShoppingItem {
  final String id;
  final String text;
  final int count;
  final double price;
  final bool bought;
  final String imagePath;
  ShoppingItem({
    required this.id,
    required this.text,
    required this.count,
    required this.price,
    required this.bought,
    required this.imagePath,
  });

  ShoppingItem copyWith({
    String? id,
    String? text,
    int? count,
    double? price,
    bool? bought,
    String? imagePath,
  }) {
    return ShoppingItem(
      id: id ?? this.id,
      text: text ?? this.text,
      count: count ?? this.count,
      price: price ?? this.price,
      bought: bought ?? this.bought,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'count': count,
      'price': price,
      'bought': bought,
      'imagePath': imagePath,
    };
  }

  factory ShoppingItem.fromMap(Map<String, dynamic> map) {
    return ShoppingItem(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      count: map['count']?.toInt() ?? 0,
      price: map['price']?.toDouble() ?? 0.0,
      bought: map['bought'] ?? false,
      imagePath: map['imagePath'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ShoppingItem.fromJson(String source) =>
      ShoppingItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ShoppingItem(id: $id, text: $text, count: $count, price: $price, bought: $bought, imagePath: $imagePath)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ShoppingItem &&
        other.id == id &&
        other.text == text &&
        other.count == count &&
        other.price == price &&
        other.bought == bought &&
        other.imagePath == imagePath;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        text.hashCode ^
        count.hashCode ^
        price.hashCode ^
        bought.hashCode ^
        imagePath.hashCode;
  }
}
