import '../../../../domain/entity/additionalitem/additional_item.dart';
import '../../../../domain/entity/cart/cart.dart';
import '../cartlistitemcontrollerstate/cart_list_item_controller_state.dart';
import '../list_item_controller_state.dart';

class DeliveryCartContainerListItemControllerState extends ListItemControllerState {
  List<CartListItemControllerState> cartListItemControllerStateList;
  void Function() onUpdateState;
  void Function() onScrollToAdditionalItemsSection;
  void Function(List<Cart>) onChangeSelected;
  DeliveryCartContainerStateStorageListItemControllerState deliveryCartContainerStateStorageListItemControllerState;
  List<AdditionalItem> additionalItemList;

  DeliveryCartContainerListItemControllerState({
    required this.cartListItemControllerStateList,
    required this.onUpdateState,
    required this.onScrollToAdditionalItemsSection,
    required this.onChangeSelected,
    required this.deliveryCartContainerStateStorageListItemControllerState,
    required this.additionalItemList
  });
}

abstract class DeliveryCartContainerStateStorageListItemControllerState extends ListItemControllerState {}