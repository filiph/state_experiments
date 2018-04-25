import 'package:reactive_exploration/common/models/cart.dart';
import 'package:reactive_exploration/common/models/product.dart';

/// Redux action to add a product to the cart
class AddProductAction {
  AddProductAction(this.product);
  final Product product;
}

// The reducer, which takes the previous count and increments it in response
// to an Increment action.
Cart cartReducer(Cart state, dynamic action) {
  if (action is AddProductAction) {
    print('Adding product!');
    // Reducer always returns a state,never mutating the old
    return Cart.clone(state)..add(action.product);
  }
  return state;
}
