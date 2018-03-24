import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:reactive_exploration/src/bloc/src/cart_bloc.dart';
import 'package:reactive_exploration/src/shared/models/cart.dart';
import 'package:reactive_exploration/src/shared/models/catalog.dart';
import 'package:reactive_exploration/src/shared/widgets/product_square.dart';

void main() {
  final catalogNotifier = new ValueNotifier(new Catalog.empty());
  fetchCatalog().then((fetched) => catalogNotifier.value = fetched);

  final cart = new CartBloc();

  runApp(new MyApp(
    catalogNotifier: catalogNotifier,
    cartBloc: cart,
  ));
}

class CartPage extends StatefulWidget {
  static const routeName = "/cart";

  final CartBloc cartBloc;

  CartPage({
    Key key,
    @required this.cartBloc,
  }) : super(key: key);

  @override
  State<CartPage> createState() => new _CartPageState(cartBloc);
}

class MyApp extends StatelessWidget {
  final ValueNotifier<Catalog> catalogNotifier;
  final CartBloc cartBloc;

  MyApp({
    Key key,
    @required this.catalogNotifier,
    @required this.cartBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Reactive',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:
          new MyHomePage(catalogNotifier: catalogNotifier, cartBloc: cartBloc),
      routes: <String, WidgetBuilder>{
        CartPage.routeName: (context) => new CartPage(cartBloc: cartBloc)
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final ValueNotifier<Catalog> catalogNotifier;

  final CartBloc cartBloc;

  MyHomePage({
    @required this.catalogNotifier,
    @required this.cartBloc,
    Key key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() =>
      new _MyHomePageState(catalogNotifier, cartBloc);
}

class _CartPageState extends State<CartPage> {
  final CartBloc cartBloc;

  _CartPageState(this.cartBloc);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Your Cart"),
      ),
      body: new StreamBuilder<Cart>(
          stream: cartBloc.cart.stream,
          builder: (context, snapshot) => new Text(
              snapshot.hasData ? "Cart: ${snapshot.data}" : "Empty cart")),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  final ValueNotifier<Catalog> catalogNotifier;

  Catalog _catalog;

  final CartBloc cartBloc;

  _MyHomePageState(this.catalogNotifier, this.cartBloc) {
    catalogNotifier.addListener(_catalogUpdatedHandler);
    _catalog = catalogNotifier.value;
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
              child: new StreamBuilder<Cart>(
                  stream: cartBloc.cart.stream,
                  builder: (context, snapshot) => new Text(snapshot.hasData
                      ? "Cart: ${snapshot.data}"
                      : "Cart empty"))),
          new Expanded(
            child: new GridView.count(
              crossAxisCount: 2,
              children: _catalog.products.map((product) {
                return new ProductSquare(
                  product: product,
                  onTap: () =>
                      cartBloc.cartAddition.add(new CartAddition(product)),
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
    super.dispose();
  }

  void _catalogUpdatedHandler() {
    setState(() {
      _catalog = catalogNotifier.value;
    });
  }
}
