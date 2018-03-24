import 'dart:collection';
import 'dart:math';

import 'package:reactive_exploration/src/shared/models/product.dart';

class Cart {
  List<CartItem> _items = <CartItem>[];

  /// This is the current state of the cart.
  ///
  /// This is a list because users expect their cart items to be in the same
  /// order they bought them.
  ///
  /// It is an unmodifiable view because we don't want a random widget to
  /// put the cart into a bad state. Use [add] and [remove] to modify the state.
  UnmodifiableListView<CartItem> get items => new UnmodifiableListView(_items);

  /// Adds [product] to cart. This will either update an existing [CartItem]
  /// in [items] or add a new one at the end of the list.
  void add(Product product, [int count = 1]) {
    _updateCount(product, count);
  }

  /// Removes [product] from cart. This will either update the count of
  /// an existing [CartItem] in [items] or remove it entirely (if count reaches
  /// `0`.
  void remove(Product product, [int count = 1]) {
    _updateCount(product, -count);
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
        return;
      }
    }
    if (difference < 0) return;
    _items.add(new CartItem(max(difference, 0), product));
  }

  @override
  String toString() => "$items";
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
