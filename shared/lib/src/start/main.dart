import 'package:flutter/material.dart';
import 'package:reactive_exploration/common/models/cart.dart';
import 'package:reactive_exploration/common/models/catalog.dart';
import 'package:reactive_exploration/common/widgets/product_square.dart';

void main() => runApp(new MyApp());

final Cart cart = new Cart.sample(catalog.products);

final Catalog catalog = fetchCatalogSync();

class CartPage extends StatefulWidget {
  static const routeName = "/cart";

  @override
  State<CartPage> createState() => new _CartPageState();
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _MyAppState();
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _CartPageState extends State<CartPage> {
  _CartPageState();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Your Cart"),
      ),
      body: new Text("Cart: ${cart.items}"),
    );
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Start',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
      routes: <String, WidgetBuilder>{
        CartPage.routeName: (context) => new CartPage()
      },
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState();

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
          new Container(
              padding: const EdgeInsets.all(24.0),
              child: new Text("Cart: ${cart.items}")),
          new Expanded(
            child: new GridView.count(
              crossAxisCount: 2,
              children: catalog.products.map((product) {
                return new ProductSquare(
                  product: product,
                  onTap: () {
                    // TODO: add the product to a cart
                    print("$product added");
                  },
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
