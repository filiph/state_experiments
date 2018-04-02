import 'package:flutter/material.dart';
import 'src/cart.dart';
import 'src/product.dart';
import 'src/product_db.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

enum Actions { Add }

Cart cartReducer(Cart state, dynamic action) {
  if (action == Actions.Add) {
    return state; // TODO: implement state.add(...);
  }
  return state;
}

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Redux',
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final store = new Store<Cart>(cartReducer, initialState: new Cart());

  @override
  Widget build(BuildContext context) {
    return new StoreProvider<Cart>(
      store: store,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text('Flutter Redux'),
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.shopping_cart),
                onPressed: () {
                  // TODO: implement this route
                }),
          ],
        ),
        body: new Column(
          children: <Widget>[
            new CartContents(),
            // new ProductGrid(),
          ],
        ),
      ),
    );
  }
}

class CartContents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<Cart, int>(
        converter: (store) => store.state.items.length,
        builder: (context, count) {
          new Container(
              padding: const EdgeInsets.all(24.0),
              child: new Text("Cart: $count"));
        });
    // return new Text('DAVE');
  }
}

class ProductGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Expanded(
      child: new FutureBuilder<List<Product>>(
          future: getProducts(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
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
                    children: snapshot.data.map((product) {
                      // TODO: How to pass a product into the cart?
                      return new Text('BOB');
                      /*
                      return new StoreConnector<Cart, Cart>(
                          converter: (store) => store.state,
                          builder: (context, cart) {
                            new Container(
                              color: product.color,
                              child: new InkWell(
                                // TODO: Add product to cart here
                                onTap: () => cart.add(product),
                                child:
                                    new Center(child: new Text(product.name)),
                              ),
                            );
                          });
                          */
                    }).toList(),
                  );
            }
          }),
    );
  }
}
