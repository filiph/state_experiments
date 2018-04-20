import 'package:flutter/material.dart';
import 'package:reactive_exploration/common/models/cart_item.dart';
import 'package:reactive_exploration/common/widgets/cart_page.dart';
import 'package:reactive_exploration/src/bloc_start/cart_provider.dart';

class BlocCartPage extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cartBloc = CartProvider.of(context);

    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Your Cart'),
      ),
      body: new StreamBuilder<List<CartItem>>(
          stream: null,
          initialData: const [],
          builder: (context, snapshot) => _buildBody(context, snapshot.data)),
    );
  }

  Widget _buildBody(BuildContext context, List<CartItem> items) {
    if (items.isEmpty) {
      return new Center(
          child: new Text('Empty cart',
              style: Theme.of(context).textTheme.display1));
    }

    final itemTiles =
        items.map((item) => new ItemTile(item: item)).toList(growable: false);
    return new ListView(children: itemTiles);
  }
}
