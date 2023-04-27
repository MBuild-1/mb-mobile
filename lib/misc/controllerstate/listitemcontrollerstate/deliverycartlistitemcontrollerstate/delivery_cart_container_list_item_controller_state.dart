import '../../../../domain/entity/additionalitem/add_additional_item_parameter.dart';
import '../../../../domain/entity/additionalitem/add_additional_item_response.dart';
import '../../../../domain/entity/additionalitem/additional_item.dart';
import '../../../../domain/entity/additionalitem/additional_item_list_parameter.dart';
import '../../../../domain/entity/additionalitem/change_additional_item_parameter.dart';
import '../../../../domain/entity/additionalitem/change_additional_item_response.dart';
import '../../../../domain/entity/additionalitem/remove_additional_item_parameter.dart';
import '../../../../domain/entity/additionalitem/remove_additional_item_response.dart';
import '../../../../domain/entity/address/address.dart';
import '../../../../domain/entity/address/current_selected_address_parameter.dart';
import '../../../../domain/entity/cart/cart.dart';
import '../../../load_data_result.dart';
import '../cartlistitemcontrollerstate/cart_list_item_controller_state.dart';
import '../list_item_controller_state.dart';

class DeliveryCartContainerListItemControllerState extends ListItemControllerState {
  List<String> selectedCartIdList;
  List<CartListItemControllerState> cartListItemControllerStateList;
  void Function() onUpdateState;
  void Function() onScrollToAdditionalItemsSection;
  void Function(List<Cart>) onChangeSelected;
  DeliveryCartContainerStateStorageListItemControllerState deliveryCartContainerStateStorageListItemControllerState;
  DeliveryCartContainerActionListItemControllerState deliveryCartContainerActionListItemControllerState;
  List<AdditionalItem> additionalItemList;

  DeliveryCartContainerListItemControllerState({
    required this.selectedCartIdList,
    required this.cartListItemControllerStateList,
    required this.onUpdateState,
    required this.onScrollToAdditionalItemsSection,
    required this.onChangeSelected,
    required this.deliveryCartContainerStateStorageListItemControllerState,
    required this.deliveryCartContainerActionListItemControllerState,
    required this.additionalItemList
  });
}

abstract class DeliveryCartContainerStateStorageListItemControllerState extends ListItemControllerState {}

abstract class DeliveryCartContainerActionListItemControllerState extends ListItemControllerState {
  Future<LoadDataResult<List<AdditionalItem>>> Function(AdditionalItemListParameter) get getAdditionalItemList;
  Future<LoadDataResult<AddAdditionalItemResponse>> Function(AddAdditionalItemParameter) get addAdditionalItem;
  Future<LoadDataResult<ChangeAdditionalItemResponse>> Function(ChangeAdditionalItemParameter) get changeAdditionalItem;
  Future<LoadDataResult<RemoveAdditionalItemResponse>> Function(RemoveAdditionalItemParameter) get removeAdditionalItem;
  Future<LoadDataResult<Address>> Function(CurrentSelectedAddressParameter) get getCurrentSelectedAddress;
}