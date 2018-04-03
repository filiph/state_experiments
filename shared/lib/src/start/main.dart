import 'package:flutter/material.dart';
import 'package:reactive_exploration/common/models/cart.dart';
import 'package:reactive_exploration/common/models/catalog.dart';
import 'package:reactive_exploration/common/widgets/cart_button.dart';
import 'package:reactive_exploration/common/widgets/cart_page.dart';
import 'package:reactive_exploration/common/widgets/product_square.dart';

void main() => runApp(new MyApp());

final Catalog catalog = fetchCatalogSync();

final Cart cart = new Cart.sample(catalog.products);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Start',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
      routes: <String, WidgetBuilder>{
        CartPage.routeName: (context) => new CartPage(cart)
      },
    );
  }
}

/// The sample app's main page
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Start"),
        actions: <Widget>[
          new CartButton(
            itemCount: cart.items.length,
            onPressed: () {
              Navigator.of(context).pushNamed(CartPage.routeName);
            },
          )
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

/// Displays the contents of the cart
class CartContents extends StatelessWidget {
  @override
  Widget build(BuildContext context) => new Container(
      padding: const EdgeInsets.all(24.0),
      child: new Text("Cart: ${cart.items}"));
}

/// Displays a tappable grid of products
class ProductGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) => new GridView.count(
        crossAxisCount: 2,
        children: catalog.products.map((product) {
          return new ProductSquare(
            product: product,
            onTap: () => Scaffold.of(context).showSnackBar(
                new SnackBar(content: new Text("${product.name} tapped"))),
          );
        }).toList(),
      );
}
