import '../controllerstate/listitemcontrollerstate/countrydeliveryreviewlistitemcontrollerstate/country_delivery_review_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../itemtypelistinterceptor/itemtypelistinterceptorchecker/list_item_controller_state_item_type_list_interceptor_checker.dart';
import '../typedef.dart';
import 'item_type_list_sub_interceptor.dart';

class CountryDeliveryReviewItemTypeListSubInterceptor extends ItemTypeListSubInterceptor<ListItemControllerState> {
  final DoubleReturned padding;
  final DoubleReturned itemSpacing;
  final ListItemControllerStateItemTypeInterceptorChecker listItemControllerStateItemTypeInterceptorChecker;

  CountryDeliveryReviewItemTypeListSubInterceptor({
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
    List<ListItemControllerState> newListItemControllerStateList = [];
    ListItemControllerState oldItemType = oldItemTypeWrapper.listItemControllerState;
    if (oldItemType is CountryDeliveryReviewContainerListItemControllerState) {
      if (oldItemType.countryDeliveryReviewContainerStorageListItemControllerState is DefaultCountryDeliveryReviewContainerStorageListItemControllerState) {
        var countryDeliveryReviewContainerStorageListItemControllerState = oldItemType.countryDeliveryReviewContainerStorageListItemControllerState as DefaultCountryDeliveryReviewContainerStorageListItemControllerState;
        countryDeliveryReviewContainerStorageListItemControllerState._countryDeliveryReviewHeaderListItemControllerState ??= oldItemType.getCountryDeliveryReviewHeaderListItemControllerState();
        countryDeliveryReviewContainerStorageListItemControllerState._countryDeliveryReviewMediaShortContentListItemControllerState ??= oldItemType.getCountryDeliveryReviewMediaShortContentListItemControllerState();
        listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
          i, ListItemControllerStateWrapper(countryDeliveryReviewContainerStorageListItemControllerState._countryDeliveryReviewHeaderListItemControllerState!), oldItemTypeList, newListItemControllerStateList
        );
        listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
          i, ListItemControllerStateWrapper(countryDeliveryReviewContainerStorageListItemControllerState._countryDeliveryReviewMediaShortContentListItemControllerState!), oldItemTypeList, newListItemControllerStateList
        );
      }
      newItemTypeList.addAll(newListItemControllerStateList);
      return true;
    }
    return false;
  }
}

class DefaultCountryDeliveryReviewContainerStorageListItemControllerState extends CountryDeliveryReviewContainerStorageListItemControllerState {
  ListItemControllerState? _countryDeliveryReviewHeaderListItemControllerState;
  ListItemControllerState? _countryDeliveryReviewMediaShortContentListItemControllerState;
}