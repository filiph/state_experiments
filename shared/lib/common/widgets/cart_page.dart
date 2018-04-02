import 'package:flutter/material.dart';
import 'package:reactive_exploration/common/models/cart.dart';

class CartPage extends StatelessWidget {
  CartPage(this.cart);
  final Cart cart;

  static const routeName = "/cart";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Your Cart"),
      ),
      body: new Text("Cart: ${cart.items}"),
    );
  }
}
