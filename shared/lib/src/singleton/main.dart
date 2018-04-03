import 'package:flutter/material.dart';

import 'package:reactive_exploration/common/models/cart.dart';
import 'package:reactive_exploration/common/models/catalog.dart';
import 'package:reactive_exploration/common/widgets/cart_button.dart';
import 'package:reactive_exploration/common/widgets/cart_page.dart';
import 'package:reactive_exploration/common/widgets/product_square.dart';

void main() => runApp(new MyApp());

Catalog _catalog = new Catalog.empty();
final Cart _cart = new Cart();

class MyApp extends StatefulWidget {
  @override
  createState() => new MyAppState();
}

class MyAppState extends State<MyApp> {
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
      title: 'Singleton',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
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
            itemCount: _cart.items.length,
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
              children: _catalog.products.map((product) {
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
