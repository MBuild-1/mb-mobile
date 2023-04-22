import 'cart_list_item_controller_state.dart';

class VerticalCartListItemControllerState extends CartListItemControllerState {
  VerticalCartListItemControllerState({
    required super.cart,
    required super.isSelected,
    super.onChangeSelected
  });
}

class ShimmerVerticalCartListItemControllerState extends VerticalCartListItemControllerState {
  ShimmerVerticalCartListItemControllerState({
    required super.cart,
  }) : super(
    isSelected: false
  );
}