import 'dart:convert';

class ShoppingItem {
  final String id;
  final String name;
  final int? count;
  final double? price;
  final bool bought;
  final String? imagePath;
  ShoppingItem({
    required this.id,
    required this.name,
    this.count,
    this.price,
    this.bought = false,
    this.imagePath,
  });


  ShoppingItem copyWith({
    String? id,
    String? name,
    int? count,
    double? price,
    bool? bought,
    String? imagePath,
  }) {
    return ShoppingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      count: count ?? this.count,
      price: price ?? this.price,
      bought: bought ?? this.bought,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'count': count,
      'price': price,
      'bought': bought,
      'imagePath': imagePath,
    };
  }

  factory ShoppingItem.fromMap(Map<String, dynamic> map) {
    return ShoppingItem(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      count: map['count']?.toInt(),
      price: map['price']?.toDouble(),
      bought: map['bought'],
      imagePath: map['imagePath'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ShoppingItem.fromJson(String source) => ShoppingItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ShoppingItem(id: $id, name: $name, count: $count, price: $price, bought: $bought, imagePath: $imagePath)';
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
      other.imagePath == imagePath;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      count.hashCode ^
      price.hashCode ^
      bought.hashCode ^
      imagePath.hashCode;
  }
}
