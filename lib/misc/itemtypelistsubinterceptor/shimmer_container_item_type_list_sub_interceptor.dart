import '../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/shimmer_container_list_item_controller_state.dart';
import '../itemtypelistinterceptor/itemtypelistinterceptorchecker/list_item_controller_state_item_type_list_interceptor_checker.dart';
import 'item_type_list_sub_interceptor.dart';

class ShimmerContainerItemTypeListSubInterceptor extends ItemTypeListSubInterceptor<ListItemControllerState> {
  ListItemControllerStateItemTypeInterceptorChecker listItemControllerStateItemTypeInterceptorChecker;

  ShimmerContainerItemTypeListSubInterceptor({
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
    List<ListItemControllerState> newShimmerChildListItemControllerState = [];
    if (oldItemType is ShimmerContainerListItemControllerState) {
      ListItemControllerState shimmerChildListItemControllerState = oldItemType.shimmerChildListItemControllerState;
      listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
        i, ListItemControllerStateWrapper(shimmerChildListItemControllerState), oldItemTypeList, newShimmerChildListItemControllerState
      );
      if (newShimmerChildListItemControllerState.isNotEmpty) {
        int j = 0;
        while (j < newShimmerChildListItemControllerState.length) {
          newItemTypeList.add(
            ShimmerContainerListItemControllerState(
              shimmerChildListItemControllerState: newShimmerChildListItemControllerState[j]
            )
          );
          j++;
        }
      }
      return true;
    }
    return false;
  }
}