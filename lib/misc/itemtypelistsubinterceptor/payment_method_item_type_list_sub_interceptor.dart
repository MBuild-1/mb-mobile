import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constant.dart';
import '../controllerstate/listitemcontrollerstate/compound_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/divider_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/paymentmethodlistitemcontrollerstate/payment_method_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/paymentmethodlistitemcontrollerstate/vertical_payment_method_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/widget_substitution_list_item_controller_state.dart';
import '../itemtypelistinterceptor/itemtypelistinterceptorchecker/list_item_controller_state_item_type_list_interceptor_checker.dart';
import '../typedef.dart';
import 'item_type_list_sub_interceptor.dart';

class PaymentMethodItemTypeListSubInterceptor extends ItemTypeListSubInterceptor<ListItemControllerState> {
  final DoubleReturned padding;
  final DoubleReturned itemSpacing;
  final ListItemControllerStateItemTypeInterceptorChecker listItemControllerStateItemTypeInterceptorChecker;

  PaymentMethodItemTypeListSubInterceptor({
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
    if (oldItemType is PaymentMethodContainerListItemControllerState) {
      List<ListItemControllerState> resultListItemControllerStateList = oldItemType.paymentMethodGroupList.mapIndexed<ListItemControllerState>(
        (index, paymentMethodGroup) {
          return CompoundListItemControllerState(
            listItemControllerState: [
              VirtualSpacingListItemControllerState(
                height: 10.0
              ),
              PaddingContainerListItemControllerState(
                padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
                paddingChildListItemControllerState: WidgetSubstitutionListItemControllerState(
                  widgetSubstitution: (context, index) {
                    return Text(
                      paymentMethodGroup.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    );
                  }
                )
              ),
              VirtualSpacingListItemControllerState(
                height: 10.0
              ),
              DividerListItemControllerState(
                lineColor: Colors.black
              ),
              ...paymentMethodGroup.paymentMethodList.mapIndexed(
                (index2, paymentMethod) => VerticalPaymentMethodListItemControllerState(
                  paymentMethod: paymentMethod,
                  onSelectPaymentMethod: (paymentMethod) {
                    oldItemType.onSelectPaymentMethod(paymentMethod);
                    oldItemType.onUpdateState();
                  },
                  isSelected: oldItemType.onGetSelectedPaymentMethodId() == paymentMethod.id
                )
              )
            ]
          );
        }
      ).toList();
      for (var listItemControllerState in resultListItemControllerStateList) {
        listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
          i, ListItemControllerStateWrapper(listItemControllerState), oldItemTypeList, newItemTypeList
        );
      }
      return true;
    }
    return false;
  }
}