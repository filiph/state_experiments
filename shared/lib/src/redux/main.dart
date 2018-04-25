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

void main() => runApp(MyApp());

class CartPage extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: StoreConnector<Cart, List<CartItem>>(
        converter: (store) => store.state.items,
        builder: (context, items) => ListView(
            children: items.map((i) => ItemTile(item: i)).toList()),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  final store = Store<Cart>(cartReducer, initialState: Cart());

  @override
  Widget build(BuildContext context) {
    return StoreProvider<Cart>(
      store: store,
      child: MaterialApp(
        title: 'Start',
        theme: appTheme,
        home: MyHomePage(),
        routes: <String, WidgetBuilder>{
          CartPage.routeName: (context) => CartPage()
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Redux'),
        actions: <Widget>[
          StoreConnector<Cart, int>(
            converter: (store) => store.state.itemCount,
            builder: (context, count) => CartButton(
                  itemCount: count,
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartPage.routeName);
                  },
                ),
          ),
        ],
      ),
      body: ProductGrid(),
    );
  }
}

class ProductGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      children: catalog.products.map((product) {
        return new StoreConnector<Cart, Function(Product)>(
          // Dispatch the product to the reducer somehow
          converter: (store) =>
              (product) => store.dispatch(AddProductAction(product)),
          builder: (context, callback) => ProductSquare(
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
