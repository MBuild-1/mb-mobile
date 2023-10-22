import '../controllerstate/listitemcontrollerstate/compound_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/widget_substitution_list_item_controller_state.dart';
import '../itemtypelistinterceptor/itemtypelistinterceptorchecker/list_item_controller_state_item_type_list_interceptor_checker.dart';
import '../typedef.dart';
import 'item_type_list_sub_interceptor.dart';

class WidgetSubstitutionItemTypeListSubInterceptor extends ItemTypeListSubInterceptor<ListItemControllerState> {
  final DoubleReturned padding;
  final DoubleReturned itemSpacing;
  final ListItemControllerStateItemTypeInterceptorChecker listItemControllerStateItemTypeInterceptorChecker;

  WidgetSubstitutionItemTypeListSubInterceptor({
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
    if (oldItemType is WidgetSubstitutionWithInjectionListItemControllerState) {
      List<ListItemControllerState> newListItemControllerStateList = [];
      if (oldItemType.onInjectListItemControllerState != null) {
        listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
          i,
          ListItemControllerStateWrapper(
            CompoundListItemControllerState(
              listItemControllerState: oldItemType.onInjectListItemControllerState!()
            )
          ),
          oldItemTypeList,
          newListItemControllerStateList
        );
      }
      newItemTypeList.add(
        WidgetSubstitutionWithInjectionListItemControllerState(
          widgetSubstitutionWithInjection: oldItemType.widgetSubstitutionWithInjection,
          onInjectListItemControllerState: () => newListItemControllerStateList
        )
      );
      return true;
    }
    return false;
  }
}