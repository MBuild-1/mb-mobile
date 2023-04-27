import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../../domain/entity/additionalitem/additional_item.dart';
import '../../domain/entity/additionalitem/additional_item_list_parameter.dart';
import '../../domain/entity/address/address.dart';
import '../../domain/entity/address/current_selected_address_parameter.dart';
import '../../domain/entity/cart/cart.dart';
import '../../presentation/page/modaldialogpage/add_additional_item_modal_dialog_page.dart';
import '../../presentation/widget/button/custombutton/sized_outline_gradient_button.dart';
import '../../presentation/widget/tap_area.dart';
import '../constant.dart';
import '../controllerstate/listitemcontrollerstate/additionalitemlistitemcontrollerstate/additional_item_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/additionalitemlistitemcontrollerstate/additional_item_summary_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/cartlistitemcontrollerstate/cart_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/cartlistitemcontrollerstate/cart_header_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/cartlistitemcontrollerstate/cart_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/compound_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/deliverycartlistitemcontrollerstate/delivery_cart_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/divider_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/loading_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/shipping_address_indicator_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/spacing_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/widget_substitution_list_item_controller_state.dart';
import '../dialog_helper.dart';
import '../itemtypelistinterceptor/itemtypelistinterceptorchecker/list_item_controller_state_item_type_list_interceptor_checker.dart';
import '../load_data_result.dart';
import '../typedef.dart';
import 'cart_item_type_list_sub_interceptor.dart';
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
      DeliveryCartContainerStateStorageListItemControllerState deliveryCartContainerStateStorageListItemControllerState = oldItemType.deliveryCartContainerStateStorageListItemControllerState;
      DeliveryCartContainerActionListItemControllerState deliveryCartContainerActionListItemControllerState = oldItemType.deliveryCartContainerActionListItemControllerState;
      void loadShippingAddress() async {
        if (deliveryCartContainerStateStorageListItemControllerState is DefaultDeliveryCartContainerStateStorageListItemControllerState) {
          deliveryCartContainerStateStorageListItemControllerState._shippingAddressLoadDataResult = IsLoadingLoadDataResult<Address>();
          oldItemType.onUpdateState();
          LoadDataResult<Address> shippingAddressLoadDataResult = await deliveryCartContainerActionListItemControllerState.getCurrentSelectedAddress(CurrentSelectedAddressParameter());
          if (shippingAddressLoadDataResult.isFailedBecauseCancellation) {
            return;
          }
          deliveryCartContainerStateStorageListItemControllerState._shippingAddressLoadDataResult = shippingAddressLoadDataResult;
          oldItemType.onUpdateState();
        }
      }
      if (deliveryCartContainerStateStorageListItemControllerState is DefaultDeliveryCartContainerStateStorageListItemControllerState) {
        if (!deliveryCartContainerStateStorageListItemControllerState._hasLoadingShippingAddress) {
          deliveryCartContainerStateStorageListItemControllerState._hasLoadingShippingAddress = true;
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            loadShippingAddress();
          });
        }
        LoadDataResult<Address> shippingLoadDataResult = deliveryCartContainerStateStorageListItemControllerState._shippingAddressLoadDataResult;
        if (shippingLoadDataResult.isSuccess) {
          newItemTypeList.add(
            PaddingContainerListItemControllerState(
              padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
              paddingChildListItemControllerState: WidgetSubstitutionListItemControllerState(
                widgetSubstitution: (context, index) {
                  return Text(
                    "Shipping Address".tr,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  );
                }
              )
            )
          );
          newItemTypeList.add(
            VirtualSpacingListItemControllerState(
              height: 10.0
            )
          );
          newItemTypeList.add(
            DividerListItemControllerState(
              lineColor: Colors.black,
              lineHeight: 1.0
            )
          );
          newItemTypeList.add(
            ShippingAddressIndicatorListItemControllerState(
              shippingAddress: shippingLoadDataResult.resultIfSuccess!
            )
          );
          newItemTypeList.add(
            DividerListItemControllerState(
              lineColor: Colors.black,
              lineHeight: 1.0
            )
          );
          newItemTypeList.add(
            VirtualSpacingListItemControllerState(
              height: 10.0
            )
          );
          newItemTypeList.add(
            PaddingContainerListItemControllerState(
              padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
              paddingChildListItemControllerState: WidgetSubstitutionListItemControllerState(
                widgetSubstitution: (context, index) {
                  return Row(
                    children: [
                      TapArea(
                        child: Container(
                          child: Text("Change Other Address".tr, style: const TextStyle(fontWeight: FontWeight.bold)),
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
          );
          newItemTypeList.add(
            VirtualSpacingListItemControllerState(
              height: 10.0
            )
          );
        } else if (shippingLoadDataResult.isFailed) {
          newItemTypeList.add(
            VirtualSpacingListItemControllerState(
              height: 10.0
            )
          );
          newItemTypeList.add(
            PaddingContainerListItemControllerState(
              padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
              paddingChildListItemControllerState: WidgetSubstitutionListItemControllerState(
                widgetSubstitution: (context, index) => Text(
                  "Change Other Address".tr,
                  style: const TextStyle(fontWeight: FontWeight.bold)
                ),
              )
            )
          );
          newItemTypeList.add(
            VirtualSpacingListItemControllerState(
              height: 10.0
            )
          );
        } else if (shippingLoadDataResult.isLoading) {
          newItemTypeList.add(
            VirtualSpacingListItemControllerState(
              height: 10.0
            )
          );
          newItemTypeList.add(LoadingListItemControllerState());
          newItemTypeList.add(
            VirtualSpacingListItemControllerState(
              height: 10.0
            )
          );
        }
      }
      int j = 0;
      List<CartListItemControllerState> cartListItemControllerStateList = oldItemType.cartListItemControllerStateList;
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
        cartListItemControllerState.onChangeSelected = null;
      }
      if (deliveryCartContainerStateStorageListItemControllerState is DefaultDeliveryCartContainerStateStorageListItemControllerState) {
        if (selectedCount != deliveryCartContainerStateStorageListItemControllerState._lastSelectedCount) {
          deliveryCartContainerStateStorageListItemControllerState._lastSelectedCount = selectedCount;
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            oldItemType.onChangeSelected(selectedCart);
          });
        }
      }
      newItemTypeList.add(VirtualSpacingListItemControllerState(height: 10.0));
      void loadAdditionalItem({bool withScrollToAdditionalItemSection = true}) async {
        if (deliveryCartContainerStateStorageListItemControllerState is DefaultDeliveryCartContainerStateStorageListItemControllerState) {
          deliveryCartContainerStateStorageListItemControllerState._additionalItemLoadDataResult = IsLoadingLoadDataResult<List<AdditionalItem>>();
          oldItemType.onUpdateState();
          if (withScrollToAdditionalItemSection) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              oldItemType.onScrollToAdditionalItemsSection();
            });
          }
          LoadDataResult<List<AdditionalItem>> additionalItemListLoadDataResult = await deliveryCartContainerActionListItemControllerState.getAdditionalItemList(AdditionalItemListParameter());
          if (additionalItemListLoadDataResult.isFailedBecauseCancellation) {
            return;
          }
          if (additionalItemListLoadDataResult.isSuccess) {
            oldItemType.additionalItemList = additionalItemListLoadDataResult.resultIfSuccess!;
          }
          deliveryCartContainerStateStorageListItemControllerState._additionalItemLoadDataResult = additionalItemListLoadDataResult;
          oldItemType.onUpdateState();
          if (withScrollToAdditionalItemSection) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              oldItemType.onScrollToAdditionalItemsSection();
            });
          }
        }
      }
      void onLoadAdditionalItem() {
        if (deliveryCartContainerStateStorageListItemControllerState is DefaultDeliveryCartContainerStateStorageListItemControllerState) {
          deliveryCartContainerStateStorageListItemControllerState._enableSendAdditionalItems = !deliveryCartContainerStateStorageListItemControllerState._enableSendAdditionalItems;
          if (deliveryCartContainerStateStorageListItemControllerState._enableSendAdditionalItems) {
            loadAdditionalItem(withScrollToAdditionalItemSection: false);
          } else {
            oldItemType.additionalItemList = [];
          }
          oldItemType.onUpdateState();
        }
      }
      if (deliveryCartContainerStateStorageListItemControllerState is DefaultDeliveryCartContainerStateStorageListItemControllerState) {
        if (!deliveryCartContainerStateStorageListItemControllerState._enableSendAdditionalItems) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            onLoadAdditionalItem();
          });
        }
      }
      if (deliveryCartContainerStateStorageListItemControllerState is DefaultDeliveryCartContainerStateStorageListItemControllerState) {
        if (deliveryCartContainerStateStorageListItemControllerState._enableSendAdditionalItems) {
          newItemTypeList.add(
            PaddingContainerListItemControllerState(
              padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
              paddingChildListItemControllerState: WidgetSubstitutionListItemControllerState(
                widgetSubstitution: (context, index) {
                  return Text(
                    "Additional Items".tr,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  );
                }
              )
            )
          );
          newItemTypeList.add(
            VirtualSpacingListItemControllerState(
              height: 10.0
            )
          );
          newItemTypeList.add(
            PaddingContainerListItemControllerState(
              padding: EdgeInsets.symmetric(horizontal: padding()),
              paddingChildListItemControllerState: DividerListItemControllerState(
                lineColor: Colors.black
              )
            ),
          );
          newItemTypeList.add(
            VirtualSpacingListItemControllerState(
              height: 10.0
            )
          );
          if (deliveryCartContainerStateStorageListItemControllerState._additionalItemLoadDataResult.isLoading) {
            newItemTypeList.add(LoadingListItemControllerState());
          } else if (deliveryCartContainerStateStorageListItemControllerState._additionalItemLoadDataResult.isSuccess) {
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
          }
          newItemTypeList.add(VirtualSpacingListItemControllerState(height: 15.0));
          newItemTypeList.add(
            PaddingContainerListItemControllerState(
              padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
              paddingChildListItemControllerState: WidgetSubstitutionListItemControllerState(
                widgetSubstitution: (context, index) {
                  return Material(
                    color: Colors.grey.shade300,
                    child: InkWell(
                      onTap: () async {
                        dynamic result = await DialogHelper.showModalDialogPage<String, String>(
                          context: context,
                          modalDialogPageBuilder: (context, parameter) => AddAdditionalItemModalDialogPage(),
                        );
                        if (result != null) {
                          loadAdditionalItem();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Center(
                          child: Text(
                            "+ ${"Add Item".tr}",
                          ),
                        )
                      ),
                    ),
                  );
                }
              )
            )
          );
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
        } else {
          newItemTypeList.add(VirtualSpacingListItemControllerState(height: 10.0));
        }
      }
      return true;
    }
    return false;
  }
}

class DefaultDeliveryCartContainerStateStorageListItemControllerState extends DeliveryCartContainerStateStorageListItemControllerState {
  int _lastSelectedCount = -1;
  bool _enableSendAdditionalItems = false;
  bool _hasLoadingShippingAddress = false;
  LoadDataResult<List<AdditionalItem>> _additionalItemLoadDataResult = NoLoadDataResult<List<AdditionalItem>>();
  LoadDataResult<Address> _shippingAddressLoadDataResult = NoLoadDataResult<Address>();
}