import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:reactive_exploration/src/scoped/model.dart';
import 'package:reactive_exploration/common/widgets/cart_page.dart';

class CartPage extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Your Cart'),
      ),
      body: new ScopedModelDescendant<CartModel>(
          builder: (context, widget, model) => model != null
              ? new ListView(
                  children: model.items
                      .map((item) => new ItemTile(item: item))
                      .toList())
              : new Center(
                  child: new Text('Empty',
                      style: Theme.of(context).textTheme.display1))),
    );
  }
}
