import 'package:flutter/material.dart';
import 'package:reactive_exploration/src/cart.dart';
import 'package:reactive_exploration/src/product.dart';
import 'package:reactive_exploration/src/product_db.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Reactive',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Reactive'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Product> _catalog = [];
  Cart _cart = new Cart();

  @override
  void initState() {
    getProducts().then((value) => setState(() => _catalog = value));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.shopping_cart), onPressed: () {})
        ],
      ),
      body: new Column(
        children: <Widget>[
          new Container(child: new Text("Cart: ${_cart.state}")),
          new Expanded(
            child: new GridView.count(
              crossAxisCount: 2,
              children: _catalog.map((product) {
                return new Container(
                    color: product.color,
                    child: new InkWell(
                    onTap: () => setState(() =>_cart.add(product)),
                      child: new Center(child: new Text(product.name)),
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
