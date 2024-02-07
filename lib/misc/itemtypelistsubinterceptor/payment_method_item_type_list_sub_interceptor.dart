import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../domain/entity/payment/payment_method_group.dart';
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
      List<ListItemControllerState> resultListItemControllerStateList = [];
      resultListItemControllerStateList.addAll(
        oldItemType.paymentMethodGroupList.mapIndexed((index, paymentMethodGroup) {
          ListItemControllerState paymentMethodGroupCompoundListItemControllerState = CompoundListItemControllerState(
            listItemControllerState: [
              if (index > 0) ...[
                VirtualSpacingListItemControllerState(height: 20),
              ],
              PaddingContainerListItemControllerState(
                padding: EdgeInsets.symmetric(horizontal: padding()),
                paddingChildListItemControllerState: WidgetSubstitutionListItemControllerState(
                  widgetSubstitution: (context, index) {
                    return Text(
                      paymentMethodGroup.clientName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    );
                  }
                )
              ),
              VirtualSpacingListItemControllerState(height: 4),
              ...paymentMethodGroup.paymentMethodList.mapIndexed<ListItemControllerState>(
                (index, paymentMethod) {
                  return PaddingContainerListItemControllerState(
                    padding: EdgeInsets.symmetric(horizontal: padding()),
                    paddingChildListItemControllerState: CompoundListItemControllerState(
                      listItemControllerState: [
                        VerticalPaymentMethodListItemControllerState(
                          paymentMethod: paymentMethod,
                          onSelectPaymentMethod: (paymentMethod) {
                            oldItemType.onSelectPaymentMethod(paymentMethod);
                            oldItemType.onUpdateState();
                          },
                          isSelected: oldItemType.onGetSelectedPaymentMethodSettlingId() == paymentMethod.settlingId
                        ),
                        DividerListItemControllerState()
                      ]
                    )
                  );
                }
              ).toList(),
            ]
          );
          return paymentMethodGroupCompoundListItemControllerState;
        })
      );
      listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
        i,
        ListItemControllerStateWrapper(
          CompoundListItemControllerState(
            listItemControllerState: resultListItemControllerStateList
          )
        ),
        oldItemTypeList,
        newItemTypeList
      );
      return true;
    }
    return false;
  }
}