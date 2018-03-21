import 'package:reactive_exploration/src/product.dart';

class Cart {
  final Map<Product, int> _contents = {};

  void add(Product product, [int count = 1]) {
    _contents[product] = _contents.putIfAbsent(product, () => 0) + count;
  }

  void remove(Product product, [int count = 1]) {
    _contents[product] = _contents.putIfAbsent(product, () => count) - count;
  }

  Map<Product, int> get state => new Map.unmodifiable(_contents);
}
