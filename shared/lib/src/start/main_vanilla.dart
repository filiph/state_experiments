import 'package:flutter/material.dart';
import 'package:reactive_exploration/common/models/cart.dart';
import 'package:reactive_exploration/common/models/product.dart';
import 'package:reactive_exploration/common/widgets/product_square.dart';

class CartData extends InheritedWidget {
  CartData({Key key, Widget child, this.cart, this.notifyUpdate})
      : super(key: key, child: child);
  final Cart cart;
  final Function notifyUpdate;

  @override
  bool updateShouldNotify(CartData oldWidget) {
    return oldWidget.cart.items.length != cart.items.length;
  }
}

// Wraps the MaterialApp widget
class ShoppingCartApp extends StatefulWidget {
  ShoppingCartApp({this.child});
  final Widget child;
  final Cart cart = new Cart();

  @override
  createState() => new ShoppingCartAppState();
}

class ShoppingCartAppState extends State<ShoppingCartApp> {
  _notifyUpdate() {
    print('UPDATED');
  }

  @override
  Widget build(BuildContext context) => new CartData(
      cart: widget.cart, notifyUpdate: _notifyUpdate, child: widget.child);
}

/// Displays the contents of the cart
class CartContents extends StatelessWidget {
  CartContents({this.cart});
  final Cart cart;

  @override
  Widget build(BuildContext context) {
    return new Container(
        padding: const EdgeInsets.all(24.0),
        child: new Text("Cart: ${cart.items}"));
  }
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
