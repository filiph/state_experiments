import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:reactive_exploration/common/models/cart.dart';
import 'package:reactive_exploration/common/models/catalog.dart';
import 'package:reactive_exploration/common/widgets/product_square.dart';
import 'package:reactive_exploration/src/bloc/src/shop.dart';

void main() {
  final shop = new Shop();

  runApp(new MyApp(shop: shop));
}

class CartPage extends StatelessWidget {
  static const routeName = "/cart";

  final Shop shop;

  CartPage({Key key, @required this.shop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Your Cart"),
      ),
      body: new StreamBuilder<Cart>(
          stream: shop.cart.stream,
          builder: (context, snapshot) => new Text(
              snapshot.hasData ? "Cart: ${snapshot.data}" : "Empty cart")),
    );
  }
}

class MyApp extends StatelessWidget {
  final Shop shop;

  MyApp({Key key, @required this.shop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Bloc',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(shop: shop),
      routes: <String, WidgetBuilder>{
        CartPage.routeName: (context) => new CartPage(shop: shop)
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  final Shop shop;

  MyHomePage({Key key, @required this.shop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Bloc"),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartPage.routeName);
              }),
        ],
      ),
      body: new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new Container(
              padding: const EdgeInsets.all(24.0),
              child: new StreamBuilder<Cart>(
                  stream: shop.cart.stream,
                  builder: (context, snapshot) => new Text(snapshot.hasData
                      ? "Cart: ${snapshot.data}"
                      : "Cart empty"))),
          new Expanded(
            child: new StreamBuilder<Catalog>(
              stream: shop.catalog.stream,
              builder: (context, snapshot) => (!snapshot.hasData ||
                      snapshot.data.loading)
                  ? new Text("No data")
                  : new GridView.count(
                      crossAxisCount: 2,
                      children: snapshot.data.products.map((product) {
                        return new ProductSquare(
                          product: product,
                          onTap: () =>
                              shop.cartAddition.add(new CartAddition(product)),
                        );
                      }).toList(),
                    ),
            ),
          )
        ],
      ),
    );
  }
}
