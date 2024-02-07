import '../../../../domain/entity/additionalitem/additional_item.dart';
import '../list_item_controller_state.dart';

class ModifyWarehouseContainerListItemControllerState extends ListItemControllerState {
  List<AdditionalItem> additionalItemList;
  void Function() onGotoAddWarehouse;
  void Function(AdditionalItem) onGotoEditWarehouse;
  void Function(AdditionalItem) onRemoveWarehouse;
  void Function(List<AdditionalItem>) onSubmitModifyWarehouse;

  ModifyWarehouseContainerListItemControllerState({
    required this.additionalItemList,
    required this.onGotoAddWarehouse,
    required this.onGotoEditWarehouse,
    required this.onRemoveWarehouse,
    required this.onSubmitModifyWarehouse
  });
}