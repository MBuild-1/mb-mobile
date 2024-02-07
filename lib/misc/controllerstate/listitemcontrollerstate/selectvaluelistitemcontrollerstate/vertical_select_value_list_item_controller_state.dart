import 'select_value_list_item_controller_state.dart';

class VerticalSelectValueListItemControllerState<T> extends SelectValueListItemControllerState<T> {
  VerticalSelectValueListItemControllerState({
    required super.value,
    required super.isSelected,
    super.onSelectValue,
    required super.onConvertToStringForItemText
  });
}