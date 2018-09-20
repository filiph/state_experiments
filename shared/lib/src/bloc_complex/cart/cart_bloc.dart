import 'dart:async';

import 'package:reactive_exploration/common/models/cart_item.dart';
import 'package:reactive_exploration/common/models/product.dart';
import 'package:reactive_exploration/src/bloc_complex/services/cart.dart';
import 'package:rxdart/subjects.dart';

class CartAddition {
  final Product product;
  final int count;

  CartAddition(this.product, [this.count = 1]);
}

class CartBloc {
  // This is the internal state. It's mostly a helper object so that the code
  // in this class only deals with streams.
  final _cart = CartService();

  // These are the internal objects whose streams / sinks are provided
  // by this component. See below for what each means.
  final _items = BehaviorSubject<List<CartItem>>(seedValue: []);
  final _itemCount = BehaviorSubject<int>(seedValue: 0);
  final _cartAdditionController = StreamController<CartAddition>();

  CartBloc() {
    _cartAdditionController.stream.listen(_handleAddition);
  }

  /// This is the input of additions to the cart. Use this to signal
  /// to the component that user is trying to buy a product.
  Sink<CartAddition> get cartAddition => _cartAdditionController.sink;

  /// This stream has a new value whenever the count of items in the cart
  /// changes.
  ///
  /// We're using the `distinct()` transform so that only values that are
  /// in fact a change will be published by the stream.
  Stream<int> get itemCount => _itemCount.stream.distinct();

  /// This is the stream of items in the cart. Use this to show the contents
  /// of the cart when you need all the information in [CartItem].
  Stream<List<CartItem>> get items => _items.stream;

  /// Take care of closing streams.
  void dispose() {
    _items.close();
    _itemCount.close();
    _cartAdditionController.close();
  }

  /// Business logic for adding products to cart. Adds new events to outputs
  /// as needed.
  void _handleAddition(CartAddition addition) {
    _cart.add(addition.product, addition.count);
    _items.add(_cart.items);
    _itemCount.add(_cart.itemCount);
  }
}
