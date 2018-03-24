import 'dart:async';

import 'package:reactive_exploration/src/bloc/src/bloc.dart';
import 'package:reactive_exploration/src/shared/models/cart.dart';
import 'package:reactive_exploration/src/shared/models/catalog.dart';
import 'package:reactive_exploration/src/shared/models/product.dart';
import 'package:rxdart/subjects.dart';

/// Adds [product] to cart. This will either update an existing [CartItem]
/// in [shop] or add a new one at the end of the list.
class CartAddition {
  final Product product;
  final int count;

  const CartAddition(this.product, [this.count = 1]);
}

class Shop extends Bloc {
  final _requestRefreshController = new StreamController<Null>();

  final _cartAdditionController = new StreamController<CartAddition>();

  BehaviorSubject<Cart> _cartSubject =
      new BehaviorSubject<Cart>(seedValue: new Cart());

  final BehaviorSubject<Catalog> _catalogSubject =
      new BehaviorSubject<Catalog>(seedValue: new Catalog.empty());

  final BehaviorSubject<bool> _loading =
      new BehaviorSubject<bool>(seedValue: true);

  Shop() {
    _requestRefreshController.stream.listen((_) {
      _fetchCatalog();
      _loading.add(true);
    });
    _fetchCatalog();

    _cartAdditionController.stream.listen((addition) {
      var cart = _cartSubject.value;
      cart.add(addition.product, addition.count);
      _cartSubject.add(cart);
    });
  }

  /// This is the stream of the latest state of the cart.
  BehaviorSubject<Cart> get cart => _cartSubject;

  Sink<CartAddition> get cartAddition => _cartAdditionController.sink;

  /// This is the stream of the latest state of the cart.
  BehaviorSubject<Catalog> get catalog => _catalogSubject;

  BehaviorSubject<bool> get loading => _loading;

  Sink<Null> get requestRefresh => _requestRefreshController.sink;

  @override
  void dispose() {
    _catalogSubject.close();
    _requestRefreshController.close();
    _loading.close();
    _cartSubject.close();
    _cartAdditionController.close();
    super.dispose();
  }

  void _fetchCatalog() {
    fetchCatalog().then((fetched) {
      _catalogSubject.add(fetched);
      _loading.add(false);
    });
  }
}
