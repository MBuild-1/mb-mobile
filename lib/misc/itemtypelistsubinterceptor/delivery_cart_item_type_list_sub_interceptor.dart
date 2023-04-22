import 'package:flutter/material.dart';

import '../../domain/entity/additionalitem/additional_item.dart';
import '../../domain/entity/cart/cart.dart';
import '../controllerstate/listitemcontrollerstate/additionalitemlistitemcontrollerstate/additional_item_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/additionalitemlistitemcontrollerstate/additional_item_summary_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/cartlistitemcontrollerstate/cart_header_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/cartlistitemcontrollerstate/cart_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/compound_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/deliverycartlistitemcontrollerstate/delivery_cart_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/divider_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/spacing_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import '../itemtypelistinterceptor/itemtypelistinterceptorchecker/list_item_controller_state_item_type_list_interceptor_checker.dart';
import '../typedef.dart';
import 'item_type_list_sub_interceptor.dart';

class DeliveryCartItemTypeListSubInterceptor extends ItemTypeListSubInterceptor<ListItemControllerState> {
  final DoubleReturned padding;
  final DoubleReturned itemSpacing;
  final ListItemControllerStateItemTypeInterceptorChecker listItemControllerStateItemTypeInterceptorChecker;

  DeliveryCartItemTypeListSubInterceptor({
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
    if (oldItemType is DeliveryCartContainerListItemControllerState) {
      int j = 0;
      List<CartListItemControllerState> cartListItemControllerStateList = oldItemType.cartListItemControllerStateList;
      CartHeaderListItemControllerState cartHeaderListItemControllerState = CartHeaderListItemControllerState(
        isSelected: false,
        onChangeSelected: () {
          int k = 0;
          int selectedCount = 0;
          while (k < cartListItemControllerStateList.length) {
            CartListItemControllerState cartListItemControllerState = cartListItemControllerStateList[k];
            if (cartListItemControllerState.isSelected) {
              selectedCount += 1;
            }
            k++;
          }
          if (selectedCount == cartListItemControllerStateList.length) {
            for (var cartListItemControllerState in cartListItemControllerStateList) {
              cartListItemControllerState.isSelected = false;
            }
          } else {
            for (var cartListItemControllerState in cartListItemControllerStateList) {
              cartListItemControllerState.isSelected = true;
            }
          }
          oldItemType.onUpdateState();
        }
      );
      newItemTypeList.add(cartHeaderListItemControllerState);
      int selectedCount = 0;
      List<Cart> selectedCart = [];
      while (j < cartListItemControllerStateList.length) {
        CartListItemControllerState cartListItemControllerState = cartListItemControllerStateList[j];
        if (cartListItemControllerState.isSelected) {
          selectedCount += 1;
          selectedCart.add(cartListItemControllerState.cart);
        }
        newItemTypeList.addAll(<ListItemControllerState>[
          SpacingListItemControllerState(),
          cartListItemControllerState
        ]);
        j++;
        cartListItemControllerState.onChangeSelected = () {
          cartListItemControllerState.isSelected = !cartListItemControllerState.isSelected;
          oldItemType.onUpdateState();
        };
      }
      if (selectedCount == cartListItemControllerStateList.length) {
        cartHeaderListItemControllerState.isSelected = true;
      } else {
        cartHeaderListItemControllerState.isSelected = false;
      }
      DeliveryCartContainerStateStorageListItemControllerState deliveryCartContainerStateStorageListItemControllerState = oldItemType.deliveryCartContainerStateStorageListItemControllerState;
      if (deliveryCartContainerStateStorageListItemControllerState is DefaultDeliveryCartContainerStateStorageListItemControllerState) {
        if (selectedCount != deliveryCartContainerStateStorageListItemControllerState._lastSelectedCount) {
          deliveryCartContainerStateStorageListItemControllerState._lastSelectedCount = selectedCount;
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            oldItemType.onChangeSelected(selectedCart);
          });
        }
      }
      if (deliveryCartContainerStateStorageListItemControllerState is DefaultDeliveryCartContainerStateStorageListItemControllerState) {
        List<ListItemControllerState> newAdditionalItemListControllerStateList = [];
        for (int i = 0; i < oldItemType.additionalItemList.length; i++) {
          AdditionalItem additionalItem = oldItemType.additionalItemList[i];
          ListItemControllerState newAdditionalItemListControllerState = CompoundListItemControllerState(
            listItemControllerState: [
              VirtualSpacingListItemControllerState(height: 10),
              PaddingContainerListItemControllerState(
                padding: EdgeInsets.symmetric(horizontal: padding()),
                paddingChildListItemControllerState: AdditionalItemListItemControllerState(
                  additionalItem: additionalItem,
                  no: i + 1
                )
              )
            ]
          );
          listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
            i, ListItemControllerStateWrapper(newAdditionalItemListControllerState), oldItemTypeList, newAdditionalItemListControllerStateList
          );
        }
        newItemTypeList.addAll(newAdditionalItemListControllerStateList);
        newItemTypeList.add(VirtualSpacingListItemControllerState(height: 15.0));
        if (oldItemType.additionalItemList.isNotEmpty) {
          newItemTypeList.addAll(<ListItemControllerState>[
            PaddingContainerListItemControllerState(
              padding: EdgeInsets.symmetric(horizontal: padding()),
              paddingChildListItemControllerState: DividerListItemControllerState(
                lineColor: Colors.black
              )
            ),
            PaddingContainerListItemControllerState(
              padding: EdgeInsets.symmetric(horizontal: padding()),
              paddingChildListItemControllerState: AdditionalItemSummaryListItemControllerState(
                additionalItemList: oldItemType.additionalItemList
              )
            )
          ]);
        }
      }
      return true;
    }
    return false;
  }
}

class DefaultDeliveryCartContainerStateStorageListItemControllerState extends DeliveryCartContainerStateStorageListItemControllerState {
  int _lastSelectedCount = -1;
}