import 'package:flutter/material.dart';
import 'package:reactive_exploration/common/models/cart.dart';
import 'package:reactive_exploration/common/models/catalog.dart';
import 'package:reactive_exploration/common/widgets/cart_button.dart';
import 'package:reactive_exploration/common/widgets/cart_page.dart';
import 'package:reactive_exploration/common/widgets/product_square.dart';
import 'package:reactive_exploration/common/widgets/theme.dart';

void main() => runApp(new MyApp());

final Cart _cart = new Cart();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Singleton',
      theme: appTheme,
      home: new MyHomePage(),
      routes: <String, WidgetBuilder>{
        CartPage.routeName: (context) => new CartPage(_cart)
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Singleton"),
        actions: <Widget>[
          // The shopping cart button in the app bar
          new CartButton(
            itemCount: _cart.itemCount,
            onPressed: () {
              Navigator.of(context).pushNamed(CartPage.routeName);
            },
          ),
        ],
      ),
      body: new Column(
        children: <Widget>[
          // Description of the cart's contents
          new Container(
              padding: const EdgeInsets.all(24.0),
              child: new Text("Cart: ${_cart.items}")),
          // The product grid
          new Expanded(
            child: new GridView.count(
              crossAxisCount: 2,
              children: catalog.products.map((product) {
                return new ProductSquare(
                  product: product,
                  onTap: () => setState(() {
                        _cart.add(product);
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
