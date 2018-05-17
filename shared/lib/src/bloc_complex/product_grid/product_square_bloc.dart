import 'dart:async';

import 'package:reactive_exploration/common/models/cart_item.dart';
import 'package:reactive_exploration/common/models/product.dart';
import 'package:rxdart/rxdart.dart';

class ProductSquareBloc {
  final _isInCartSubject = BehaviorSubject<bool>();

  StreamSubscription<bool> _subscription;

  ProductSquareBloc(Product product, Stream<List<CartItem>> items) {
    _subscription = items
        .map((list) => list.any((item) => item.product == product))
        .listen((isInCart) => _isInCartSubject.add(isInCart));
  }

  /// Tells the [ProductSquare] widget whether its product is already
  /// in cart or not.
  Stream<bool> get isInCart => _isInCartSubject.stream;

  /// This business logic component will have shorter lifespan than the app
  /// so we do need to dispose of it properly.
  void dispose() {
    _subscription.cancel();
    _isInCartSubject.close();
  }
}
