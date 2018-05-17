import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:reactive_exploration/common/models/cart_item.dart';
import 'package:reactive_exploration/common/models/product.dart';
import 'package:reactive_exploration/common/utils/is_dark.dart';
import 'package:reactive_exploration/src/bloc_complex/product_grid/product_square_bloc.dart';

/// In this version, [ProductSquare] must be a [StatefulWidget] because
/// it has a [ProductSquareBloc] that it needs to dispose of when it's no
/// longer needed.
class ProductSquare extends StatefulWidget {
  /// The product to be rendered.
  final Product product;

  /// The observable list of items in the cart. This is used to render
  /// items that are already in the cart differently.
  ///
  /// This will be piped into this widget's [ProductSquareBloc].
  final Stream<List<CartItem>> itemsStream;

  final GestureTapCallback onTap;

  ProductSquare({
    Key key,
    @required this.product,
    @required this.itemsStream,
    this.onTap,
  }) : super(key: key);

  @override
  _ProductSquareState createState() => _ProductSquareState();
}

class _ProductSquareState extends State<ProductSquare> {
  /// The business logic component for the [ProductSquare] widget.
  ///
  /// In our sample this is overkill, but you can imagine the widget to get
  /// much more complicated (fetching images, availability, favorite status,
  /// etc.).
  ProductSquareBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.product.color,
      child: InkWell(
        onTap: widget.onTap,
        child: Center(
            child: StreamBuilder<bool>(
                stream: _bloc.isInCart,
                initialData: false,
                builder: (context, snapshot) => _renderText(snapshot.data))),
      ),
    );
  }

  /// A helper method that only build the text of the [ProductSquare].
  ///
  /// The text will be underlined when [isInCart] is `true`.
  Widget _renderText(bool isInCart) {
    return Text(
      widget.product.name,
      style: TextStyle(
          color: isDark(widget.product.color) ? Colors.white : Colors.black,
          decoration: isInCart ? TextDecoration.underline : null),
    );
  }

  /// Remember: widgets can change from above the [State] at the framework's
  /// discretion. We need to make sure we always update the [State]
  /// to reflect the [StatefulWidget].
  ///
  /// Here, we're disposing of the old [_bloc] and creating a new one.
  @override
  void didUpdateWidget(ProductSquare oldWidget) {
    _bloc.dispose();
    _bloc = ProductSquareBloc(widget.product, widget.itemsStream);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  /// Initialize business logic components that you will be disposing of in
  /// [initState].
  @override
  void initState() {
    super.initState();
    _bloc = ProductSquareBloc(widget.product, widget.itemsStream);
  }
}
