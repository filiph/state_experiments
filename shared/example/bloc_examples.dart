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

class CartBloc_bad_side_effects {
  bool _isSynced;

  Stream<int> itemCount;
  Stream<String> total;
  Stream<List<CartItem>> items;
  Sink<Product> addition;
  Sink<Locale> locale;
}

class CartBloc_bad_side_effects_fixed {
  Stream<bool> isSynced;
  Stream<int> itemCount;
  Stream<String> total;
  Stream<List<CartItem>> items;
  Sink<Product> addition;
  Sink<Locale> locale;
}

int count;
CartBloc cartBloc;
Cart cart;

class BoringWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("Count: ${cart.itemCount}");
  }
}

// Not pictured: the code that updates this widget.

class AwesomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: cartBloc.itemCount,
        initialData: 0,
        builder: (context, snapshot) {
          return Text("Count: ${snapshot.data}");
        });
  }
}

class AwkwardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: cartBloc.total,
        initialData: 0,
        builder: (context, snapshot) {
          final formated = "${snapshot.data ~/ 100} USD";
          return Text("Total: $formated");
        });
  }
}
