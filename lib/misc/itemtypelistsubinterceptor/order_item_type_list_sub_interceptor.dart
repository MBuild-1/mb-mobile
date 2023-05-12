import 'package:flutter/material.dart';

import '../controllerstate/listitemcontrollerstate/compound_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/orderlistitemcontrollerstate/is_running_order_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/orderlistitemcontrollerstate/order_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/orderlistitemcontrollerstate/vertical_order_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/orderlistitemcontrollerstate/waiting_for_payment_order_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import '../itemtypelistinterceptor/itemtypelistinterceptorchecker/list_item_controller_state_item_type_list_interceptor_checker.dart';
import '../typedef.dart';
import 'item_type_list_sub_interceptor.dart';

class OrderItemTypeListSubInterceptor extends ItemTypeListSubInterceptor<ListItemControllerState> {
  final DoubleReturned padding;
  final DoubleReturned itemSpacing;
  final ListItemControllerStateItemTypeInterceptorChecker listItemControllerStateItemTypeInterceptorChecker;

  OrderItemTypeListSubInterceptor({
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
    if (oldItemType is OrderContainerListItemControllerState) {
      List<VerticalOrderListItemControllerState> verticalOrderListItemControllerStateList = oldItemType.orderList.map<VerticalOrderListItemControllerState>(
        (order) => VerticalOrderListItemControllerState(order: order)
      ).toList();
      List<ListItemControllerState> newListItemControllerState = [];
      newListItemControllerState.add(
        VirtualSpacingListItemControllerState(height: padding())
      );
      ListItemControllerState waitingForPaymentOrderListItemControllerState = PaddingContainerListItemControllerState(
        padding: EdgeInsets.symmetric(horizontal: padding()),
        paddingChildListItemControllerState: WaitingForPaymentOrderListItemControllerState(
          waitingForPaymentOrderCount: 0
        )
      );
      listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
        i, ListItemControllerStateWrapper(waitingForPaymentOrderListItemControllerState), oldItemTypeList, newListItemControllerState
      );
      newListItemControllerState.add(
        VirtualSpacingListItemControllerState(height: itemSpacing())
      );
      ListItemControllerState isRunningOrderListItemControllerState = PaddingContainerListItemControllerState(
        padding: EdgeInsets.symmetric(horizontal: padding()),
        paddingChildListItemControllerState: IsRunningOrderListItemControllerState(
          isRunningOrderCount: 0
        )
      );
      listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
        i, ListItemControllerStateWrapper(isRunningOrderListItemControllerState), oldItemTypeList, newListItemControllerState
      );
      int j = 0;
      while (j < verticalOrderListItemControllerStateList.length) {
        ListItemControllerState listItemControllerState = CompoundListItemControllerState(
          listItemControllerState: [
            VirtualSpacingListItemControllerState(height: itemSpacing()),
            PaddingContainerListItemControllerState(
              padding: EdgeInsets.symmetric(horizontal: padding()),
              paddingChildListItemControllerState: verticalOrderListItemControllerStateList[j],
            ),
            if (j == verticalOrderListItemControllerStateList.length - 1) VirtualSpacingListItemControllerState(height: padding())
          ]
        );
        listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
          i, ListItemControllerStateWrapper(listItemControllerState), oldItemTypeList, newListItemControllerState
        );
        j++;
      }
      newItemTypeList.addAll(newListItemControllerState);
      return true;
    }
    return false;
  }
}