import 'package:flutter/material.dart';
import 'package:reactive_exploration/common/models/cart.dart';
import 'package:reactive_exploration/common/models/cart_item.dart';
import 'package:reactive_exploration/src/bloc_inherited/cart_bloc.dart';

class BlocCartPage extends StatelessWidget {
  BlocCartPage();

  static const routeName = "/cart";

  @override
  Widget build(BuildContext context) {
    final cart = CartBloc.of(context);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Your Cart"),
      ),
      body: new StreamBuilder<List<CartItem>>(
          stream: cart.items.stream,
          builder: (context, snapshot) => new Text("Cart: ${snapshot.data}")),
    );
  }
}
