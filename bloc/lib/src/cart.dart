import 'dart:async';
import 'dart:math';

import 'package:reactive_exploration/src/bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'product.dart';

class Cart extends Bloc {
  List<CartItem> _items = <CartItem>[];

  final _cartAdditionController = new StreamController<CartAddition>();

  BehaviorSubject<List<CartItem>> _itemsSubject;

  Cart() {
    _cartAdditionController.stream.listen((addition) {
      _updateCount(addition.product, addition.count);
    });
    _itemsSubject = new BehaviorSubject<List<CartItem>>(seedValue: _items);
  }

  Sink<CartAddition> get cartAddition => _cartAdditionController.sink;

  /// This is the steam of the latest state of the cart.
  ///
  /// This is a list because users expect their cart items to be in the same
  /// order they bought them.
  ///
  /// It is an unmodifiable view because we don't want a random widget to
  /// put the cart into a bad state.
  BehaviorSubject<List<CartItem>> get items => _itemsSubject;

  @override
  void dispose() {
    _itemsSubject.close();
    _cartAdditionController.close();
  }

  void _updateCount(Product product, int difference) {
    if (difference == 0) return;
    for (int i = 0; i < _items.length; i++) {
      final item = _items[i];
      if (product == item.product) {
        final newCount = item.count + difference;
        if (newCount <= 0) {
          _items.removeAt(i);
          return;
        }
        _items[i] = new CartItem(newCount, item.product);
        _itemsSubject.add(_items);
        return;
      }
    }
    if (difference < 0) return;
    _items.add(new CartItem(max(difference, 0), product));
    _itemsSubject.add(_items);
  }
}

/// Adds [product] to cart. This will either update an existing [CartItem]
/// in [items] or add a new one at the end of the list.
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
