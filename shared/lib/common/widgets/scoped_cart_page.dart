import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:reactive_exploration/src/scoped/model.dart';
import 'package:reactive_exploration/common/models/cart_item.dart';
import 'package:reactive_exploration/common/utils/is_dark.dart';

class CartPage extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    // print('Building CartPage (Scoped)');
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Your Cart'),
      ),
      // SCOPED MODEL: Wraps the page in a ScopdeModelDescendent to access
      // the products in the cart
      body: new ScopedModelDescendant<CartModel>(
          builder: (context, widget, model) => new ListView(
              children: model.items
                  .map((item) => new ItemTile(item: item))
                  .toList())),
    );
  }
}

class ItemTile extends StatelessWidget {
  ItemTile({this.item});
  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final textStyle = new TextStyle(
        color: isDark(item.product.color) ? Colors.white : Colors.black);

    return new Container(
      color: item.product.color,
      child: new ListTile(
        title: new Text(
          item.product.name,
          style: textStyle,
        ),
        trailing: new CircleAvatar(
            backgroundColor: const Color(0x33FFFFFF),
            child: new Text(item.count.toString(), style: textStyle)),
      ),
    );
  }
}
