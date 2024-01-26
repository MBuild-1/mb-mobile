import '../../../../../domain/entity/cart/cart.dart';
import '../../list_item_controller_state.dart';
import '../cart_list_item_controller_state.dart';
import 'separated_cart_container_list_item_controller_state.dart';

class CartSeparatedCartContainerListItemControllerState extends SeparatedCartContainerListItemControllerState {
  List<CartListItemControllerState> cartListItemControllerStateList;
  void Function() onUpdateState;
  void Function(List<Cart>) onChangeSelected;
  void Function() onCartChange;
  CartSeparatedCartContainerInterceptingActionListItemControllerState cartSeparatedCartContainerInterceptingActionListItemControllerState;
  CartSeparatedCartContainerStateStorageListItemControllerState cartSeparatedCartContainerStateStorageListItemControllerState;

  CartSeparatedCartContainerListItemControllerState({
    required this.cartListItemControllerStateList,
    required this.onUpdateState,
    required this.onChangeSelected,
    required this.onCartChange,
    required this.cartSeparatedCartContainerInterceptingActionListItemControllerState,
    required this.cartSeparatedCartContainerStateStorageListItemControllerState
  });
}

abstract class CartSeparatedCartContainerStateStorageListItemControllerState extends ListItemControllerState {}

abstract class CartSeparatedCartContainerInterceptingActionListItemControllerState extends ListItemControllerState {
  void Function(Cart)? get removeCart;
  int Function()? get getCartCount;
}