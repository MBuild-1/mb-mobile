import '../../../../presentation/widget/selectvalue/select_value_item.dart';
import '../list_item_controller_state.dart';

abstract class SelectValueListItemControllerState<T> extends ListItemControllerState {
  T value;
  bool isSelected;
  OnSelectValue<T>? onSelectValue;
  OnConvertToStringForItemText<T>? onConvertToStringForItemText;

  SelectValueListItemControllerState({
    required this.value,
    required this.isSelected,
    this.onSelectValue,
    required this.onConvertToStringForItemText
  });
}