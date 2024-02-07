import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/error_provider_ext.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../../domain/entity/payment/payment_method.dart';
import '../../presentation/widget/payment/paymentmethod/selected_payment_method_indicator.dart';
import '../../presentation/widget/tap_area.dart';
import '../constant.dart';
import '../controllerstate/listitemcontrollerstate/divider_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/loading_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/paymentmethodlistitemcontrollerstate/payment_method_indicator_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/widget_substitution_list_item_controller_state.dart';
import '../errorprovider/error_provider.dart';
import '../itemtypelistinterceptor/itemtypelistinterceptorchecker/list_item_controller_state_item_type_list_interceptor_checker.dart';
import '../load_data_result.dart';
import '../typedef.dart';
import 'item_type_list_sub_interceptor.dart';

class PaymentMethodIndicatorItemTypeListSubInterceptor extends ItemTypeListSubInterceptor<ListItemControllerState> {
  final DoubleReturned padding;
  final DoubleReturned itemSpacing;
  final ListItemControllerStateItemTypeInterceptorChecker listItemControllerStateItemTypeInterceptorChecker;

  PaymentMethodIndicatorItemTypeListSubInterceptor({
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
    if (oldItemType is PaymentMethodIndicatorListItemControllerState) {
      List<ListItemControllerState> newListItemControllerStateList = [];
      listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
        i,
        ListItemControllerStateWrapper(
          PaddingContainerListItemControllerState(
            padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
            paddingChildListItemControllerState: WidgetSubstitutionListItemControllerState(
              widgetSubstitution: (context, index) {
                return Text(
                  "Payment Method".tr,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                );
              }
            )
          )
        ),
        oldItemTypeList,
        newListItemControllerStateList
      );
      newListItemControllerStateList.add(
        VirtualSpacingListItemControllerState(
          height: 10.0
        )
      );
      newListItemControllerStateList.add(
        DividerListItemControllerState(
          lineColor: Colors.black
        )
      );
      newListItemControllerStateList.add(
        VirtualSpacingListItemControllerState(
          height: 10.0
        )
      );
      LoadDataResult<PaymentMethod> selectedPaymentMethodLoadDataResult = oldItemType.selectedPaymentMethodLoadDataResult();
      if (selectedPaymentMethodLoadDataResult.isSuccess) {
        listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
          i,
          ListItemControllerStateWrapper(
            PaddingContainerListItemControllerState(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              paddingChildListItemControllerState: WidgetSubstitutionListItemControllerState(
                widgetSubstitution: (context, index) => SelectedPaymentMethodIndicator(
                  onTap: oldItemType.onSelectPaymentMethod,
                  onRemove: oldItemType.onRemovePaymentMethod,
                  selectedPaymentMethod: selectedPaymentMethodLoadDataResult.resultIfSuccess!,
                ),
              )
            )
          ),
          oldItemTypeList,
          newListItemControllerStateList
        );
      } else if (selectedPaymentMethodLoadDataResult.isFailed) {
        ErrorProvider errorProvider = oldItemType.errorProvider();
        ErrorProviderResult errorProviderResult = errorProvider.onGetErrorProviderResult(selectedPaymentMethodLoadDataResult.resultIfFailed!).toErrorProviderResultNonNull();
        newListItemControllerStateList.add(
          VirtualSpacingListItemControllerState(
            height: 10.0
          )
        );
        listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
          i,
          ListItemControllerStateWrapper(
            PaddingContainerListItemControllerState(
              padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
              paddingChildListItemControllerState: WidgetSubstitutionListItemControllerState(
                widgetSubstitution: (context, index) => Text(
                  errorProviderResult.message,
                  style: const TextStyle(fontWeight: FontWeight.bold)
                ),
              )
            )
          ),
          oldItemTypeList,
          newListItemControllerStateList
        );
      } else if (selectedPaymentMethodLoadDataResult.isLoading) {
        newListItemControllerStateList.add(
          VirtualSpacingListItemControllerState(
            height: 10.0
          )
        );
        newListItemControllerStateList.add(LoadingListItemControllerState());
      } else {
        listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
          i,
          ListItemControllerStateWrapper(
            PaddingContainerListItemControllerState(
              padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
              paddingChildListItemControllerState: WidgetSubstitutionListItemControllerState(
                widgetSubstitution: (context, index) {
                  return Text(
                    "No selected payment method".tr,
                  );
                }
              )
            )
          ),
          oldItemTypeList,
          newListItemControllerStateList
        );
        newListItemControllerStateList.add(
          VirtualSpacingListItemControllerState(
            height: 15.0
          )
        );
        listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
          i,
          ListItemControllerStateWrapper(
            PaddingContainerListItemControllerState(
              padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
              paddingChildListItemControllerState: WidgetSubstitutionListItemControllerState(
                widgetSubstitution: (context, index) {
                  return Row(
                    children: [
                      TapArea(
                        onTap: oldItemType.onSelectPaymentMethod,
                        child: Container(
                          child: Text("Select Payment Method".tr, style: const TextStyle(fontWeight: FontWeight.bold)),
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            border: Border.all()
                          ),
                        )
                      ),
                    ]
                  );
                }
              )
            )
          ),
          oldItemTypeList,
          newListItemControllerStateList
        );
      }
      newItemTypeList.addAll(newListItemControllerStateList);
      return true;
    }
    return false;
  }
}