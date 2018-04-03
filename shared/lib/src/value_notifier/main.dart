import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:reactive_exploration/common/models/cart.dart';
import 'package:reactive_exploration/common/models/catalog.dart';
import 'package:reactive_exploration/common/widgets/cart_button.dart';
import 'package:reactive_exploration/common/widgets/product_square.dart';

void main() {
  final catalogNotifier = new ValueNotifier(new Catalog.empty());
  final cartNotifier = new ValueNotifier(new Cart());
  fetchCatalog().then((fetched) => catalogNotifier.value = fetched);

  runApp(new MyApp(
    catalogNotifier: catalogNotifier,
    cartNotifier: cartNotifier,
  ));
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
      title: 'ValueNotifier',
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
        title: new Text("ValueNotifier"),
        actions: <Widget>[
          new CartButton(
            itemCount: _cart.items.length,
            onPressed: () {
              Navigator.of(context).pushNamed(CartPage.routeName);
            },
          )
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
                return new ProductSquare(
                  product: product,
                  onTap: () => setState(() {
                        _cart.add(product);
                        cartNotifier.value = _cart;
                      }),
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
