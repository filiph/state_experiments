import 'package:flutter/material.dart';
import 'package:reactive_exploration/common/models/cart.dart';
import 'package:reactive_exploration/common/models/cart_item.dart';
import 'package:reactive_exploration/common/models/catalog.dart';
import 'package:reactive_exploration/common/widgets/cart_button.dart';
import 'package:reactive_exploration/common/widgets/cart_page.dart';
import 'package:reactive_exploration/common/widgets/product_square.dart';
import 'package:reactive_exploration/common/models/product.dart';
import 'package:reactive_exploration/common/widgets/theme.dart';
import 'package:reactive_exploration/src/redux/store.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

void main() => runApp(new MyApp());

class CartPage extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Your Cart'),
      ),
      body: new StoreConnector<Cart, List<CartItem>>(
        converter: (store) => store.state.items,
        builder: (context, items) => new ListView(
            children: items.map((i) => new ItemTile(item: i)).toList()),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  final store = new Store<Cart>(cartReducer, initialState: new Cart());

  @override
  Widget build(BuildContext context) {
    return new StoreProvider<Cart>(
      store: store,
      child: new MaterialApp(
        title: 'Start',
        theme: appTheme,
        home: new MyHomePage(),
        routes: <String, WidgetBuilder>{
          CartPage.routeName: (context) => new CartPage()
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Redux'),
        actions: <Widget>[
          new StoreConnector<Cart, int>(
            converter: (store) => store.state.itemCount,
            builder: (context, count) => new CartButton(
                  itemCount: count,
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartPage.routeName);
                  },
                ),
          ),
        ],
      ),
      body: new ProductGrid(),
    );
  }
}

class ProductGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new GridView.count(
      crossAxisCount: 2,
      children: catalog.products.map((product) {
        return new StoreConnector<Cart, Function(Product)>(
          // Dispatch the product to the reducer somehow
          converter: (store) =>
              (product) => store.dispatch(new AddProductAction(product)),
          builder: (context, callback) => new ProductSquare(
                product: product,
                onTap: () {
                  callback(product);
                },
              ),
        );
      }).toList(),
    );
  }
}
