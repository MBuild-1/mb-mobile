import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/error_provider_ext.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../../domain/entity/coupon/coupon.dart';
import '../../presentation/widget/tap_area.dart';
import '../constant.dart';
import '../controllerstate/listitemcontrollerstate/compound_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/couponlistitemcontrollerstate/coupon_indicator_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/couponlistitemcontrollerstate/vertical_coupon_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/divider_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/loading_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/widget_substitution_list_item_controller_state.dart';
import '../errorprovider/error_provider.dart';
import '../itemtypelistinterceptor/itemtypelistinterceptorchecker/list_item_controller_state_item_type_list_interceptor_checker.dart';
import '../load_data_result.dart';
import '../page_restoration_helper.dart';
import '../typedef.dart';
import 'item_type_list_sub_interceptor.dart';

class CouponIndicatorItemTypeListSubInterceptor extends ItemTypeListSubInterceptor<ListItemControllerState> {
  final DoubleReturned padding;
  final DoubleReturned itemSpacing;
  final ListItemControllerStateItemTypeInterceptorChecker listItemControllerStateItemTypeInterceptorChecker;

  CouponIndicatorItemTypeListSubInterceptor({
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
    if (oldItemType is CouponIndicatorListItemControllerState) {
      List<ListItemControllerState> newListItemControllerStateList = [];
      // Selected Coupon
      newListItemControllerStateList.add(
        PaddingContainerListItemControllerState(
          padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
          paddingChildListItemControllerState: WidgetSubstitutionListItemControllerState(
            widgetSubstitution: (context, index) {
              return Text(
                "Coupon".tr,
                style: const TextStyle(fontWeight: FontWeight.bold),
              );
            }
          )
        )
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
      LoadDataResult<Coupon> selectedCouponLoadDataResult = oldItemType.getSelectedCouponLoadDataResult();
      if (selectedCouponLoadDataResult.isSuccess) {
        newListItemControllerStateList.add(
          PaddingContainerListItemControllerState(
            padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
            paddingChildListItemControllerState: VerticalCouponListItemControllerState(
              coupon: selectedCouponLoadDataResult.resultIfSuccess!,
              isSelected: false
            )
          )
        );
      } else if (selectedCouponLoadDataResult.isFailed) {
        ErrorProvider errorProvider = oldItemType.errorProvider();
        ErrorProviderResult errorProviderResult = errorProvider.onGetErrorProviderResult(selectedCouponLoadDataResult.resultIfFailed!).toErrorProviderResultNonNull();
        newListItemControllerStateList.add(
          VirtualSpacingListItemControllerState(
            height: 10.0
          )
        );
        newItemTypeList.add(
          PaddingContainerListItemControllerState(
            padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
            paddingChildListItemControllerState: WidgetSubstitutionListItemControllerState(
              widgetSubstitution: (context, index) => Text(
                errorProviderResult.message,
                style: const TextStyle(fontWeight: FontWeight.bold)
              ),
            )
          )
        );
      } else if (selectedCouponLoadDataResult.isLoading) {
        newListItemControllerStateList.add(
          VirtualSpacingListItemControllerState(
            height: 10.0
          )
        );
        newListItemControllerStateList.add(LoadingListItemControllerState());
      } else {
        newListItemControllerStateList.add(
          PaddingContainerListItemControllerState(
            padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
            paddingChildListItemControllerState: WidgetSubstitutionListItemControllerState(
              widgetSubstitution: (context, index) {
                return Text(
                  "No selected coupon".tr,
                );
              }
            )
          )
        );
      }
      newListItemControllerStateList.add(
        VirtualSpacingListItemControllerState(
          height: 15.0
        )
      );
      newListItemControllerStateList.add(
        PaddingContainerListItemControllerState(
          padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
          paddingChildListItemControllerState: WidgetSubstitutionListItemControllerState(
            widgetSubstitution: (context, index) {
              LoadDataResult<Coupon> couponLoadDataResult = oldItemType.getSelectedCouponLoadDataResult();
              return Row(
                children: [
                  TapArea(
                    onTap: () {
                      if (oldItemType.onSelectCoupon != null) {
                        oldItemType.onSelectCoupon!();
                        return;
                      }
                      LoadDataResult<Coupon> selectedCouponLoadDataResult = oldItemType.getSelectedCouponLoadDataResult();
                      String? couponId;
                      if (selectedCouponLoadDataResult.isSuccess) {
                        couponId = selectedCouponLoadDataResult.resultIfSuccess!.id;
                      }
                      PageRestorationHelper.toCouponPage(context, couponId);
                    },
                    child: Container(
                      child: Text("Select Coupon".tr, style: const TextStyle(fontWeight: FontWeight.bold)),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        border: Border.all()
                      ),
                    )
                  ),
                  if (couponLoadDataResult.isSuccess) ...[
                    const SizedBox(width: 10),
                    TapArea(
                      onTap: () {
                        oldItemType.setSelectedCouponLoadDataResult(NoLoadDataResult<Coupon>());
                        oldItemType.onUpdateCoupon(null);
                        oldItemType.onUpdateState();
                      },
                      child: Container(
                        child: Text("Remove Coupon".tr, style: const TextStyle(fontWeight: FontWeight.bold)),
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          border: Border.all()
                        ),
                      )
                    ),
                  ]
                ]
              );
            }
          )
        )
      );
      listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
        i,
        ListItemControllerStateWrapper(
          CompoundListItemControllerState(
            listItemControllerState: newListItemControllerStateList
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