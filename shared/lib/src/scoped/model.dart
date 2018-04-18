import 'package:scoped_model/scoped_model.dart';

import 'package:reactive_exploration/common/models/cart.dart';
import 'package:reactive_exploration/common/models/cart_item.dart';
import 'package:reactive_exploration/common/models/product.dart';

/// Models the state of the shopping cart
class CartModel extends Model {
  final _cart = new Cart();

  /// Returns the list of items in the cart
  List<CartItem> get items => _cart.items;

  /// Returns the number of items in the cart
  int get itemCount => _cart.itemCount;

  /// Adds a new item to the cart
  void add(Product product) {
    _cart.add(product);
    notifyListeners();
  }
}
