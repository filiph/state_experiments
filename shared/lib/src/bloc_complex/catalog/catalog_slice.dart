import 'package:reactive_exploration/common/models/product.dart';
import 'package:reactive_exploration/src/bloc_complex/catalog/catalog_page.dart';

/// A slice of the catalog provided to an infinite-scrolling [ListView].
///
/// This is backed by an arbitrary number of [_pages].
class CatalogSlice {
  final List<CatalogPage> _pages;

  final int startIndex;

  /// Whether or not this slice is the end of the catalog.
  ///
  /// Currently always `true` as our catalog is infinite.
  final bool hasNext;

  const CatalogSlice(this._pages, this.startIndex, this.hasNext);

  const CatalogSlice.empty()
      : _pages = const [],
        startIndex = 0,
        hasNext = true;

  /// The index of the last index of this slice.
  int get endIndex =>
      startIndex + _pages.map((page) => page.count).fold(0, (p, e) => p + e);

  /// Returns the product at [index], or `null` if data isn't loaded yet.
  Product elementAt(int index) {
    for (final page in _pages) {
      if (index >= page.startIndex && index <= page.endIndex) {
        return page.products[index - page.startIndex];
      }
    }
    return null;
  }
}
