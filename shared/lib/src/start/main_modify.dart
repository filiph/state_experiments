import 'package:flutter/material.dart';
import 'package:reactive_exploration/common/models/cart.dart';
import 'package:reactive_exploration/common/models/product.dart';
import 'package:reactive_exploration/common/widgets/product_square.dart';

class ShoppingCartApp extends StatelessWidget {
  ShoppingCartApp({this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}

/// Displays the contents of the cart
class CartContents extends StatelessWidget {
  CartContents({this.cart});
  final Cart cart;

  @override
  Widget build(BuildContext context) => new Container(
      padding: const EdgeInsets.all(24.0),
      child: new Text("Cart: ${cart.items}"));
}

/// Tappable product widget for adding items to the cart
class TappableSquareProduct extends StatelessWidget {
  TappableSquareProduct({this.product, this.cart});
  final Product product;
  final Cart cart;

  @override
  Widget build(BuildContext context) {
    return new ProductSquare(
      product: product,
      onTap: () => Scaffold.of(context).showSnackBar(
          new SnackBar(content: new Text("${product.name} tapped"))),
    );
  }
}
