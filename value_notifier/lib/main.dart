import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'src/cart.dart';
import 'src/catalog.dart';

void main() {
  final catalogNotifier = new ValueNotifier(new Catalog.empty());
  final cartNotifier = new ValueNotifier(new Cart());
  fetchCatalog().then((fetched) => catalogNotifier.value = fetched);

  runApp(new MyApp(
    catalogNotifier: catalogNotifier,
    cartNotifier: cartNotifier,
  ));
}

/// See https://stackoverflow.com/questions/596216/formula-to-determine-brightness-of-rgb-color
bool isDark(Color color) {
  final luminence =
      (0.2126 * color.red + 0.7152 * color.green + 0.0722 * color.blue);
  return luminence < 150;
}

class CartPage extends StatefulWidget {
  static const routeName = "/cart";

  final ValueNotifier<Cart> cartNotifier;

  CartPage({
    Key key,
    @required this.cartNotifier,
  }) : super(key: key);

  @override
  State<CartPage> createState() => new _CartPageState(cartNotifier);
}

class MyApp extends StatelessWidget {
  final ValueNotifier<Catalog> catalogNotifier;
  final ValueNotifier<Cart> cartNotifier;

  MyApp({
    Key key,
    @required this.catalogNotifier,
    @required this.cartNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Reactive',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(
          catalogNotifier: catalogNotifier, cartNotifier: cartNotifier),
      routes: <String, WidgetBuilder>{
        CartPage.routeName: (context) =>
            new CartPage(cartNotifier: cartNotifier)
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final ValueNotifier<Catalog> catalogNotifier;

  final ValueNotifier<Cart> cartNotifier;

  MyHomePage({
    @required this.catalogNotifier,
    @required this.cartNotifier,
    Key key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() =>
      new _MyHomePageState(catalogNotifier, cartNotifier);
}

class _CartPageState extends State<CartPage> {
  final ValueNotifier<Cart> cartNotifier;

  Cart _cart;

  _CartPageState(this.cartNotifier) {
    cartNotifier.addListener(_cartUpdateHandler);
    _cart = cartNotifier.value;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Your Cart"),
      ),
      body: new Text("Cart: ${_cart.items}"),
    );
  }

  @override
  void dispose() {
    cartNotifier.removeListener(_cartUpdateHandler);
    super.dispose();
  }

  void _cartUpdateHandler() {
    setState(() {
      _cart = cartNotifier.value;
    });
  }
}

class _MyHomePageState extends State<MyHomePage> {
  final ValueNotifier<Catalog> catalogNotifier;

  Catalog _catalog;

  final ValueNotifier<Cart> cartNotifier;

  Cart _cart;

  _MyHomePageState(this.catalogNotifier, this.cartNotifier) {
    catalogNotifier.addListener(_catalogUpdatedHandler);
    _catalog = catalogNotifier.value;
    cartNotifier.addListener(_cartUpdateHandler);
    _cart = cartNotifier.value;
  }

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
                          cartNotifier.value = _cart;
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

  @override
  void dispose() {
    catalogNotifier.removeListener(_catalogUpdatedHandler);
    cartNotifier.removeListener(_cartUpdateHandler);
    super.dispose();
  }

  void _cartUpdateHandler() {
    setState(() {
      _cart = cartNotifier.value;
    });
  }

  void _catalogUpdatedHandler() {
    setState(() {
      _catalog = catalogNotifier.value;
    });
  }
}
