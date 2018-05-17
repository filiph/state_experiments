import 'package:flutter/material.dart';
import 'package:reactive_exploration/src/bloc_complex/cart/cart_bloc.dart';
import 'package:reactive_exploration/src/bloc_complex/cart/cart_provider.dart';
import 'package:reactive_exploration/src/bloc_complex/catalog/catalog_bloc.dart';
import 'package:reactive_exploration/src/bloc_complex/catalog/catalog_slice.dart';
import 'package:reactive_exploration/src/bloc_complex/product_grid/product_square.dart';

/// Displays an infinite grid of products.
class ProductGrid extends StatelessWidget {
  /// The number of items that will be rendered as loading below the last
  /// loaded item.
  ///
  /// When this is `0`, the user is not able to scroll beyond the items that
  /// are already loaded. If it's a small number, the user is not able to
  /// "flick" many pages down the catalog, since the scrolling stops.
  static const _loadingSpace = 40;

  static const _gridDelegate =
      const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2);

  @override
  Widget build(BuildContext context) {
    final cartBloc = CartProvider.of(context);
    final catalogBloc = CatalogProvider.of(context);

    return StreamBuilder<CatalogSlice>(
        stream: catalogBloc.slice,
        initialData: CatalogSlice.empty(),
        builder: (context, snapshot) {
          return GridView.builder(
              gridDelegate: _gridDelegate,
              itemCount: snapshot.data.endIndex + _loadingSpace,
              itemBuilder: (context, index) =>
                  _squareBuilder(index, snapshot.data, catalogBloc, cartBloc));
        });
  }

  /// Builds a square of the product on a given [index] in the catalog.
  /// Also sends the [index] to the [catalogBloc] so it can potentially load
  /// more data.
  Widget _squareBuilder(int index, CatalogSlice slice, CatalogBloc catalogBloc,
      CartBloc cartBloc) {
    // Notify catalog BLoC of the latest index that the framework is trying
    // to build.
    catalogBloc.index.add(index);

    // Get data.
    final product = slice.elementAt(index);

    // Display spinner if waiting for data.
    if (product == null) {
      return Center(child: CircularProgressIndicator());
    }

    // Display data.
    return ProductSquare(
      key: Key(product.id.toString()),
      product: product,
      itemsStream: cartBloc.items,
      onTap: () {
        cartBloc.cartAddition.add(CartAddition(product));
      },
    );
  }
}
