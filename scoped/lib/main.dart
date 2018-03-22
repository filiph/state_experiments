import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'src/cart.dart';
import 'src/product.dart';
import 'src/product_db.dart';

void main() => runApp(new MyApp());

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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new ScopedHomePage(title: 'Flutter Demo Home Page'),
    );
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
            new CartContents(),
            new Expanded(
              child: new ProductGrid(),
            )
          ],
        ),
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
    return new FutureBuilder<List<Product>>(
        future: getProducts(),
        builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
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
                        builder: (context, child, model) => new InkWell(
                              onTap: () => model.add(product),
                              child: new Center(
                                  child: new Text(
                                product.name,
                                style: new TextStyle(
                                    color: isDark(product.color)
                                        ? Colors.white
                                        : Colors.black),
                              )),
                            ),
                      ),
                    );
                  }).toList(),
                );
          }
        });
  }
}

/// See https://stackoverflow.com/questions/596216/formula-to-determine-brightness-of-rgb-color
bool isDark(Color color) {
  final luminence =
      (0.2126 * color.red + 0.7152 * color.green + 0.0722 * color.blue);
  print(luminence);
  return luminence < 150;
}
