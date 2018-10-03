import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:reactive_exploration/src/bloc_complex/catalog/catalog_slice.dart';
import 'package:reactive_exploration/src/bloc_complex/services/catalog.dart';
import 'package:reactive_exploration/src/bloc_complex/services/catalog_page.dart';
import 'package:rxdart/rxdart.dart';

/// This component encapsulates the logic of fetching products from
/// a database, page by page, according to position in an infinite list.
///
/// Only the data that are close to the current location are cached, the rest
/// are thrown away.
class CatalogBloc {
  /// We're using ReactiveX's [PublishSubject] here because we want to easily
  /// buffer the stream. See [CatalogBloc] constructor.
  final _indexController = PublishSubject<int>();

  /// These are the pages stored in memory. For O(1) retrieval, we're storing
  /// them in a [Map]. The key value is [CatalogPage.startIndex].
  final _pages = <int, CatalogPage>{};

  /// A set of pages that are currently being fetched from the network.
  /// They are identified by their [CatalogPage.startIndex].
  final _pagesBeingRequested = Set<int>();

  final _sliceSubject =
      BehaviorSubject<CatalogSlice>(seedValue: CatalogSlice.empty());

  final CatalogService _catalogService;

  CatalogBloc(this._catalogService) {
    _indexController.stream
        // Don't try to update too frequently.
        .bufferTime(Duration(milliseconds: 500))
        // Don't update when there is no need.
        .where((batch) => batch.isNotEmpty)
        .listen(_handleIndexes);
  }

  /// An input of the indexes that the [ListView.builder]
  /// (or [GridView.builder]) is getting in its builder callbacks. Just push
  /// the index that you get in a [IndexedWidgetBuilder] down this [Sink].
  ///
  /// The component uses this input to figure out which pages it should
  /// be requesting from the network.
  Sink<int> get index => _indexController.sink;

  /// The currently available data, as a slice of the (potentially infinite)
  /// catalog.
  ValueObservable<CatalogSlice> get slice => _sliceSubject;

  void dispose() {
    _indexController.close();
  }

  /// Outputs the [CatalogPage.startIndex] given an arbitrary index of
  /// a product.
  int _getPageStartFromIndex(int index) =>
      (index ~/ CatalogService.productsPerPage) *
      CatalogService.productsPerPage;

  /// This will handle the incoming [indexes] (that were requested by
  /// a [IndexedWidgetBuilder]) and, if needed, will fetch missing data.
  void _handleIndexes(List<int> indexes) {
    const maxInt = 0x7fffffff;
    final int minIndex = indexes.fold(maxInt, min);
    final int maxIndex = indexes.fold(-1, max);

    final minPageIndex = _getPageStartFromIndex(minIndex);
    final maxPageIndex = _getPageStartFromIndex(maxIndex);

    for (int i = minPageIndex;
        i <= maxPageIndex;
        i += CatalogService.productsPerPage) {
      if (_pages.containsKey(i)) continue;
      if (_pagesBeingRequested.contains(i)) continue;

      _pagesBeingRequested.add(i);
      _catalogService.requestPage(i).then((page) => _handleNewPage(page, i));
    }

    // Remove pages too far from current scroll position.
    _pages.removeWhere((pageIndex, _) =>
        pageIndex < minPageIndex - CatalogService.productsPerPage ||
        pageIndex > maxPageIndex + CatalogService.productsPerPage);
  }

  /// Handles arrival of a new [page] from the network. Will call
  /// [_sendNewSlice].
  void _handleNewPage(CatalogPage page, int index) {
    _pages[index] = page;
    _pagesBeingRequested.remove(index);
    _sendNewSlice();
  }

  /// Creates a [CatalogSlice] from the current [_pages] and sends it
  /// down the [slice] stream.
  void _sendNewSlice() {
    final pages = _pages.values.toList(growable: false);

    final slice = CatalogSlice(pages, true);

    _sliceSubject.add(slice);
  }
}

/// The equivalent of [CartProvider], but for [CatalogBloc].
class CatalogProvider extends InheritedWidget {
  final CatalogBloc catalogBloc;

  CatalogProvider({
    Key key,
    @required CatalogBloc catalog,
    Widget child,
  })  : assert(catalog != null),
        catalogBloc = catalog,
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static CatalogBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(CatalogProvider) as CatalogProvider)
          .catalogBloc;
}
