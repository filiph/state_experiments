// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:reactive_exploration/src/scoped/scoped_cart_page.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:reactive_exploration/common/widgets/cart_button.dart';
import 'package:reactive_exploration/common/widgets/product_square.dart';
import 'package:reactive_exploration/common/widgets/theme.dart';

import 'package:reactive_exploration/common/models/catalog.dart';

import 'package:reactive_exploration/src/scoped/model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // SCOPED MODEL: Inserts a ScopedModel widget into the widget tree
    return ScopedModel<CartModel>(
      model: CartModel(),
      child: MaterialApp(
        title: 'Scoped Model',
        theme: appTheme,
        home: CatalogHomePage(),
        routes: <String, WidgetBuilder>{
          CartPage.routeName: (context) => CartPage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class CatalogHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scoped Model'),
        actions: <Widget>[
          // SCOPED MODEL: Wraps the cart button in a ScopdeModelDescendent to access
          // the nr of items in the cart
          ScopedModelDescendant<CartModel>(
            builder: (context, child, model) => CartButton(
                  itemCount: model.itemCount,
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartPage.routeName);
                  },
                ),
          )
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
        // SCOPED MODEL: Wraps items in the grid in a ScopedModelDecendent to access
        // the add() function in the cart model
        return ScopedModelDescendant<CartModel>(
          rebuildOnChange: false,
          builder: (context, child, model) => ProductSquare(
                product: product,
                onTap: () => model.add(product),
              ),
        );
      }).toList(),
    );
  }
}
