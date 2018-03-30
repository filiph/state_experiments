import 'dart:async';

import 'package:reactive_exploration/common/models/cart.dart';
import 'package:reactive_exploration/common/models/cart_item.dart';
import 'package:reactive_exploration/common/models/product.dart';
import 'package:reactive_exploration/src/bloc/src/bloc.dart';
import 'package:rxdart/subjects.dart';

/// Adds [product] to cart. This will either update an existing [CartItem]
/// in [items] or add a new one at the end of the list.
class CartAddition {
  final Product product;
  final int count;

  const CartAddition(this.product, [this.count = 1]);
}

class CartBloc extends Bloc {
  final _cartAdditionController = new StreamController<CartAddition>();

  final _cart = new Cart();

  final _cartItems = new BehaviorSubject<List<CartItem>>();

  CartBloc() {
    _cartItems.add(_cart.items);
    _cartAdditionController.stream.listen((addition) {
      _cart.add(addition.product, addition.count);
      _cartItems.add(_cart.items);
    });
  }

  Sink<CartAddition> get cartAddition => _cartAdditionController.sink;

  /// This is the stream of the latest state of the cart.
  BehaviorSubject<List<CartItem>> get items => _cartItems;

  @override
  void dispose() {
    _cartItems.close();
    _cartAdditionController.close();
    super.dispose();
  }
}
