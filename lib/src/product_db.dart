import 'dart:async';
import 'dart:ui';

import 'product.dart';

const List<Product> _products = const <Product>[
  const Product(42, "Sweater", const Color.fromRGBO(2, 90, 60, 1.0)),
  const Product(1337, "Shawl", const Color.fromRGBO(90, 250, 3, 1.0)),
  const Product(1024, "Socks", const Color.fromRGBO(250, 240, 16, 1.0)),
  const Product(123, "Jacket", const Color.fromRGBO(20, 0, 250, 1.0)),
  const Product(201805, "Hat", const Color.fromRGBO(100, 100, 250, 1.0)),
  const Product(321, "Tuxedo", const Color.fromRGBO(250, 250, 0, 1.0)),
];

Future<List<Product>> getProducts() {
  return new Future.delayed(const Duration(milliseconds: 200), () => _products);
}