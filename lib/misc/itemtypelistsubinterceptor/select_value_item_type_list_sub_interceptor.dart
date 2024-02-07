import 'package:collection/collection.dart';

import '../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/selectvaluelistitemcontrollerstate/select_value_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/selectvaluelistitemcontrollerstate/vertical_select_value_list_item_controller_state.dart';
import '../itemtypelistinterceptor/itemtypelistinterceptorchecker/list_item_controller_state_item_type_list_interceptor_checker.dart';
import '../typedef.dart';
import 'item_type_list_sub_interceptor.dart';

class SelectValueItemTypeListSubInterceptor extends ItemTypeListSubInterceptor<ListItemControllerState> {
  final DoubleReturned padding;
  final DoubleReturned itemSpacing;
  final ListItemControllerStateItemTypeInterceptorChecker listItemControllerStateItemTypeInterceptorChecker;

  SelectValueItemTypeListSubInterceptor({
    required this.padding,
    required this.itemSpacing,
    required this.listItemControllerStateItemTypeInterceptorChecker
  });

  @override
  bool intercept(
    int i,
    ListItemControllerStateWrapper oldItemTypeWrapper,
    List<ListItemControllerState> oldItemTypeList,
    List<ListItemControllerState> newItemTypeList
  ) {
    ListItemControllerState oldItemType = oldItemTypeWrapper.listItemControllerState;
    if (oldItemType is SelectValueContainerListItemControllerState) {
      List<ListItemControllerState> resultListItemControllerStateList = oldItemType.valueList.mapIndexed<ListItemControllerState>(
        (index, value) => VerticalSelectValueListItemControllerState(
          value: value,
          isSelected: oldItemType.onConvertToStringForComparing != null
            ? oldItemType.onConvertToStringForComparing!(oldItemType.onGetSelectValue()) == oldItemType.onConvertToStringForComparing!(value)
            : false,
          onSelectValue: (value) => oldItemType.onSelectValue(value),
          onConvertToStringForItemText: oldItemType.onConvertToStringForItemText
        )
      ).toList();
      for (var listItemControllerState in resultListItemControllerStateList) {
        listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
          i, ListItemControllerStateWrapper(listItemControllerState), oldItemTypeList, newItemTypeList
        );
      }
      return true;
    }
    return false;
  }
}