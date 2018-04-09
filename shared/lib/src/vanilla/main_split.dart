import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:reactive_exploration/common/models/cart.dart';
import 'package:reactive_exploration/common/models/catalog.dart';
import 'package:reactive_exploration/common/models/product.dart';
import 'package:reactive_exploration/common/widgets/cart_button.dart';
import 'package:reactive_exploration/common/widgets/cart_page.dart';
import 'package:reactive_exploration/common/widgets/product_square.dart';
import 'package:reactive_exploration/common/widgets/theme.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  final cart = new Cart();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Vanilla',
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
  createState() => new MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  _updateCart(Product product) {
    setState(() => widget.cart.add(product));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Vanilla"),
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
      body: new ProductGrid(
        cart: widget.cart,
        updateProduct: _updateCart,
      ),
    );
  }
}

class ProductGrid extends StatelessWidget {
  final Cart cart;
  final Function(Product) updateProduct;

  ProductGrid({
    Key key,
    @required this.cart,
    @required this.updateProduct,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new GridView.count(
      crossAxisCount: 2,
      children: catalog.products.map((product) {
        return new ProductSquare(
          product: product,
          onTap: () => updateProduct(product),
        );
      }).toList(),
    );
  }
}
