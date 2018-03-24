import 'dart:async';

import 'package:reactive_exploration/src/bloc/src/bloc.dart';
import 'package:reactive_exploration/src/shared/models/cart.dart';
import 'package:reactive_exploration/src/shared/models/product.dart';
import 'package:rxdart/subjects.dart';

class CartBloc extends Bloc {
  Cart _cart = new Cart();

  final _cartAdditionController = new StreamController<CartAddition>();

  BehaviorSubject<Cart> _cartSubject;

  CartBloc() {
    _cartAdditionController.stream.listen((addition) {
      _cart.add(addition.product, addition.count);
      _cartSubject.add(_cart);
    });
    _cartSubject = new BehaviorSubject<Cart>();
  }

  Sink<CartAddition> get cartAddition => _cartAdditionController.sink;

  /// This is the stream of the latest state of the cart.
  BehaviorSubject<Cart> get cart => _cartSubject;

  @override
  void dispose() {
    _cartSubject.close();
    _cartAdditionController.close();
  }
}

/// Adds [product] to cart. This will either update an existing [CartItem]
/// in [cartBloc] or add a new one at the end of the list.
class CartAddition {
  final Product product;
  final int count;

  const CartAddition(this.product, [this.count = 1]);
}

/// A single line in the cart.
///
/// Uses [toString] to render itself nice in text.
class CartItem {
  final int count;
  final Product product;

  const CartItem(this.count, this.product);

  @override
  String toString() => "${product.name} ✕ $count";
}
