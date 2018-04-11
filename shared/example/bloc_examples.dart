import 'dart:async';

import 'package:flutter/material.dart';
import 'package:reactive_exploration/common/models/cart_item.dart';

class Product {}

class ProductAddition {}

class Cart {
  int itemCount;
//  void addListener(...);
//  void removeListener(...);
}

class CartBloc {
  Stream<int> itemCount;
  Stream<int> total;
  Stream<List<CartItem>> items;
}

int count;
CartBloc cartBloc;
Cart cart;

class BoringWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Text("Count: ${cart.itemCount}");
  }
}

// Not pictured: the code that updates this widget.

class AwesomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<int>(
        stream: cartBloc.itemCount,
        initialData: 0,
        builder: (context, snapshot) {
          return new Text("Count: ${snapshot.data}");
        });
  }
}

class AwkwardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<int>(
        stream: cartBloc.total,
        initialData: 0,
        builder: (context, snapshot) {
          final formated = "${snapshot.data ~/ 100} USD";
          return new Text("Total: $formated");
        });
  }
}
