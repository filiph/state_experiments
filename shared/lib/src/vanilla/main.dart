import 'package:flutter/material.dart';
import 'package:reactive_exploration/common/models/cart.dart';
import 'package:reactive_exploration/common/models/catalog.dart';
import 'package:reactive_exploration/common/widgets/cart_button.dart';
import 'package:reactive_exploration/common/widgets/product_square.dart';
import 'package:reactive_exploration/common/widgets/theme.dart';

void main() => runApp(new MyApp());

class CartPage extends StatefulWidget {
  static const routeName = "/cart";

  final Cart _cart;

  CartPage(this._cart, {Key key}) : super(key: key);

  @override
  State<CartPage> createState() => new _CartPageState();
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _MyAppState();
}

class MyHomePage extends StatefulWidget {
  final Cart _cart;

  MyHomePage(this._cart, {Key key}) : super(key: key);

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
      body: new Text("Cart: ${widget._cart.items}"),
    );
  }
}

class _MyAppState extends State<MyApp> {
  final Cart _cart = new Cart();

  _MyAppState();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Vanilla',
      theme: appTheme,
      home: new MyHomePage(_cart),
      routes: <String, WidgetBuilder>{
        CartPage.routeName: (context) => new CartPage(_cart)
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
        title: new Text("Vanilla"),
        actions: <Widget>[
          new CartButton(
            itemCount: widget._cart.items.length,
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
              child: new Text("Cart: ${widget._cart.items}")),
          new Expanded(
            child: new GridView.count(
              crossAxisCount: 2,
              children: catalog.products.map((product) {
                return new ProductSquare(
                  product: product,
                  onTap: () => setState(() {
                        widget._cart.add(product);
                      }),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
