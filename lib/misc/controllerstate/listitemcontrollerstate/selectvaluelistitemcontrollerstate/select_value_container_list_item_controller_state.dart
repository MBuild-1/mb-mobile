import '../../../../presentation/widget/selectvalue/select_value_item.dart';
import '../list_item_controller_state.dart';

typedef OnConvertToStringForComparing<T> = String Function(T);
typedef OnGetSelectValue<T> = T? Function();

class SelectValueContainerListItemControllerState extends ListItemControllerState {
  List<dynamic> valueList;
  OnSelectValue<dynamic> onSelectValue;
  OnGetSelectValue<dynamic> onGetSelectValue;
  OnConvertToStringForItemText<dynamic>? onConvertToStringForItemText;
  OnConvertToStringForComparing<dynamic>? onConvertToStringForComparing;

  SelectValueContainerListItemControllerState({
    required this.valueList,
    required this.onSelectValue,
    required this.onGetSelectValue,
    this.onConvertToStringForItemText,
    this.onConvertToStringForComparing,
  });
}