import 'package:flutter/material.dart';
import 'package:reactive_exploration/common/models/cart.dart';
import 'package:reactive_exploration/common/models/catalog.dart';
import 'package:reactive_exploration/common/widgets/product_square.dart';
import 'package:reactive_exploration/common/models/product.dart';
import 'package:reactive_exploration/src/redux/store.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

void main() => runApp(new MyApp());

final Catalog catalog = fetchCatalogSync();

class CartPage extends StatelessWidget {
  static const routeName = "/cart";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Your Cart"),
      ),
      body: new StoreConnector<Cart, String>(
        converter: (store) => store.state.items.toString(),
        builder: (context, items) => new Text("Cart: $items"),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  final store = new Store<Cart>(cartReducer, initialState: new Cart());

  @override
  Widget build(BuildContext context) {
    return new StoreProvider<Cart>(
      store: store,
      child: new MaterialApp(
        title: 'Start',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new MyHomePage(),
        routes: <String, WidgetBuilder>{
          CartPage.routeName: (context) => new CartPage()
        },
      ),
    );
  }
}

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
          new CartContents(),
          new Expanded(
            child: new ProductGrid(),
          ),
        ],
      ),
    );
  }
}

class CartContents extends StatelessWidget {
  @override
  Widget build(BuildContext context) => new StoreConnector<Cart, String>(
        converter: (store) => store.state.items.toString(),
        builder: (context, count) => new Container(
            padding: const EdgeInsets.all(24.0),
            child: new Text("Cart: $count")),
      );
}

class ProductGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) => new GridView.count(
        crossAxisCount: 2,
        children: catalog.products.map((product) {
          return new StoreConnector<Cart, Function(Product)>(
            // Dispatch the product to the reducer somehow
            converter: (store) =>
                (product) => store.dispatch(new AddProductAction(product)),
            builder: (context, callback) => new ProductSquare(
                  product: product,
                  onTap: () {
                    callback(product);
                  },
                ),
          );
        }).toList(),
      );
}
