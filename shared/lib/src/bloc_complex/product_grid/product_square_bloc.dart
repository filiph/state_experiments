import 'dart:async';

import 'package:reactive_exploration/common/models/cart_item.dart';
import 'package:reactive_exploration/common/models/product.dart';
import 'package:rxdart/rxdart.dart';

/// Although many business logic components (BLoCs) will be at
/// the app (or screen) level, you can have BLoCs attached to single
/// UI elements.
///
/// This particular component only provides the [isInCart] output, which
/// is informed by the input stream of [cartItems].
///
/// Note that we are _not_ providing [CartBloc] to the [ProductSquareBloc]
/// directly, although it would be easier to implement. BLoCs should not
/// depend on other BLoCs (separation of concerns). They can only communicate
/// with each other using streams. In this case, the [CartBloc.items] output
/// plugs into the [ProductSquareBloc.cartItems] input.
class ProductSquareBloc {
  final _isInCartSubject = BehaviorSubject<bool>(seedValue: false);

  final _cartItemsController = StreamController<List<CartItem>>();

  ProductSquareBloc(Product product) {
    _cartItemsController.stream
        .map((list) => list.any((item) => item.product == product))
        .listen((isInCart) => _isInCartSubject.add(isInCart));
  }

  Sink<List<CartItem>> get cartItems => _cartItemsController.sink;

  /// Tells the [ProductSquare] widget whether its product is already
  /// in cart or not.
  ValueObservable<bool> get isInCart => _isInCartSubject.stream;

  /// This business logic component will have shorter lifespan than the app
  /// so we do need to dispose of it properly.
  void dispose() {
    _cartItemsController.close();
    _isInCartSubject.close();
  }
}
