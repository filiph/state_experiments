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
  final Cart _cart = new Cart();

  final BehaviorSubject<List<CartItem>> _items =
      new BehaviorSubject<List<CartItem>>(seedValue: []);

  final BehaviorSubject<int> _itemCount =
      new BehaviorSubject<int>(seedValue: 0);

  final StreamController<CartAddition> _cartAdditionController =
      new StreamController<CartAddition>();

  CartBloc() {
    _cartAdditionController.stream.listen((addition) {
      int currentCount = _cart.itemCount;
      _cart.add(addition.product, addition.count);
      _items.add(_cart.items);
      int updatedCount = _cart.itemCount;
      if (updatedCount != currentCount) {
        _itemCount.add(updatedCount);
      }
    });
  }

  Sink<CartAddition> get cartAddition => _cartAdditionController.sink;

  BehaviorSubject<int> get itemCount => _itemCount;

  BehaviorSubject<List<CartItem>> get items => _items;

  void dispose() {
    _items.close();
    _itemCount.close();
    _cartAdditionController.close();
  }
}

