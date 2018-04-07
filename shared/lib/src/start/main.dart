import 'package:flutter/material.dart';
import 'package:reactive_exploration/common/models/cart.dart';
import 'package:reactive_exploration/common/models/catalog.dart';
import 'package:reactive_exploration/common/widgets/cart_page.dart';
import 'package:reactive_exploration/src/start/main_vanilla.dart';

void main() => runApp(new MyApp());

final Catalog catalog = fetchCatalogSync();

final Cart cart = new Cart.sample(catalog.products);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new ShoppingCartApp(
      child: new MaterialApp(
        title: 'Start',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new MyHomePage(),
        routes: <String, WidgetBuilder>{
          CartPage.routeName: (context) => new CartPage(cart)
        },
      ),
    );
  }
}

/// The sample app's main page
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Start"),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartPage.routeName);
              }),
        ],
      ),
      body: new Column(
        children: <Widget>[
          new CartContents(cart: cart),
          new Expanded(
            child: new ProductGrid(),
          ),
        ],
      ),
    );
  }
}

/// Displays a tappable grid of products
class ProductGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) => new GridView.count(
        crossAxisCount: 2,
        children: catalog.products.map((product) {
          return new TappableSquareProduct(product: product, cart: cart);
        }).toList(),
      );
}
