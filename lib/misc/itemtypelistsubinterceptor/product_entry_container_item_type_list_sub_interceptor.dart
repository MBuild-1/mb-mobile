import '../controllerstate/listitemcontrollerstate/compound_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/productentrylistitemcontrollerstate/product_entry_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/productlistitemcontrollerstate/vertical_product_list_item_controller_state.dart';
import '../itemtypelistinterceptor/itemtypelistinterceptorchecker/list_item_controller_state_item_type_list_interceptor_checker.dart';
import '../typedef.dart';
import 'item_type_list_sub_interceptor.dart';
import 'verticalgriditemtypelistsubinterceptor/vertical_grid_item_type_list_sub_interceptor.dart';

class ProductEntryContainerItemTypeListSubInterceptor extends ItemTypeListSubInterceptor<ListItemControllerState> {
  final DoubleReturned padding;
  final DoubleReturned itemSpacing;
  final ListItemControllerStateItemTypeInterceptorChecker listItemControllerStateItemTypeInterceptorChecker;

  ProductEntryContainerItemTypeListSubInterceptor({
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
    if (oldItemType is ProductEntryContainerListItemControllerState) {
      List<ListItemControllerState> newListItemControllerState = [];
      ListItemControllerState verticalProductListItemControllerState = CompoundListItemControllerState(
        listItemControllerState: [
          oldItemType.productEntryHeaderListItemControllerState(),
          VerticalGridPaddingContentSubInterceptorSupportListItemControllerState(
            childListItemControllerStateList: oldItemType.productEntryList.map<ListItemControllerState>(
              (productEntry) => VerticalProductListItemControllerState(
                productAppearanceData: productEntry,
                onAddWishlist: oldItemType.onAddWishlist,
                onRemoveWishlist: oldItemType.onRemoveWishlist,
                onAddCart: oldItemType.onAddCart,
              )
            ).toList()
          )
        ]
      );
      listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
        i, ListItemControllerStateWrapper(verticalProductListItemControllerState), oldItemTypeList, newListItemControllerState
      );
      newItemTypeList.addAll(newListItemControllerState);
      return true;
    }
    return false;
  }
}