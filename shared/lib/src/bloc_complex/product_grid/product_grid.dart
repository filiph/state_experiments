import 'package:flutter/material.dart';
import 'package:reactive_exploration/common/models/product.dart';
import 'package:reactive_exploration/src/bloc_complex/cart/cart_bloc.dart';
import 'package:reactive_exploration/src/bloc_complex/cart/cart_provider.dart';
import 'package:reactive_exploration/src/bloc_complex/catalog/catalog_bloc.dart';
import 'package:reactive_exploration/src/bloc_complex/catalog/catalog_slice.dart';

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
      initialData: CatalogSlice.empty(),
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

class ProductLine extends StatelessWidget {
  final Product product;

  final void Function() onTap;

  static const _madeUpTaglines = [
    'This product will change your life.',
    'Can you live without this product? The answer is no.',
    'Should you buy this product? Our advice: do.',
    'Some products are good. This one is amazing.',
    'Have you ever wanted to be popular and admired? Buy this.',
    'You can\'t buy happiness but you can buy this product.',
  ];

  const ProductLine(
    this.product, {
    Key key,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = product?.color ?? Colors.grey;

    final textColor = product != null ? Colors.black : Colors.grey;

    final boldTitle = Theme.of(context).textTheme.body1.copyWith(
          fontSize: 18.0,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.0,
          color: textColor,
        );

    final splashColor = Color.lerp(color, Colors.white, 0.8);

    final name = product?.name ?? '';

    final tagline = product != null
        ? _madeUpTaglines[product.id % _madeUpTaglines.length]
        : '';

    final image = product != null
        ? Placeholder(color: color)
        : Padding(
            padding: const EdgeInsets.all(24.0),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
            ),
          );

    return InkWell(
      onTap: onTap,
      splashColor: splashColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1.0,
                child: image,
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: boldTitle),
                    SizedBox(height: 8.0),
                    Text(
                      tagline,
                      style: TextStyle(color: textColor),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
