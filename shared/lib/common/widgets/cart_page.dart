import 'package:flutter/material.dart';
import 'package:reactive_exploration/common/models/cart.dart';
import 'package:reactive_exploration/common/models/cart_item.dart';
import 'package:reactive_exploration/common/utils/is_dark.dart';

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
      body: new ListView(
          children:
              cart.items.map((item) => new ItemTile(item: item)).toList()),
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
