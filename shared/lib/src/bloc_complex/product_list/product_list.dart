import 'package:flutter/material.dart';
import 'package:reactive_exploration/src/bloc_complex/cart/cart_bloc.dart';
import 'package:reactive_exploration/src/bloc_complex/cart/cart_provider.dart';
import 'package:reactive_exploration/src/bloc_complex/catalog/catalog_bloc.dart';
import 'package:reactive_exploration/src/bloc_complex/catalog/catalog_slice.dart';
import 'package:reactive_exploration/src/bloc_complex/product_list/product_line.dart';

/// Displays an infinite grid of products.
class ProductList extends StatelessWidget {
  /// The number of items that will be rendered as loading below the last
  /// loaded item.
  ///
  /// When this is `0`, the user is not able to scroll beyond the items that
  /// are already loaded. If it's a small number, the user is not able to
  /// "flick" many pages down the catalog, since the scrolling stops.
  static const _loadingSpace = 40;

  @override
  Widget build(BuildContext context) {
    final cartBloc = CartProvider.of(context);
    final catalogBloc = CatalogProvider.of(context);

    return StreamBuilder<CatalogSlice>(
      stream: catalogBloc.slice,
      initialData: catalogBloc.slice.value,
      builder: (context, snapshot) => ListView.builder(
            padding: EdgeInsets.only(top: 16.0),
            itemCount: snapshot.data.endIndex + _loadingSpace,
            itemBuilder: (context, index) =>
                _createItem(index, snapshot.data, catalogBloc, cartBloc),
          ),
    );
  }

  /// Builds a list item of the product on a given [index] in the catalog.
  /// Also sends the [index] to the [catalogBloc] so it can potentially load
  /// more data.
  Widget _createItem(int index, CatalogSlice slice, CatalogBloc catalogBloc,
      CartBloc cartBloc) {
    // Notify catalog BLoC of the latest index that the framework is trying
    // to build.
    catalogBloc.index.add(index);

    // Get data.
    final product = slice.elementAt(index);

    final loaded = product != null;

    return AnimatedCrossFade(
        firstChild: ProductLine(null),
        secondChild: ProductLine(
          product,
          isInCart: slice.isInCart(index),
          key: loaded ? Key(product.id.toString()) : null,
          onTap: () {
            cartBloc.cartAddition.add(CartAddition(product));
          },
        ),
        crossFadeState:
            loaded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 200));
  }
}
