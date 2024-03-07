import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../domain/entity/address/shipper_address.dart';
import '../../presentation/widget/modified_svg_picture.dart';
import '../../presentation/widget/tap_area.dart';
import '../constant.dart';
import '../controllerstate/listitemcontrollerstate/failed_prompt_indicator_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/loading_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/orderlistitemcontrollerstate/order_shipper_address_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/widget_substitution_list_item_controller_state.dart';
import '../errorprovider/error_provider.dart';
import '../itemtypelistinterceptor/itemtypelistinterceptorchecker/list_item_controller_state_item_type_list_interceptor_checker.dart';
import '../load_data_result.dart';
import '../multi_language_string.dart';
import '../toast_helper.dart';
import '../typedef.dart';
import 'item_type_list_sub_interceptor.dart';

class ShipperAddressItemTypeListSubInterceptor extends ItemTypeListSubInterceptor<ListItemControllerState> {
  final DoubleReturned padding;
  final DoubleReturned itemSpacing;
  final ListItemControllerStateItemTypeInterceptorChecker listItemControllerStateItemTypeInterceptorChecker;

  ShipperAddressItemTypeListSubInterceptor({
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
    if (oldItemType is OrderShipperAddressListItemControllerState) {
      List<ListItemControllerState> newListItemControllerStateList = [];
      LoadDataResult<ShipperAddress> shipperAddressLoadDataResult = oldItemType.shipperAddressLoadDataResult;
      if (shipperAddressLoadDataResult.isSuccess) {
        ShipperAddress shipperAddress = shipperAddressLoadDataResult.resultIfSuccess!;
        ListItemControllerState shippingAddressContentListItemControllerState = WidgetSubstitutionListItemControllerState(
          widgetSubstitution: (context, index) {
            Color mainColor = Theme.of(context).colorScheme.primary;
            return Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: mainColor,
                  width: 2.0
                ),
                borderRadius: BorderRadius.circular(12.0)
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      MultiLanguageString({
                        Constant.textInIdLanguageKey: "Kamu belum mengirim daftar kirimanmu.\r\nSegera kirim daftar kirimanmu ke warehouse kami di:",
                        Constant.textEnUsLanguageKey: "You haven't sent your shipment list yet.\r\nImmediately send your shipment list to our warehouse at:"
                      }).toEmptyStringNonNull,
                      style: const TextStyle(),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
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
                                          text: shipperAddress.name,
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
                                          text: "(${"Personal Stuffs".tr})",
                                          style: const TextStyle(
                                            fontSize: 16.0
                                          ),
                                        ),
                                      ]
                                    )
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6.0),
                              Text(
                                shipperAddress.address,
                                style: TextStyle(
                                  color: Constant.colorGrey11
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        TapArea(
                          onTap: () {
                            ClipboardData clipboardData = ClipboardData(text: shipperAddress.address);
                            Clipboard.setData(clipboardData);
                            ToastHelper.showToast("${"Success copied".tr}.");
                          },
                          child: Icon(
                            Icons.copy,
                            size: 30,
                            color: mainColor,
                          )
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }
        );
        listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
          i, ListItemControllerStateWrapper(shippingAddressContentListItemControllerState), oldItemTypeList, newItemTypeList
        );
      } else if (shipperAddressLoadDataResult.isFailed) {
        ErrorProvider errorProvider = oldItemType.errorProvider();
        newListItemControllerStateList.add(
          PaddingContainerListItemControllerState(
            padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
            paddingChildListItemControllerState: FailedPromptIndicatorListItemControllerState(
              errorProvider: errorProvider,
              e: shipperAddressLoadDataResult.resultIfFailed
            )
          )
        );
      } else if (shipperAddressLoadDataResult.isLoading) {
        newListItemControllerStateList.add(LoadingListItemControllerState());
      }
      newItemTypeList.addAll(newListItemControllerStateList);
      return true;
    }
    return false;
  }
}