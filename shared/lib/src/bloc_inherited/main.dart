import 'package:flutter/material.dart';
import 'package:reactive_exploration/common/models/cart_item.dart';
import 'package:reactive_exploration/common/models/catalog.dart';
import 'package:reactive_exploration/common/widgets/cart_button.dart';
import 'package:reactive_exploration/common/widgets/product_square.dart';
import 'package:reactive_exploration/common/widgets/theme.dart';
import 'package:reactive_exploration/src/bloc_inherited/bloc_cart_page.dart';
import 'package:reactive_exploration/src/bloc_inherited/cart_bloc.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new CartBloc(
      child: new MaterialApp(
        title: 'Start',
        theme: appTheme,
        home: new MyHomePage(),
        routes: <String, WidgetBuilder>{
          BlocCartPage.routeName: (context) => new BlocCartPage()
        },
      ),
    );
  }
}

/// The sample app's main page
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartBloc = CartBloc.of(context);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Start"),
        actions: <Widget>[
          new StreamBuilder<int>(
            stream: cartBloc.itemCount.stream,
            builder: (context, snapshot) => new CartButton(
                  itemCount: snapshot.data,
                  onPressed: () {
                    Navigator.of(context).pushNamed(BlocCartPage.routeName);
                  },
                ),
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
  Widget build(BuildContext context) {
    final cartBloc = CartBloc.of(context);
    return new Container(
        padding: const EdgeInsets.all(24.0),
        child: new StreamBuilder<List<CartItem>>(
            stream: cartBloc.items.stream,
            builder: (context, snapshot) =>
                new Text("Cart: ${snapshot.data}")));
  }
}

/// Displays a tappable grid of products
class ProductGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartBloc = CartBloc.of(context);
    return new GridView.count(
      crossAxisCount: 2,
      children: catalog.products.map((product) {
        return new ProductSquare(
          product: product,
          onTap: () {
            cartBloc.cartAddition.add(new CartAddition(product));
          },
        );
      }).toList(),
    );
  }
}
