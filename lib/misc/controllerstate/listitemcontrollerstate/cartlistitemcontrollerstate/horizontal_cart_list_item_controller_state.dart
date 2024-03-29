import 'cart_list_item_controller_state.dart';

class HorizontalCartListItemControllerState extends CartListItemControllerState {
  HorizontalCartListItemControllerState({
    required super.cart,
    required super.isSelected,
    super.showCheck = true,
    super.showDefaultCart = true,
    super.showBottom = true,
    super.canBeSelected = true,
    super.onChangeSelected
  });
}