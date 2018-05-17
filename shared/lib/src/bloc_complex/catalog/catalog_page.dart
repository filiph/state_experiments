import 'dart:collection';

import 'package:reactive_exploration/common/models/product.dart';

/// A page of catalog items fetched from network.
///
/// This mimics a paginated web API response, where you don't get results
/// one by one but in batches.
class CatalogPage {
  final List<Product> _products;

  final int startIndex;

  CatalogPage(this._products, this.startIndex);

  int get count => _products.length;

  int get endIndex => startIndex + count - 1;

  UnmodifiableListView<Product> get products => UnmodifiableListView(_products);

  @override
  String toString() => "_CatalogPage($startIndex-$endIndex)";
}
