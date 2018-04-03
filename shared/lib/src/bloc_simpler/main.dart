import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:reactive_exploration/common/models/cart_item.dart';
import 'package:reactive_exploration/common/models/catalog.dart';
import 'package:reactive_exploration/common/widgets/cart_button.dart';
import 'package:reactive_exploration/common/widgets/product_square.dart';
import 'package:reactive_exploration/src/bloc_simpler/src/shop.dart';

void main() {
  final cart = new CartBloc();

  runApp(new MyApp(cart: cart));
}

class CartPage extends StatelessWidget {
  static const routeName = "/cart";

  final CartBloc shop;

  CartPage({Key key, @required this.shop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Your Cart"),
      ),
      body: new StreamBuilder<List<CartItem>>(
          stream: shop.items.stream,
          builder: (context, snapshot) => new Text("Cart: ${snapshot.data}")),
    );
  }
}

class MyApp extends StatelessWidget {
  final CartBloc cart;

  MyApp({Key key, @required this.cart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Simpler Bloc',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(cart: cart),
      routes: <String, WidgetBuilder>{
        CartPage.routeName: (context) => new CartPage(shop: cart)
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  final CartBloc cart;

  MyHomePage({Key key, @required this.cart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Simpler Bloc"),
        actions: <Widget>[
          new StreamBuilder<List<CartItem>>(
              stream: cart.items.stream,
              builder: (context, snapshot) => new CartButton(
                    itemCount: snapshot.data.length,
                    onPressed: () {
                      Navigator.of(context).pushNamed(CartPage.routeName);
                    },
                  )),
        ],
      ),
      body: new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new Container(
              padding: const EdgeInsets.all(24.0),
              child: new StreamBuilder<List<CartItem>>(
                  stream: cart.items.stream,
                  builder: (context, snapshot) =>
                      new Text("Cart: ${snapshot.data}"))),
          new Expanded(
            child: new GridView.count(
              crossAxisCount: 2,
              children: catalog.products.map((product) {
                return new ProductSquare(
                  product: product,
                  onTap: () => cart.cartAddition.add(new CartAddition(product)),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
