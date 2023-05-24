import '../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/wishlist_list_item_controller_state.dart';
import '../itemtypelistinterceptor/itemtypelistinterceptorchecker/list_item_controller_state_item_type_list_interceptor_checker.dart';
import '../listitemcontrollerstatewrapperparameter/has_intercept_child_list_item_controller_state_wrapper_parameter.dart';
import '../listitemcontrollerstatewrapperparameter/list_item_controller_state_wrapper_parameter.dart';
import '../listitemcontrollerstatewrapperparameter/vertical_grid_list_item_controller_state_wrapper_parameter.dart';
import '../typedef.dart';
import 'item_type_list_sub_interceptor.dart';

class WishlistItemTypeListSubInterceptor extends ItemTypeListSubInterceptor<ListItemControllerState> {
  final DoubleReturned padding;
  final DoubleReturned itemSpacing;
  final ListItemControllerStateItemTypeInterceptorChecker listItemControllerStateItemTypeInterceptorChecker;

  WishlistItemTypeListSubInterceptor({
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
    bool hasInterceptChild = true;
    if (oldItemTypeWrapper is ParameterizedListItemControllerStateWrapper) {
      ListItemControllerStateWrapperParameter listItemControllerStateWrapperParameter = oldItemTypeWrapper.listItemControllerStateWrapperParameter;
      if (listItemControllerStateWrapperParameter is HasInterceptChildListItemControllerStateWrapperParameter) {
        hasInterceptChild = listItemControllerStateWrapperParameter.interceptChild;
      }
    }
    ListItemControllerState oldItemType = oldItemTypeWrapper.listItemControllerState;
    if (oldItemType is WishlistListItemControllerState) {
      List<ListItemControllerState> newListItemControllerStateList = [];
      ListItemControllerState childListItemControllerState = oldItemType.childListItemControllerState;
      if (hasInterceptChild) {
        listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
          i, ListItemControllerStateWrapper(childListItemControllerState), oldItemTypeList, newListItemControllerStateList
        );
      } else {
        newListItemControllerStateList.add(childListItemControllerState);
      }
      newItemTypeList.addAll(newListItemControllerStateList);
      return true;
    }
    return false;
  }
}