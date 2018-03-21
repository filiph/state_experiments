import 'package:flutter/material.dart';
// Scoped Model implementation of the catalog page

import 'package:scoped_model/scoped_model.dart';

import 'src/cart.dart';
import 'src/product.dart';
import 'src/product_db.dart';

class CartModel extends Model {
  final _cart = new Cart();
  get items => _cart.items;

  void add(Product product) {
    _cart.add(product);
    notifyListeners();
  }

  void remove(Product product) {
    _cart.remove(product);
    notifyListeners();
  }
}

class ScopedHomePage extends StatelessWidget {
  ScopedHomePage({this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return new ScopedModel<CartModel>(
      model: new CartModel(),
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text("Flutter Scoped"),
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
            new Container(
              padding: const EdgeInsets.all(24.0),
              child: new ScopedModelDescendant<CartModel>(
                builder: (context, child, model) =>
                    new Text('Cart: ${model.items}'),
              ),
            ),
            new Expanded(
              child: new FutureBuilder<List<Product>>(
                  future: getProducts(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Product>> snapshot) {
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
                              return new Container(
                                color: product.color,
                                child: new ScopedModelDescendant<CartModel>(
                                  builder: (context, child, model) =>
                                      new InkWell(
                                        onTap: () => model.add(product),
                                        child: new Center(
                                            child: new Text(product.name)),
                                      ),
                                ),
                              );
                            }).toList(),
                          );
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
