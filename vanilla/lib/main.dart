import 'package:flutter/material.dart';
import 'src/cart.dart';
import 'src/product.dart';
import 'src/product_db.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Reactive',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /// The ordered list of products available for purchase.
  List<Product> _catalog = [];

  /// The current state of the user's cart.
  Cart _cart = new Cart();

  @override
  void initState() {
    // Fetch the catalog.
    getProducts().then((value) => setState(() => _catalog = value));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Flutter Reactive"),
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
              child: new Text("Cart: ${_cart.items}")),
          new Expanded(
            child: new GridView.count(
              crossAxisCount: 2,
              children: _catalog.map((product) {
                return new Container(
                  color: product.color,
                  child: new InkWell(
                    onTap: () => setState(() => _cart.add(product)),
                    child: new Center(
                        child: new Text(
                      product.name,
                      style: new TextStyle(
                          color: isDark(product.color)
                              ? Colors.white
                              : Colors.black),
                    )),
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}

/// See https://stackoverflow.com/questions/596216/formula-to-determine-brightness-of-rgb-color
bool isDark(Color color) {
  final luminence =
      (0.2126 * color.red + 0.7152 * color.green + 0.0722 * color.blue);
  return luminence < 150;
}
