import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../domain/entity/payment/payment_method_group.dart';
import '../../presentation/widget/colorful_chip_tab_bar.dart';
import '../../presentation/widget/modified_chip.dart';
import '../../presentation/widget/modified_svg_picture.dart';
import '../constant.dart';
import '../controllerstate/listitemcontrollerstate/builder_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/colorful_chip_tab_bar_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/paymentmethodlistitemcontrollerstate/payment_method_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/paymentmethodlistitemcontrollerstate/vertical_grid_payment_method_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import '../itemtypelistinterceptor/itemtypelistinterceptorchecker/list_item_controller_state_item_type_list_interceptor_checker.dart';
import '../typedef.dart';
import 'item_type_list_sub_interceptor.dart';
import 'verticalgriditemtypelistsubinterceptor/vertical_grid_item_type_list_sub_interceptor.dart';

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
      String? selectedPaymentGroupId() {
        ColorfulChipTabBarController colorfulChipTabBarController = oldItemType.onGetPaymentMethodColorfulChipTabBarController();
        if (colorfulChipTabBarController.value < 0) {
          return null;
        }
        List<PaymentMethodGroup> paymentMethodGroupList = oldItemType.paymentMethodGroupList;
        Iterable<PaymentMethodGroup> paymentMethodGroupIterable = paymentMethodGroupList.where(
          (paymentMethodGroup) => paymentMethodGroup.id == paymentMethodGroupList[colorfulChipTabBarController.value].id
        );
        return paymentMethodGroupIterable.firstOrNull?.id;
      }
      List<ListItemControllerState> resultListItemControllerStateList = [
        ColorfulChipTabBarListItemControllerState(
          canSelectAndUnselect: false,
          isWrap: false,
          chipLabelInterceptor: (textStyle, data) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    data.title.toStringNonNull,
                    style: textStyle
                  ),
                  const SizedBox(width: 8.0),
                  ModifiedSvgPicture.asset(
                    Constant.vectorChecklist,
                    width: 24.0,
                    color: textStyle?.color
                  )
                ]
              ),
            );
          },
          colorfulChipTabBarController: oldItemType.onGetPaymentMethodColorfulChipTabBarController(),
          colorfulChipTabBarDataList: () {
            List<PaymentMethodGroup> paymentMethodGroupList = oldItemType.paymentMethodGroupList;
            List<ColorfulChipTabBarData> colorfulChipTabBarData = [];
            int k = 0;
            while (k < paymentMethodGroupList.length) {
              PaymentMethodGroup paymentMethodGroup = paymentMethodGroupList[k];
              colorfulChipTabBarData.add(
                ColorfulChipTabBarData(
                  title: paymentMethodGroup.clientName,
                  color: oldItemType.onGetPaymentMethodTabColor(),
                  data: paymentMethodGroup.id
                )
              );
              k++;
            }
            return colorfulChipTabBarData;
          }(),
          colorfulChipTabBarInterceptor: (colorfulChipTabBarParameter) {
            ModifiedChipButton modifiedChipButton = colorfulChipTabBarParameter.modifiedChipButton;
            ModifiedChipButton newModifiedChipButton = ModifiedChipButton(
              label: modifiedChipButton.label,
              labelInterceptor: modifiedChipButton.labelInterceptor,
              backgroundColor: modifiedChipButton.backgroundColor,
              isSelected: true,
              canSelectAndUnselect: true,
              onTap: modifiedChipButton.onTap
            );
            bool isSelected = modifiedChipButton.isSelected;
            return isSelected ? IgnorePointer(
              child: newModifiedChipButton,
            ) : Opacity(
              opacity: 0.3,
              child: newModifiedChipButton
            );
          }
        ),
        VirtualSpacingListItemControllerState(
          height: 10.0
        ),
        BuilderListItemControllerState(
          buildListItemControllerState: () {
            Iterable<PaymentMethodGroup> paymentMethodGroupIterable = oldItemType.paymentMethodGroupList.where(
              (paymentMethodGroup) => paymentMethodGroup.id == selectedPaymentGroupId()
            );
            List<ListItemControllerState> verticalPaymentMethodListItemControllerStateList = [];
            for (PaymentMethodGroup paymentMethodGroup in paymentMethodGroupIterable) {
              verticalPaymentMethodListItemControllerStateList.addAll(
                paymentMethodGroup.paymentMethodList.mapIndexed(
                  (index, paymentMethod) => VerticalGridPaymentMethodListItemControllerState(
                    paymentMethod: paymentMethod,
                    onSelectPaymentMethod: (paymentMethod) {
                      oldItemType.onSelectPaymentMethod(paymentMethod);
                      oldItemType.onUpdateState();
                    },
                    isSelected: oldItemType.onGetSelectedPaymentMethodId() == paymentMethod.id
                  )
                )
              );
            }
            return VerticalGridPaddingContentSubInterceptorSupportListItemControllerState(
              childListItemControllerStateList: verticalPaymentMethodListItemControllerStateList,
              verticalGridPaddingContentSubInterceptorSupportParameter: VerticalGridPaddingContentSubInterceptorSupportParameter(
                paddingTop: 8.0,
                itemSpacing: 12.0
              )
            );
          }
        )
      ];
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