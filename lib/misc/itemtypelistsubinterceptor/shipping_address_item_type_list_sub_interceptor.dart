import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/error_provider_ext.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../domain/entity/address/address.dart';
import '../../presentation/widget/button/custombutton/sized_outline_gradient_button.dart';
import '../../presentation/widget/modified_svg_picture.dart';
import '../../presentation/widget/tap_area.dart';
import '../constant.dart';
import '../controllerstate/listitemcontrollerstate/divider_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/failed_prompt_indicator_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/loading_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/shipping_address_indicator_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/shipping_address_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/spacing_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/widget_substitution_list_item_controller_state.dart';
import '../errorprovider/error_provider.dart';
import '../itemtypelistinterceptor/itemtypelistinterceptorchecker/list_item_controller_state_item_type_list_interceptor_checker.dart';
import '../load_data_result.dart';
import '../page_restoration_helper.dart';
import '../typedef.dart';
import 'item_type_list_sub_interceptor.dart';

class ShippingAddressItemTypeListSubInterceptor extends ItemTypeListSubInterceptor<ListItemControllerState> {
  final DoubleReturned padding;
  final DoubleReturned itemSpacing;
  final ListItemControllerStateItemTypeInterceptorChecker listItemControllerStateItemTypeInterceptorChecker;

  ShippingAddressItemTypeListSubInterceptor({
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
    if (oldItemType is ShippingAddressListItemControllerState) {
      List<ListItemControllerState> newListItemControllerStateList = [];
      LoadDataResult<Address> shippingLoadDataResult = oldItemType.shippingLoadDataResult;
      Widget changeOtherAddressWidget(BuildContext context) => Container(
        color: Constant.colorSpacingListItem,
        padding: EdgeInsets.symmetric(horizontal: padding(), vertical: padding()),
        child: SizedOutlineGradientButton(
          onPressed: oldItemType.onChangeOtherAddress != null
            ? oldItemType.onChangeOtherAddress!
            : () => PageRestorationHelper.toAddressPage(context),
          text: "Change Other Address".tr,
          outlineGradientButtonType: OutlineGradientButtonType.outline,
          outlineGradientButtonVariation: OutlineGradientButtonVariation.variation5,
        ),
      );
      if (shippingLoadDataResult.isSuccess) {
        Address shippingAddress = shippingLoadDataResult.resultIfSuccess!;
        ListItemControllerState shippingAddressContentListItemControllerState = WidgetSubstitutionListItemControllerState(
          widgetSubstitution: (context, index) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding()),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your Shipping Address".tr,
                        style: const TextStyle(),
                      ),
                      const SizedBox(height: 4.0),
                      Row(
                        children: [
                          ModifiedSvgPicture.asset(
                            Constant.vectorPinPoint,
                            width: 19.0,
                            overrideDefaultColorWithSingleColor: false,
                          ),
                          const SizedBox(width: 8.0),
                          Text.rich(
                            TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: shippingAddress.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 19.0
                                  ),
                                ),
                                const TextSpan(
                                  text: " ",
                                  style: TextStyle(
                                    fontSize: 19.0
                                  ),
                                ),
                                TextSpan(
                                  text: "(${shippingAddress.label})",
                                  style: const TextStyle(
                                    fontSize: 19.0
                                  ),
                                ),
                              ]
                            )
                          ),
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        "${shippingAddress.address}, ${shippingAddress.city}, ${shippingAddress.state}, ${"Zip Code".tr} ${shippingAddress.zipCode}, ${shippingAddress.country.name}.",
                        style: TextStyle(
                          color: Constant.colorGrey11
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: padding()),
                changeOtherAddressWidget(context)
              ],
            );
          }
        );
        listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
          i, ListItemControllerStateWrapper(shippingAddressContentListItemControllerState), oldItemTypeList, newItemTypeList
        );
      } else if (shippingLoadDataResult.isFailed) {
        ErrorProvider errorProvider = oldItemType.errorProvider();
        newListItemControllerStateList.add(
          PaddingContainerListItemControllerState(
            padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
            paddingChildListItemControllerState: FailedPromptIndicatorListItemControllerState(
              errorProvider: errorProvider,
              e: shippingLoadDataResult.resultIfFailed
            )
          )
        );
        newListItemControllerStateList.add(
          VirtualSpacingListItemControllerState(
            height: 4.0
          )
        );
        newListItemControllerStateList.addAll(<ListItemControllerState>[
          WidgetSubstitutionListItemControllerState(
            widgetSubstitution: (context, index) => changeOtherAddressWidget(context)
          )
        ]);
      } else if (shippingLoadDataResult.isLoading) {
        newListItemControllerStateList.add(LoadingListItemControllerState());
        newListItemControllerStateList.add(
          VirtualSpacingListItemControllerState(
            height: padding()
          )
        );
        newListItemControllerStateList.add(
          SpacingListItemControllerState()
        );
      }
      newItemTypeList.addAll(newListItemControllerStateList);
      return true;
    }
    return false;
  }
}