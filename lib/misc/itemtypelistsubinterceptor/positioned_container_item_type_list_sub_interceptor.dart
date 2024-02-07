import '../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/positioned_container_list_item_controller_state.dart';
import '../itemtypelistinterceptor/itemtypelistinterceptorchecker/list_item_controller_state_item_type_list_interceptor_checker.dart';
import 'item_type_list_sub_interceptor.dart';

class PositionedContainerItemTypeListSubInterceptor extends ItemTypeListSubInterceptor<ListItemControllerState> {
  ListItemControllerStateItemTypeInterceptorChecker listItemControllerStateItemTypeInterceptorChecker;

  PositionedContainerItemTypeListSubInterceptor({
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
    List<ListItemControllerState> newChildListItemControllerState = [];
    if (oldItemType is PositionedContainerListItemControllerState) {
      listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
        i, ListItemControllerStateWrapper(oldItemType.childListItemControllerState), oldItemTypeList, newChildListItemControllerState
      );
      if (newChildListItemControllerState.isNotEmpty) {
        newItemTypeList.add(
          PositionedContainerListItemControllerState(
            left: oldItemType.left,
            top: oldItemType.top,
            right: oldItemType.right,
            bottom: oldItemType.bottom,
            width: oldItemType.width,
            height: oldItemType.height,
            childListItemControllerState: newChildListItemControllerState.first
          )
        );
      }
      return true;
    }
    return false;
  }
}