import 'dart:async';
import 'dart:collection';
import 'dart:ui' show Color;

import 'package:reactive_exploration/common/models/product.dart';

/// Hard-coded catalog of [Product]s.
final Catalog catalog = fetchCatalogSync();

/// Fetches the catalog of products asynchronously.
Future<Catalog> fetchCatalog() {
  // This simulates a short delay so that we don't get too cocky about having
  // this state present from application start (something unlikely to happen
  // in the real world).
  return new Future.delayed(
      const Duration(milliseconds: 200), fetchCatalogSync);
}

/// Fetches the catalog synchronously.
///
/// This is much less realistic than [fetchCatalog] but acceptable if we want
/// to focus on some other aspect with our sample.
Catalog fetchCatalogSync() {
  return new Catalog._sample();
}

/// Updates an existing [catalog] of products asynchronously.
Future<Null> updateCatalog(Catalog catalog) {
  return new Future.delayed(const Duration(milliseconds: 200), () {
    catalog._products.clear();
    catalog._products.addAll(Catalog._sampleProducts);
  });
}

class Catalog {
  /// A listing of sample products.
  static const List<Product> _sampleProducts = const <Product>[
    const Product(42, "Sweater", const Color.fromRGBO(2, 90, 60, 1.0)),
    const Product(1337, "Shawl", const Color.fromRGBO(90, 250, 3, 1.0)),
    const Product(1024, "Socks", const Color.fromRGBO(250, 240, 16, 1.0)),
    const Product(123, "Jacket", const Color.fromRGBO(20, 0, 250, 1.0)),
    const Product(201805, "Hat", const Color.fromRGBO(100, 100, 250, 1.0)),
    const Product(321, "Tuxedo", const Color.fromRGBO(250, 250, 0, 1.0)),
  ];

  final List<Product> _products;

  Catalog.empty() : _products = [];

  Catalog._sample() : _products = _sampleProducts;

  bool get isEmpty => _products.isEmpty;

  /// An immutable listing of the products.
  UnmodifiableListView<Product> get products =>
      new UnmodifiableListView<Product>(_products);
}
