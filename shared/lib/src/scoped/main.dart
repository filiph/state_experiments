import 'package:flutter/material.dart';
import 'package:reactive_exploration/common/widgets/cart_button.dart';
import 'package:reactive_exploration/common/widgets/product_square.dart';
import 'package:reactive_exploration/common/widgets/theme.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:reactive_exploration/common/models/cart.dart';
import 'package:reactive_exploration/common/models/catalog.dart';
import 'package:reactive_exploration/common/models/product.dart';

void main() => runApp(new MyApp());

/// Manages the state of the cart
class CartModel extends Model {
  final _cart = new Cart();
  get items => _cart.items;
  get itemCount => _cart.itemCount;

  void add(Product product) {
    _cart.add(product);
    notifyListeners();
  }

  void remove(Product product) {
    _cart.remove(product);
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Wrapping our page in a ScopedModel
    // This will give descendents access to the CartModel() instance
    return new ScopedModel(
      model: new CartModel(),
      child: new MaterialApp(
        title: 'Scoped',
        theme: appTheme,
        home: new ScopedHomePage(),
        routes: <String, WidgetBuilder>{
          CartPage.routeName: (context) => new CartPage()
        },
      ),
    );
  }
}

class ScopedHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Scoped'),
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
      body: new Column(
        children: <Widget>[
          new CartContents(),
          new Expanded(
            child: new ProductGrid(),
          )
        ],
      ),
    );
  }
}

class CartContents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: const EdgeInsets.all(24.0),
      child: new ScopedModelDescendant<CartModel>(
        builder: (context, child, model) => new Text('Cart: ${model.items}'),
      ),
    );
  }
}

class ProductGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<Catalog>(
        future: fetchCatalog(),
        builder: (BuildContext context, AsyncSnapshot<Catalog> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return new Text('Not started ...');
            case ConnectionState.waiting:
              return new Text('Awaiting result...');
            default:
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              else
                return new GridView.count(
                  crossAxisCount: 2,
                  children: snapshot.data.products.map((product) {
                    return new ScopedModelDescendant<CartModel>(
                      builder: (context, child, model) => new ProductSquare(
                            product: product,
                            onTap: () => model.add(product),
                          ),
                    );
                  }).toList(),
                );
          }
        });
  }
}

class CartPage extends StatelessWidget {
  static const routeName = "/cart";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Your Cart"),
      ),
      body: new ScopedModelDescendant<CartModel>(
          builder: (context, child, model) => new Text('Cart: ${model.items}')),
    );
  }
}
