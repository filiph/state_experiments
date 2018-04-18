import 'package:flutter/material.dart';

import 'package:reactive_exploration/common/models/catalog.dart';

import 'package:reactive_exploration/common/widgets/cart_button.dart';
import 'package:reactive_exploration/common/widgets/product_square.dart';
import 'package:reactive_exploration/common/widgets/theme.dart';

import 'package:reactive_exploration/src/scoped/scoped_cart_page.dart';
import 'package:reactive_exploration/src/scoped/model.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Scoped Model',
      theme: appTheme,
      home: new MyHomePage(),
      routes: <String, WidgetBuilder>{
        CartPage.routeName: (context) => new CartPage()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Scoped Model'),
        actions: <Widget>[
          new CartButton(
            itemCount: 0,
            onPressed: () {
              Navigator.of(context).pushNamed(CartPage.routeName);
            },
          )
        ],
      ),
      body: new ProductGrid(),
    );
  }
}

class ProductGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) => new GridView.count(
        crossAxisCount: 2,
        children: catalog.products.map((product) {
          return new ProductSquare(
            product: product,
            onTap: () => Scaffold.of(context).showSnackBar(
                new SnackBar(content: new Text('${product.name} tapped'))),
          );
        }).toList(),
      );
}
