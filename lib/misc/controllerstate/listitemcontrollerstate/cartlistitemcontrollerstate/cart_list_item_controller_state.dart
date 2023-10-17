import '../../../../domain/entity/cart/cart.dart';
import '../list_item_controller_state.dart';

abstract class CartListItemControllerState extends ListItemControllerState {
  Cart cart;
  bool isSelected;
  bool showDefaultCart;
  bool showCheck;
  bool showBottom;
  bool canBeSelected;
  void Function()? onChangeSelected;
  void Function()? onAddToNotes;
  void Function()? onAddToWishlist;
  void Function()? onRemoveFromNotes;
  void Function()? onRemoveCart;
  void Function()? onChangeNotes;
  void Function(int)? onChangeQuantity;

  CartListItemControllerState({
    required this.cart,
    required this.isSelected,
    required this.showDefaultCart,
    required this.showCheck,
    required this.showBottom,
    required this.canBeSelected,
    this.onChangeSelected,
    this.onAddToNotes,
    this.onAddToWishlist,
    this.onRemoveFromNotes,
    this.onRemoveCart,
    this.onChangeNotes,
    this.onChangeQuantity,
  });
}