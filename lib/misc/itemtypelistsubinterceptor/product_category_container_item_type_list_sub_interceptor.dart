import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllerstate/listitemcontrollerstate/compound_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/productcategorylistitemcontrollerstate/product_category_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/productcategorylistitemcontrollerstate/vertical_product_category_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/title_and_description_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import '../itemtypelistinterceptor/itemtypelistinterceptorchecker/list_item_controller_state_item_type_list_interceptor_checker.dart';
import '../typedef.dart';
import 'item_type_list_sub_interceptor.dart';
import 'verticalgriditemtypelistsubinterceptor/vertical_grid_item_type_list_sub_interceptor.dart';

class ProductCategoryContainerItemTypeListSubInterceptor extends ItemTypeListSubInterceptor<ListItemControllerState> {
  final DoubleReturned padding;
  final DoubleReturned itemSpacing;
  final ListItemControllerStateItemTypeInterceptorChecker listItemControllerStateItemTypeInterceptorChecker;

  ProductCategoryContainerItemTypeListSubInterceptor({
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
    if (oldItemType is ProductCategoryContainerListItemControllerState) {
      List<ListItemControllerState> newListItemControllerState = [];
      ListItemControllerState contentListItemControllerState = CompoundListItemControllerState(
        listItemControllerState: [
          CompoundListItemControllerState(
            listItemControllerState: [
              VirtualSpacingListItemControllerState(height: padding()),
              PaddingContainerListItemControllerState(
                padding: EdgeInsets.symmetric(horizontal: padding()),
                paddingChildListItemControllerState: TitleAndDescriptionListItemControllerState(
                  title: "Product Category".tr
                ),
              ),
            ]
          ),
          VerticalGridPaddingContentSubInterceptorSupportListItemControllerState(
            childListItemControllerStateList: [
              ...oldItemType.productCategoryList.map<ListItemControllerState>(
                (productCategory) => VerticalProductCategoryListItemControllerState(
                  productCategory: productCategory
                )
              )
            ]
          )
        ]
      );
      listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
        i, ListItemControllerStateWrapper(contentListItemControllerState), oldItemTypeList, newListItemControllerState
      );
      newItemTypeList.addAll(newListItemControllerState);
      return true;
    }
    return false;
  }
}