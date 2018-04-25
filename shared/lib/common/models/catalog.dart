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
  return Future.delayed(
      const Duration(milliseconds: 200), fetchCatalogSync);
}

/// Fetches the catalog synchronously.
///
/// This is much less realistic than [fetchCatalog] but acceptable if we want
/// to focus on some other aspect with our sample.
Catalog fetchCatalogSync() {
  return Catalog._sample();
}

/// Updates an existing [catalog] of products asynchronously.
Future<Null> updateCatalog(Catalog catalog) {
  return Future.delayed(const Duration(milliseconds: 200), () {
    catalog._products.clear();
    catalog._products.addAll(Catalog._sampleProducts);
  });
}

class Catalog {
  /// A listing of sample products.
  static const List<Product> _sampleProducts = const <Product>[
    const Product(42, "Sweater", const Color(0xFF536DFE)),
    const Product(1024, "Socks", const Color(0xFFFFD500)),
    const Product(1337, "Shawl", const Color(0xFF1CE8B5)),
    const Product(123, "Jacket", const Color(0xFFFF6C00)),
    const Product(201805, "Hat", const Color(0xFF574DDD)),
    const Product(128, "Hoodie", const Color(0xFFABD0F2)),
    const Product(321, "Tuxedo", const Color(0xFF8DA0FC)),
    const Product(1003, "Shirt", const Color(0xFF1CE8B5)),
  ];

  final List<Product> _products;

  Catalog.empty() : _products = [];

  Catalog._sample() : _products = _sampleProducts;

  bool get isEmpty => _products.isEmpty;

  /// An immutable listing of the products.
  UnmodifiableListView<Product> get products =>
      UnmodifiableListView<Product>(_products);
}
