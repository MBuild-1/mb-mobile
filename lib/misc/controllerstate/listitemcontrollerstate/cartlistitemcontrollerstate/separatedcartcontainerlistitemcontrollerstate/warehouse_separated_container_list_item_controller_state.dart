import '../../../../../domain/entity/additionalitem/additional_item.dart';
import '../../list_item_controller_state.dart';
import 'separated_cart_container_list_item_controller_state.dart';

class WarehouseSeparatedCartContainerListItemControllerState extends SeparatedCartContainerListItemControllerState {
  List<WarehouseAdditionalItemStateValue> warehouseAdditionalItemStateValueList;
  void Function() onUpdateState;
  void Function(List<AdditionalItem>) onChangeSelected;
  void Function() onWarehouseAdditionalItemChange;
  void Function(AdditionalItem)? onRemoveWarehouseAdditionalItem;
  void Function() onLoadWarehouseAdditionalItem;

  WarehouseSeparatedCartContainerStateStorageListItemControllerState warehouseSeparatedCartContainerStateStorageListItemControllerState;
  WarehouseSeparatedCartContainerInterceptingActionListItemControllerState warehouseSeparatedCartContainerInterceptingActionListItemControllerState;

  WarehouseSeparatedCartContainerListItemControllerState({
    required this.warehouseAdditionalItemStateValueList,
    required this.onUpdateState,
    required this.onChangeSelected,
    required this.onWarehouseAdditionalItemChange,
    required this.onRemoveWarehouseAdditionalItem,
    required this.onLoadWarehouseAdditionalItem,
    required this.warehouseSeparatedCartContainerStateStorageListItemControllerState,
    required this.warehouseSeparatedCartContainerInterceptingActionListItemControllerState
  });
}

abstract class WarehouseSeparatedCartContainerStateStorageListItemControllerState extends ListItemControllerState {}

abstract class WarehouseSeparatedCartContainerInterceptingActionListItemControllerState extends ListItemControllerState {
  int Function()? get getWarehouseAdditionalItemCount;
}

class WarehouseAdditionalItemStateValue {
  AdditionalItem additionalItem;
  bool isSelected;

  WarehouseAdditionalItemStateValue({
    required this.additionalItem,
    required this.isSelected
  });
}