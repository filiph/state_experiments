import 'package:flutter/material.dart';

import 'src/cart.dart';
import 'src/catalog.dart';

void main() => runApp(new MyApp());

/// See https://stackoverflow.com/questions/596216/formula-to-determine-brightness-of-rgb-color
bool isDark(Color color) {
  final luminence =
      (0.2126 * color.red + 0.7152 * color.green + 0.0722 * color.blue);
  return luminence < 150;
}

class CartPage extends StatefulWidget {
  static const routeName = "/cart";

  final Catalog _catalog;

  final Cart _cart;

  CartPage(this._catalog, this._cart, {Key key}) : super(key: key);

  @override
  State<CartPage> createState() => new _CartPageState(_catalog, _cart);
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Catalog _catalog = new Catalog.empty();
  final Cart _cart = new Cart();

  _MyAppState();

  @override
  void initState() {
    super.initState();

    updateCatalog(_catalog).then((_) => setState(() {
      // Calling setState with nothing at all in it is code smell.
      // But this is also the easiest way to do it without introducing more
      // advanced techniques.
    }));
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Reactive',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(_catalog, _cart),
      routes: <String, WidgetBuilder>{
        CartPage.routeName: (context) => new CartPage(_catalog, _cart)
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final Catalog _catalog;

  final Cart _cart;

  MyHomePage(this._catalog, this._cart, {Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState(_catalog, _cart);
}

class _CartPageState extends State<CartPage> {
  final Catalog _catalog;

  final Cart _cart;

  _CartPageState(this._catalog, this._cart);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Your Cart"),
      ),
      body: new Text("Cart: ${_cart.items}"),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  /// The list of products available for purchase.
  final Catalog _catalog;

  /// The current state of the user's cart.
  final Cart _cart;

  _MyHomePageState(this._catalog, this._cart);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Flutter Reactive"),
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
              child: new Text("Cart: ${_cart.items}")),
          new Expanded(
            child: new GridView.count(
              crossAxisCount: 2,
              children: _catalog.products.map((product) {
                return new Container(
                  color: product.color,
                  child: new InkWell(
                    onTap: () => setState(() {
                          _cart.add(product);
                        }),
                    child: new Center(
                        child: new Text(
                      product.name,
                      style: new TextStyle(
                          color: isDark(product.color)
                              ? Colors.white
                              : Colors.black),
                    )),
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
