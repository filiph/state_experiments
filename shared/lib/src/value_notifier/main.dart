import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:reactive_exploration/common/models/cart.dart';
import 'package:reactive_exploration/common/models/catalog.dart';
import 'package:reactive_exploration/common/models/product.dart';
import 'package:reactive_exploration/common/widgets/cart_button.dart';
import 'package:reactive_exploration/common/widgets/cart_page.dart';
import 'package:reactive_exploration/common/widgets/product_square.dart';

void main() {
  final cartObservable = new CartObservable(new Cart());

  runApp(new MyApp(
    cartObservable: cartObservable,
  ));
}

class CartObservable extends ValueNotifier<Cart> {
  CartObservable(Cart value) : super(value);

  void add(Product product) {
    value.add(product);
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  final CartObservable cartObservable;

  MyApp({
    Key key,
    @required this.cartObservable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Start',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(
        cartObservable: cartObservable,
      ),
      routes: <String, WidgetBuilder>{
        CartPage.routeName: (context) => new CartPage(cartObservable.value)
      },
    );
  }
}

/// The sample app's main page
class MyHomePage extends StatefulWidget {
  final CartObservable cartObservable;

  MyHomePage({
    Key key,
    @required this.cartObservable,
  }) : super(key: key);

  @override
  MyHomePageState createState() {
    return new MyHomePageState();
  }
}

class MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    widget.cartObservable.addListener(myListener);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Start"),
        actions: <Widget>[
          new CartButton(
            itemCount: widget.cartObservable.value.itemCount,
            onPressed: () {
              Navigator.of(context).pushNamed(CartPage.routeName);
            },
          )
        ],
      ),
      body: new Column(
        children: <Widget>[
          new CartContents(
            cartObservable: widget.cartObservable,
          ),
          new Expanded(
            child: new ProductGrid(
              cartObservable: widget.cartObservable,
            ),
          ),
        ],
      ),
    );
  }

  void myListener() {
    setState(() {
      // Nothing
    });
  }
}

/// Displays the contents of the cart
class CartContents extends StatelessWidget {
  final CartObservable cartObservable;

  CartContents({
    Key key,
    @required this.cartObservable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => new Container(
      padding: const EdgeInsets.all(24.0),
      child: new Text("Cart: ${cartObservable.value.items}"));
}

/// Displays a tappable grid of products
class ProductGrid extends StatelessWidget {
  final CartObservable cartObservable;

  ProductGrid({
    Key key,
    @required this.cartObservable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => new GridView.count(
        crossAxisCount: 2,
        children: catalog.products.map((product) {
          return new ProductSquare(
            product: product,
            onTap: () {
              cartObservable.add(product);
            },
          );
        }).toList(),
      );
}
