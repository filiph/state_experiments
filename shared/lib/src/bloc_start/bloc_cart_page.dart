import 'package:flutter/material.dart';
import 'package:reactive_exploration/common/models/cart_item.dart';
import 'package:reactive_exploration/common/widgets/cart_page.dart';
import 'package:reactive_exploration/src/bloc_start/cart_provider.dart';

class BlocCartPage extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cartBloc = CartProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: StreamBuilder<List<CartItem>>(
          stream: null,
          initialData: const [],
          builder: (context, snapshot) => _buildBody(context, snapshot.data)),
    );
  }

  Widget _buildBody(BuildContext context, List<CartItem> items) {
    if (items.isEmpty) {
      return Center(
          child: Text('Empty cart',
              style: Theme.of(context).textTheme.display1));
    }

    final itemTiles =
        items.map((item) => ItemTile(item: item)).toList(growable: false);
    return ListView(children: itemTiles);
  }
}
