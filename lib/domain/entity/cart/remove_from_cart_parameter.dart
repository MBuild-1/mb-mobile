import 'cart.dart';

class RemoveFromCartParameter {
  Cart cart;
  bool fromSharedCart;

  RemoveFromCartParameter({
    required this.cart,
    this.fromSharedCart = false
  });
}