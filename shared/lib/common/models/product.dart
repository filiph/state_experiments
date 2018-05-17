import 'dart:ui' show Color;

class Product {
  /// The unique identifier of the product.
  final int id;

  /// The default text to display.
  final String name;

  /// A color associated with the product.
  final Color color;

  const Product(this.id, this.name, this.color);

  @override
  int get hashCode => id;

  @override
  bool operator ==(other) => other is Product && other.hashCode == hashCode;

  @override
  String toString() => "$name (id=$id)";
}
