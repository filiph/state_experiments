import 'package:flutter/material.dart';
import 'package:reactive_exploration/src/scoped/complete.dart';

import 'package:scoped_model/scoped_model.dart';

class CartPage extends StatelessWidget {
  static const routeName = "/cart";

  @override
  Widget build(BuildContext context) {
    // print('Building CartPage (Scoped)');
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Your Cart"),
      ),
      body: new ScopedModelDescendant<CartModel>(
          builder: (context, widget, model) =>
              new Text("Cart: ${model.items}")),
    );
  }
}
