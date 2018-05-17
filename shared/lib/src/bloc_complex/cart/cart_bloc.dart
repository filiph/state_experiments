import 'dart:async';

import 'package:reactive_exploration/common/models/cart.dart';
import 'package:reactive_exploration/common/models/cart_item.dart';
import 'package:reactive_exploration/common/models/product.dart';
import 'package:rxdart/subjects.dart';

class CartAddition {
  final Product product;
  final int count;

  CartAddition(this.product, [this.count = 1]);
}

class CartBloc {
  final Cart _cart = Cart();

  final BehaviorSubject<List<CartItem>> _items =
      BehaviorSubject<List<CartItem>>(seedValue: []);

  final _inCartProductIdsSubject =
      BehaviorSubject<Set<int>>(seedValue: Set<int>());

  final BehaviorSubject<int> _itemCount = BehaviorSubject<int>(seedValue: 0);

  final StreamController<CartAddition> _cartAdditionController =
      StreamController<CartAddition>();

  CartBloc() {
    _cartAdditionController.stream.listen((addition) {
      _cart.add(addition.product, addition.count);
      _items.add(_cart.items);
      _itemCount.add(_cart.itemCount);
      _inCartProductIdsSubject
          .add(_cart.items.map((item) => item.product.id).toSet());
    });
  }

  Sink<CartAddition> get cartAddition => _cartAdditionController.sink;

  Stream<Set<int>> get inCartProductIds =>
      _inCartProductIdsSubject.stream.distinct();

  Stream<int> get itemCount => _itemCount.stream.distinct();

  Stream<List<CartItem>> get items => _items.stream;

  void dispose() {
    _items.close();
    _itemCount.close();
    _cartAdditionController.close();
  }
}
