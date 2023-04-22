import 'support_cart.dart';

class Cart {
  SupportCart supportCart;
  int quantity;
  String? notes;

  Cart({
    required this.supportCart,
    required this.quantity,
    required this.notes
  });
}