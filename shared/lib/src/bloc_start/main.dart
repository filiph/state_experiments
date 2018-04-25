import 'package:flutter/material.dart';
import 'package:reactive_exploration/common/models/catalog.dart';
import 'package:reactive_exploration/common/widgets/cart_button.dart';
import 'package:reactive_exploration/common/widgets/product_square.dart';
import 'package:reactive_exploration/common/widgets/theme.dart';
import 'package:reactive_exploration/src/bloc_start/bloc_cart_page.dart';
import 'package:reactive_exploration/src/bloc_start/cart_bloc.dart';
import 'package:reactive_exploration/src/bloc_start/cart_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CartProvider(
      cartBloc: CartBloc(),
      child: MaterialApp(
        title: 'Bloc',
        theme: appTheme,
        debugShowCheckedModeBanner: false,
        home: MyHomePage(),
        routes: <String, WidgetBuilder>{
          BlocCartPage.routeName: (context) => BlocCartPage()
        },
      ),
    );
  }
}

/// The sample app's main page
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CartBloc cartBloc = CartProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Bloc"),
        actions: <Widget>[
          CartButton(
            itemCount: 0,
            onPressed: () {
              Navigator.of(context).pushNamed(BlocCartPage.routeName);
            },
          ),
        ],
      ),
      body: ProductGrid(),
    );
  }
}

/// Displays a tappable grid of products
class ProductGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartBloc = CartProvider.of(context);
    return GridView.count(
      crossAxisCount: 2,
      children: catalog.products.map((product) {
        return ProductSquare(
          product: product,
          onTap: () {
            // TODO: add product
          },
        );
      }).toList(),
    );
  }
}
