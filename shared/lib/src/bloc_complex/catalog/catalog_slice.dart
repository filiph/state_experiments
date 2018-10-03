import 'dart:math';

import 'package:reactive_exploration/common/models/product.dart';
import 'package:reactive_exploration/src/bloc_complex/services/catalog_page.dart';

/// A slice of the catalog provided to an infinite-scrolling [ListView].
///
/// A [CatalogSlice] is a convenience class backed by an arbitrary
/// number of [CatalogPage]s. Most of the time, there is more than one
/// [CatalogPage] in memory — but the view code should _not_ need to worry about
/// that.
class CatalogSlice {
  final List<CatalogPage> _pages;

  final List<int> _inCartProductIds;

  /// The index at which this slice starts to provide [Product]s.
  final int startIndex;

  /// Whether or not this slice is the end of the catalog.
  ///
  /// Currently always `true` as our catalog is infinite.
  final bool hasNext;

  CatalogSlice(this._pages, this._inCartProductIds, this.hasNext)
      : startIndex = _pages.map((p) => p.startIndex).fold(0x7FFFFFFF, min);

  const CatalogSlice.empty()
      : _pages = const [],
        _inCartProductIds = const [],
        startIndex = 0,
        hasNext = true;

  /// The index of the last product of this slice.
  int get endIndex =>
      startIndex + _pages.map((page) => page.endIndex).fold(-1, max);

  /// Returns the product at [index], or `null` if data isn't loaded yet.
  Product elementAt(int index) {
    for (final page in _pages) {
      if (index >= page.startIndex && index <= page.endIndex) {
        return page.products[index - page.startIndex];
      }
    }
    return null;
  }

  /// Returns `true` if the element at [index] is currently in cart.
  bool isInCart(int index) {
    return _inCartProductIds.contains(elementAt(index)?.id);
  }
}
