import 'package:flutter/material.dart';
import 'package:reactive_exploration/common/models/cart_item.dart';
import 'package:reactive_exploration/src/bloc/cart_provider.dart';

class BlocCartPage extends StatelessWidget {
  BlocCartPage();

  static const routeName = "/cart";

  @override
  Widget build(BuildContext context) {
    final cart = CartProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: StreamBuilder<List<CartItem>>(
          stream: cart.items,
          builder: (context, snapshot) => Text("Cart: ${snapshot.data}")),
    );
  }
}
