import 'package:flutter/material.dart';
import 'package:reactive_exploration/common/widgets/cart_button.dart';
import 'package:reactive_exploration/common/widgets/scoped_cart_page.dart';
import 'package:reactive_exploration/common/widgets/product_square.dart';
import 'package:reactive_exploration/common/widgets/theme.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:reactive_exploration/common/models/cart.dart';
import 'package:reactive_exploration/common/models/catalog.dart';
import 'package:reactive_exploration/common/models/product.dart';

void main() => runApp(new MyApp());

/// Manages cart state
class CartModel extends Model {
  final _cart = new Cart();
  get items => _cart.items;
  get itemCount => _cart.itemCount;

  void add(Product product) {
    _cart.add(product);
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // print('Building MyApp (Scoped)');
    return new ScopedModel(
      model: new CartModel(),
      child: new MaterialApp(
        title: 'Scoped',
        theme: appTheme,
        home: new CatalogHomePage(),
        routes: <String, WidgetBuilder>{
          CartPage.routeName: (context) => new CartPage(),
        },
      ),
    );
  }
}

class CatalogHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // print('Building CatalogHomePage (Scoped)');
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Scoped'),
        actions: <Widget>[
          new ScopedModelDescendant<CartModel>(
            builder: (context, child, model) => new CartButton(
                  itemCount: model.itemCount,
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartPage.routeName);
                  },
                ),
          )
        ],
      ),
      body: new ProductGrid(),
    );
  }
}

class ProductGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // print('Building ProductGrid (Scoped)');
    return new GridView.count(
      crossAxisCount: 2,
      children: catalog.products.map((product) {
        return new ScopedModelDescendant<CartModel>(
          builder: (context, child, model) => new ProductSquare(
                product: product,
                onTap: () => model.add(product),
              ),
        );
      }).toList(),
    );
  }
}
