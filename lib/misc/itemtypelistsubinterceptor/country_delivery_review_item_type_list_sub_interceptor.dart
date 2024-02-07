import 'package:flutter/material.dart';

import '../../domain/entity/delivery/country_delivery_review.dart';
import '../controllerstate/listitemcontrollerstate/compound_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/countrydeliveryreviewlistitemcontrollerstate/country_delivery_review_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/countrydeliveryreviewlistitemcontrollerstate/country_delivery_review_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/no_content_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/spacing_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
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
      listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
        i, ListItemControllerStateWrapper(oldItemType.getCountryDeliveryReviewHeaderListItemControllerState()), oldItemTypeList, newListItemControllerStateList
      );
      listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
        i, ListItemControllerStateWrapper(VirtualSpacingListItemControllerState(height: 16)), oldItemTypeList, newListItemControllerStateList
      );
      listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
        i,
        ListItemControllerStateWrapper(
          PaddingContainerListItemControllerState(
            padding: EdgeInsets.symmetric(horizontal: padding()),
            paddingChildListItemControllerState: oldItemType.getCountryDeliveryReviewSelectCountryListItemControllerState(),
          )
        ),
        oldItemTypeList,
        newListItemControllerStateList
      );
      if (oldItemType.countryDeliveryReviewList.isEmpty) {
        newItemTypeList.addAll(newListItemControllerStateList);
        return true;
      }
      ListItemControllerState countryDeliveryReviewMediaShortContentListItemControllerState = oldItemType.getCountryDeliveryReviewMediaShortContentListItemControllerState();
      if (countryDeliveryReviewMediaShortContentListItemControllerState is! NoContentListItemControllerState) {
        listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
          i,
          ListItemControllerStateWrapper(
            CompoundListItemControllerState(
              listItemControllerState: [
                countryDeliveryReviewMediaShortContentListItemControllerState,
                SpacingListItemControllerState()
              ]
            )
          ),
          oldItemTypeList,
          newListItemControllerStateList
        );
      }
      int j = 0;
      while (j < oldItemType.countryDeliveryReviewList.length) {
        CountryDeliveryReview countryDeliveryReview = oldItemType.countryDeliveryReviewList[j];
        ListItemControllerState countryDeliveryReviewListItemControllerState = CompoundListItemControllerState(
          listItemControllerState: [
            if (j > 0) ...[
              SpacingListItemControllerState()
            ],
            CountryDeliveryReviewListItemControllerState(countryDeliveryReview: countryDeliveryReview)
          ]
        );
        listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
          i, ListItemControllerStateWrapper(countryDeliveryReviewListItemControllerState), oldItemTypeList, newListItemControllerStateList
        );
        j++;
      }
      newItemTypeList.addAll(newListItemControllerStateList);
      return true;
    }
    return false;
  }
}