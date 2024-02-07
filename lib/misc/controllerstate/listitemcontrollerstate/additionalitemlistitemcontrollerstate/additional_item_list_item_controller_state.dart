import '../../../../domain/entity/additionalitem/additional_item.dart';
import '../list_item_controller_state.dart';

class AdditionalItemListItemControllerState extends ListItemControllerState {
  AdditionalItem additionalItem;
  int? no;
  void Function(AdditionalItem)? onEditAdditionalItem;
  void Function(AdditionalItem)? onRemoveAdditionalItem;
  void Function() onLoadAdditionalItem;
  bool showEditAndRemoveIcon;

  AdditionalItemListItemControllerState({
    required this.additionalItem,
    this.no,
    this.onEditAdditionalItem,
    this.onRemoveAdditionalItem,
    required this.onLoadAdditionalItem,
    this.showEditAndRemoveIcon = true
  });
}