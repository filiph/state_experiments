import 'dart:collection';
import 'dart:math';
import 'dart:ui';

import 'package:reactive_exploration/common/models/cart_item.dart';
import 'package:reactive_exploration/common/models/product.dart';

class CartService {
  final List<CartItem> _items = <CartItem>[];

  Set<VoidCallback> _listeners = Set();

  /// Creates an empty cart.
  /// TODO: introduce randomModifications for network-initiated changes
  ///       nothing by default, but can clear data every ~5 seconds
  CartService();

  /// The total count of items in cart, including duplicates of the same item.
  ///
  /// This is in contrast of just doing [items.length], which only counts
  /// each product once, regardless of how many are being bought.
  int get itemCount => _items.fold(0, (sum, el) => sum + el.count);

  /// This is the current state of the cart.
  ///
  /// This is a list because users expect their cart items to be in the same
  /// order they bought them.
  ///
  /// It is an unmodifiable view because we don't want a random widget to
  /// put the cart into a bad state. Use [add] and [remove] to modify the state.
  UnmodifiableListView<CartItem> get items => UnmodifiableListView(_items);

  /// Adds [product] to cart. This will either update an existing [CartItem]
  /// in [items] or add a one at the end of the list.
  void add(Product product, [int count = 1]) {
    _updateCount(product, count);
  }

  /// Add a callback that will be called whenever the contents of the Cart
  /// change.
  void addListener(VoidCallback listener) => _listeners.add(listener);

  /// Removes [product] from cart. This will either update the count of
  /// an existing [CartItem] in [items] or remove it entirely (if count reaches
  /// `0`.
  void remove(Product product, [int count = 1]) {
    _updateCount(product, -count);
  }

  /// Remove a callback previously added by [addListener].
  void removeListener(VoidCallback listener) => _listeners.remove(listener);

  @override
  String toString() => "$items";

  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }

  void _updateCount(Product product, int difference) {
    if (difference == 0) return;
    for (int i = 0; i < _items.length; i++) {
      final item = _items[i];
      if (product == item.product) {
        final newCount = item.count + difference;
        if (newCount <= 0) {
          _items.removeAt(i);
          _notifyListeners();
          return;
        }
        _items[i] = CartItem(newCount, item.product);
        _notifyListeners();
        return;
      }
    }
    if (difference < 0) return;
    _items.add(CartItem(max(difference, 0), product));
    _notifyListeners();
  }
}
