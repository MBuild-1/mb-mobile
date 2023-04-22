import '../../../../domain/entity/cart/cart.dart';
import '../list_item_controller_state.dart';

abstract class CartListItemControllerState extends ListItemControllerState {
  Cart cart;
  bool isSelected;
  void Function()? onChangeSelected;

  CartListItemControllerState({
    required this.cart,
    required this.isSelected,
    this.onChangeSelected
  });
}