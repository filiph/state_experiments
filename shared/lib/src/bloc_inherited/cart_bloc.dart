import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:reactive_exploration/common/models/cart.dart';
import 'package:reactive_exploration/common/models/cart_item.dart';
import 'package:reactive_exploration/common/models/catalog.dart';
import 'package:reactive_exploration/common/models/product.dart';
import 'package:rxdart/subjects.dart';

class CartAddition {
  final Product product;
  final int count;

  CartAddition(this.product, [this.count = 1]);
}

class CartBloc extends InheritedWidget {
  final Cart _cart = new Cart();

  final BehaviorSubject<List<CartItem>> _items= new BehaviorSubject<List<CartItem>>();

  final BehaviorSubject<int> _itemCount= new BehaviorSubject<int>();

  final StreamController<CartAddition> _cartAdditionController=  new StreamController<CartAddition>();

  CartBloc({
    Key key,
    @required Widget child,
  }) : super(key: key, child: child) {
    _items.add(_cart.items);
    _itemCount.add(_cart.itemCount);
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

  static CartBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(CartBloc) as CartBloc);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}
