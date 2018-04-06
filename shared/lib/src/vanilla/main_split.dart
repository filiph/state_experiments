import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:reactive_exploration/common/models/cart.dart';
import 'package:reactive_exploration/common/models/catalog.dart';
import 'package:reactive_exploration/common/widgets/cart_button.dart';
import 'package:reactive_exploration/common/widgets/cart_page.dart';
import 'package:reactive_exploration/common/widgets/product_square.dart';
import 'package:reactive_exploration/common/widgets/theme.dart';

void main() {
  final Cart cart = new Cart.sample(catalog.products);
  runApp(new MyApp(cart: cart));
}

class MyApp extends StatelessWidget {
  final Cart cart;

  MyApp({
    Key key,
    @required this.cart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Singleton',
      theme: appTheme,
      home: new MyHomePage(cart: cart),
      routes: <String, WidgetBuilder>{
        CartPage.routeName: (context) => new CartPage(cart)
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final Cart cart;

  MyHomePage({
    Key key,
    @required this.cart,
  }) : super(key: key);

  @override
  MyHomePageState createState() {
    return new MyHomePageState();
  }
}

class MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Singleton"),
        actions: <Widget>[
          // The shopping cart button in the app bar
          new CartButton(
            itemCount: widget.cart.itemCount,
            onPressed: () {
              Navigator.of(context).pushNamed(CartPage.routeName);
            },
          )
        ],
      ),
      body: new Builder(
        builder: (context) => new Column(
          children: <Widget>[
            // Description of the cart's contents
            new Container(
                padding: const EdgeInsets.all(24.0),
                child: new Text("Cart: ${widget.cart.items}")),
            // The product grid
            new Expanded(
              child: new ProductGrid(cart: widget.cart,),
            )
          ],
        ),
      ),
    );
  }
}

class ProductGrid extends StatefulWidget {
  final Cart cart;

  ProductGrid({
      Key key,
      @required this.cart,
  }) : super(key: key);

  @override
  _ProductGridState createState() => new _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  @override
  Widget build(BuildContext context) {
    return new GridView.count(
      crossAxisCount: 2,
      children: catalog.products.map((product) {
        return new ProductSquare(
          product: product,
          onTap: () {
            setState(() {
              widget.cart.add(product);
            });
          },
        );
      }).toList(),
    );
  }
}
