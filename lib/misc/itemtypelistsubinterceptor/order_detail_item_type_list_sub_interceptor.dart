import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/order_purchasing_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entity/additionalitem/additional_item.dart';
import '../../domain/entity/address/address.dart';
import '../../domain/entity/order/combined_order.dart';
import '../../domain/entity/order/modifywarehouseinorder/modifywarehouseinorderitem/all_required_fields_warehouse_in_order_item.dart';
import '../../domain/entity/order/modifywarehouseinorder/modifywarehouseinorderitem/optional_fields_warehouse_in_order_item.dart';
import '../../domain/entity/order/modifywarehouseinorder/modifywarehouseinorderparameter/add_warehouse_in_order_parameter.dart';
import '../../domain/entity/order/modifywarehouseinorder/modifywarehouseinorderparameter/change_warehouse_in_order_parameter.dart';
import '../../domain/entity/order/modifywarehouseinorder/modifywarehouseinorderparameter/remove_warehouse_in_order_parameter.dart';
import '../../domain/entity/order/order.dart';
import '../../domain/entity/order/order_product_detail.dart';
import '../../domain/entity/order/order_product_inventory.dart';
import '../../presentation/widget/address/horizontal_address_item.dart';
import '../../presentation/widget/address/vertical_address_item.dart';
import '../../presentation/widget/button/custombutton/sized_outline_gradient_button.dart';
import '../../presentation/widget/colorful_chip.dart';
import '../../presentation/widget/order/order_conclusion_item.dart';
import '../../presentation/widget/order/order_product_detail_item.dart';
import '../../presentation/widget/order/order_product_inventory_item.dart';
import '../../presentation/widget/order/order_send_to_warehouse_item.dart';
import '../../presentation/widget/order/order_status_indicator.dart';
import '../../presentation/widget/summary_widget.dart';
import '../../presentation/widget/tap_area.dart';
import '../constant.dart';
import '../controllerstate/listitemcontrollerstate/additionalitemlistitemcontrollerstate/additional_item_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/additionalitemlistitemcontrollerstate/additional_item_summary_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/builder_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/cartlistitemcontrollerstate/cart_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/compound_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/divider_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/orderlistitemcontrollerstate/order_detail_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/spacing_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/title_and_description_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/widget_substitution_list_item_controller_state.dart';
import '../http_client.dart';
import '../itemtypelistinterceptor/itemtypelistinterceptorchecker/list_item_controller_state_item_type_list_interceptor_checker.dart';
import '../multi_language_string.dart';
import '../typedef.dart';
import '../web_helper.dart';
import 'item_type_list_sub_interceptor.dart';

class OrderDetailItemTypeListSubInterceptor extends ItemTypeListSubInterceptor<ListItemControllerState> {
  final DoubleReturned padding;
  final DoubleReturned itemSpacing;
  final ListItemControllerStateItemTypeInterceptorChecker listItemControllerStateItemTypeInterceptorChecker;

  OrderDetailItemTypeListSubInterceptor({
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
    if (oldItemType is OrderDetailContainerListItemControllerState) {
      List<ListItemControllerState> newListItemControllerState = [];
      newListItemControllerState.add(SpacingListItemControllerState());
      _interceptForBasicOrderInformation(i, oldItemType, oldItemTypeList, newListItemControllerState);
      newListItemControllerState.add(SpacingListItemControllerState());
      _interceptForAddressInformation(i, oldItemType, oldItemTypeList, newListItemControllerState);
      newListItemControllerState.add(SpacingListItemControllerState());
      _interceptForTransactionOrderInformation(i, oldItemType, oldItemTypeList, newListItemControllerState);
      newListItemControllerState.add(SpacingListItemControllerState());
      _interceptForProductInventoryInformation(i, oldItemType, oldItemTypeList, newListItemControllerState);
      newListItemControllerState.add(SpacingListItemControllerState());
      _interceptForOrderSendToWarehouseInformation(i, oldItemType, oldItemTypeList, newListItemControllerState);
      newListItemControllerState.add(SpacingListItemControllerState());
      _interceptForOtherProductInformation(i, oldItemType, oldItemTypeList, newListItemControllerState);
      newListItemControllerState.add(SpacingListItemControllerState());
      _interceptForTransactionOrderSummaryInformation(i, oldItemType, oldItemTypeList, newListItemControllerState);
      if (oldItemType.order.combinedOrder.invoiceId.isNotEmptyString) {
        newListItemControllerState.add(SpacingListItemControllerState());
        _interceptForTransactionOrderInvoiceInformation(i, oldItemType, oldItemTypeList, newListItemControllerState);
      }
      newItemTypeList.addAll(newListItemControllerState);
      return true;
    }
    return false;
  }

  void _interceptForBasicOrderInformation(
    int i,
    OrderDetailContainerListItemControllerState orderDetailContainerListItemControllerState,
    List<ListItemControllerState> oldItemTypeList,
    List<ListItemControllerState> newListItemControllerState
  ) {
    Order order = orderDetailContainerListItemControllerState.order;
    newListItemControllerState.add(
      VirtualSpacingListItemControllerState(height: padding())
    );
    ListItemControllerState transactionNumberStatusListItemControllerState = PaddingContainerListItemControllerState(
      padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
      paddingChildListItemControllerState: WidgetSubstitutionListItemControllerState(
        widgetSubstitution: (context, index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  "Transaction Number".tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold
                  )
                ),
              ),
              const SizedBox(width: 10),
              ColorfulChip(
                text: order.combinedOrder.orderCode,
                textStyle: const TextStyle(
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold
                ),
                padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
                color: Constant.colorLightBlue2
              )
            ],
          );
        }
      )
    );
    listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
      i, ListItemControllerStateWrapper(transactionNumberStatusListItemControllerState), oldItemTypeList, newListItemControllerState
    );
    int getStatusStep(String status) {
      List<String> statusList = [
        "Menunggu Konfirmasi",
        "Pesanan Diproses",
        "Siap Dikirim",
        "Sedang Dikirim",
        "Sampai Tujuan"
      ];
      int index = -1;
      for (int i = 0; i < statusList.length; i++) {
        if (statusList[i].toLowerCase() == status.toLowerCase()) {
          index = i;
          break;
        }
      }
      return index + 1;
    }
    newListItemControllerState.add(VirtualSpacingListItemControllerState(height: 20));
    ListItemControllerState statusListItemControllerState = PaddingContainerListItemControllerState(
      padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
      paddingChildListItemControllerState: WidgetSubstitutionListItemControllerState(
        widgetSubstitution: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Status".tr,
                style: const TextStyle(
                  fontWeight: FontWeight.bold
                )
              ),
              const SizedBox(height: 10),
              OrderStatusIndicator(
                step: getStatusStep(order.combinedOrder.status),
                isLoadingStep: false
              )
            ],
          );
        }
      )
    );
    listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
      i, ListItemControllerStateWrapper(statusListItemControllerState), oldItemTypeList, newListItemControllerState
    );
    if (getStatusStep(order.combinedOrder.status) > 0) {
      newListItemControllerState.add(VirtualSpacingListItemControllerState(height: 20));
      ListItemControllerState productPaymentListItemControllerState = PaddingContainerListItemControllerState(
        padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
        paddingChildListItemControllerState: WidgetSubstitutionListItemControllerState(
          widgetSubstitution: (context, index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    "Product Payment".tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold
                    )
                  ),
                ),
                const SizedBox(width: 10),
                Builder(
                  builder: (context) {
                    late String chipText;
                    Color? chipTextColor;
                    late Color chipColor;
                    if (order.combinedOrder.orderProduct.orderDetail.status == "pending") {
                      chipText = "Not Finish".tr;
                      chipTextColor = Colors.white;
                      chipColor = Constant.colorRedDanger;
                    } else {
                      chipText = "Finish".tr;
                      chipColor = Constant.colorSuccessLightGreen;
                    }
                    return ColorfulChip(
                      text: chipText,
                      textStyle: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                        color: chipTextColor
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
                      color: chipColor
                    );
                  }
                )
              ],
            );
          }
        )
      );
      listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
        i, ListItemControllerStateWrapper(productPaymentListItemControllerState), oldItemTypeList, newListItemControllerState
      );
      if (getStatusStep(order.combinedOrder.status) >= 3) {
        newListItemControllerState.add(VirtualSpacingListItemControllerState(height: 12));
        ListItemControllerState productPaymentListItemControllerState = PaddingContainerListItemControllerState(
          padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
          paddingChildListItemControllerState: WidgetSubstitutionListItemControllerState(
            widgetSubstitution: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      "Product Delivery".tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold
                      )
                    ),
                  ),
                  const SizedBox(width: 10),
                  Builder(
                    builder: (context) {
                      late String chipText;
                      Color? chipTextColor;
                      late Color chipColor;
                      if (order.combinedOrder.status.toLowerCase() == "siap dikirim") {
                        chipText = MultiLanguageString({
                          Constant.textEnUsLanguageKey: "Not Yet Sent",
                          Constant.textInIdLanguageKey: "Belum Dikirim"
                        }).toString();
                        chipColor = Constant.colorRedDanger;
                        chipTextColor = Colors.white;
                      } else if (order.combinedOrder.status.toLowerCase() == "sedang dikirim") {
                        chipText = MultiLanguageString({
                          Constant.textEnUsLanguageKey: "Is Sending",
                          Constant.textInIdLanguageKey: "Sedang Dikirim"
                        }).toString();
                        chipColor = Constant.colorYellow;
                      } else {
                        chipText = "Finish".tr;
                        chipColor = Constant.colorSuccessLightGreen;
                      }
                      return ColorfulChip(
                        text: chipText,
                        textStyle: TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold,
                          color: chipTextColor
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
                        color: chipColor
                      );
                    }
                  )
                ],
              );
            }
          )
        );
        listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
          i, ListItemControllerStateWrapper(productPaymentListItemControllerState), oldItemTypeList, newListItemControllerState
        );
      }
    }
    ListItemControllerState orderConclusionItemListItemControllerState = PaddingContainerListItemControllerState(
      padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
      paddingChildListItemControllerState: WidgetSubstitutionListItemControllerState(
        widgetSubstitution: (BuildContext context, int index) => OrderConclusionItem(
          order: order.combinedOrder,
          inOrderDetail: true,
          onBuyAgainTap: orderDetailContainerListItemControllerState.onBuyAgainTap,
        )
      )
    );
    listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
      i, ListItemControllerStateWrapper(orderConclusionItemListItemControllerState), oldItemTypeList, newListItemControllerState
    );
    newListItemControllerState.add(
      VirtualSpacingListItemControllerState(height: padding())
    );
  }

  void _interceptForAddressInformation(
    int i,
    OrderDetailContainerListItemControllerState orderDetailContainerListItemControllerState,
    List<ListItemControllerState> oldItemTypeList,
    List<ListItemControllerState> newListItemControllerState
  ) {
    Order order = orderDetailContainerListItemControllerState.order;
    newListItemControllerState.add(
      VirtualSpacingListItemControllerState(height: padding())
    );
    ListItemControllerState paymentTypeListItemControllerState = TitleAndDescriptionListItemControllerState(
      title: "Address".tr,
      description: order.combinedOrder.orderProduct.userAddress?.address,
      titleAndDescriptionItemInterceptor: (padding, title, titleWidget, description, descriptionWidget, titleAndDescriptionWidget, titleAndDescriptionWidgetList) {
        Address? userAddress = order.combinedOrder.orderProduct.userAddress;
        if (userAddress != null) {
          titleAndDescriptionWidgetList[titleAndDescriptionWidgetList.length - 2] = const SizedBox(height: 5);
        }
        titleAndDescriptionWidgetList[titleAndDescriptionWidgetList.length - 1] = userAddress != null ? SizedBox(
          width: double.infinity,
          child: VerticalAddressItem(
            address: userAddress,
            canBeModified: false,
          ),
        ) : Text("No address".tr);
        return titleAndDescriptionWidget;
      },
      padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
      verticalSpace: 5
    );
    listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
      i, ListItemControllerStateWrapper(paymentTypeListItemControllerState), oldItemTypeList, newListItemControllerState
    );
    newListItemControllerState.add(
      VirtualSpacingListItemControllerState(height: padding())
    );
  }

  void _interceptForTransactionOrderInformation(
    int i,
    OrderDetailContainerListItemControllerState orderDetailContainerListItemControllerState,
    List<ListItemControllerState> oldItemTypeList,
    List<ListItemControllerState> newListItemControllerState
  ) {
    CombinedOrder order = orderDetailContainerListItemControllerState.order.combinedOrder;
    List<OrderProductDetail> orderProductDetailList = order.orderProduct.orderProductDetailList;
    newListItemControllerState.add(
      VirtualSpacingListItemControllerState(height: padding())
    );
    ListItemControllerState paymentTypeListItemControllerState = TitleAndDescriptionListItemControllerState(
      title: "Order List".tr,
      padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem)
    );
    listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
      i, ListItemControllerStateWrapper(paymentTypeListItemControllerState), oldItemTypeList, newListItemControllerState
    );
    newListItemControllerState.add(
      VirtualSpacingListItemControllerState(height: padding())
    );

    ListItemControllerState orderListItemControllerState = PaddingContainerListItemControllerState(
      padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
      paddingChildListItemControllerState: BuilderListItemControllerState(
        buildListItemControllerState: () {
          if (orderProductDetailList.isEmpty) {
            return WidgetSubstitutionListItemControllerState(
              widgetSubstitution: (context, index) => Text(
                MultiLanguageString({
                  Constant.textEnUsLanguageKey: "No product.",
                  Constant.textInIdLanguageKey: "Tidak ada produk.",
                }).toEmptyStringNonNull
              )
            );
          }
          return CompoundListItemControllerState(
            listItemControllerState: orderProductDetailList.mapIndexed<ListItemControllerState>(
              (index, orderProductDetail) => CompoundListItemControllerState(
                listItemControllerState: [
                  if (index > 0) VirtualSpacingListItemControllerState(height: 10),
                  WidgetSubstitutionListItemControllerState(
                    widgetSubstitution: (context, index) => OrderProductDetailItem(
                      orderProductDetail: orderProductDetail
                    )
                  )
                ]
              )
            ).toList()
          );
        }
      )
    );
    listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
      i, ListItemControllerStateWrapper(orderListItemControllerState), oldItemTypeList, newListItemControllerState
    );
    newListItemControllerState.add(
      VirtualSpacingListItemControllerState(height: padding())
    );
  }

  void _interceptForProductInventoryInformation(
    int i,
    OrderDetailContainerListItemControllerState orderDetailContainerListItemControllerState,
    List<ListItemControllerState> oldItemTypeList,
    List<ListItemControllerState> newListItemControllerState
  ) {
    CombinedOrder order = orderDetailContainerListItemControllerState.order.combinedOrder;
    List<OrderProductInventory> orderProductInventoryList = order.orderProduct.otherProductInventoryList;
    newListItemControllerState.add(
      VirtualSpacingListItemControllerState(height: padding())
    );
    ListItemControllerState paymentTypeListItemControllerState = TitleAndDescriptionListItemControllerState(
      title: "Product Inventory".tr,
      padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem)
    );
    listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
      i, ListItemControllerStateWrapper(paymentTypeListItemControllerState), oldItemTypeList, newListItemControllerState
    );
    newListItemControllerState.add(
      VirtualSpacingListItemControllerState(height: padding())
    );

    ListItemControllerState orderListItemControllerState = PaddingContainerListItemControllerState(
      padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
      paddingChildListItemControllerState: BuilderListItemControllerState(
        buildListItemControllerState: () {
          if (orderProductInventoryList.isEmpty) {
            return WidgetSubstitutionListItemControllerState(
              widgetSubstitution: (context, index) => Text(
                MultiLanguageString({
                  Constant.textEnUsLanguageKey: "No product inventory.",
                  Constant.textInIdLanguageKey: "Tidak ada inventori produk.",
                }).toEmptyStringNonNull
              )
            );
          }
          return CompoundListItemControllerState(
            listItemControllerState: orderProductInventoryList.mapIndexed<ListItemControllerState>(
              (index, orderProductInventory) => CompoundListItemControllerState(
                listItemControllerState: [
                  if (index > 0) VirtualSpacingListItemControllerState(height: 10),
                  WidgetSubstitutionListItemControllerState(
                    widgetSubstitution: (context, index) => OrderProductInventoryItem(
                      orderProductInventory: orderProductInventory
                    )
                  )
                ]
              )
            ).toList()
          );
        }
      )
    );
    listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
      i, ListItemControllerStateWrapper(orderListItemControllerState), oldItemTypeList, newListItemControllerState
    );
    newListItemControllerState.add(
      VirtualSpacingListItemControllerState(height: padding())
    );
  }

  void _interceptForOrderSendToWarehouseInformation(
    int i,
    OrderDetailContainerListItemControllerState orderDetailContainerListItemControllerState,
    List<ListItemControllerState> oldItemTypeList,
    List<ListItemControllerState> newListItemControllerState
  ) {
    CombinedOrder order = orderDetailContainerListItemControllerState.order.combinedOrder;
    List<AdditionalItem> additionalItemList = order.orderProduct.additionalItemList;
    newListItemControllerState.add(
      VirtualSpacingListItemControllerState(height: padding())
    );
    ListItemControllerState paymentTypeListItemControllerState = TitleAndDescriptionListItemControllerState(
      title: "Order Send to Warehouse List".tr,
      titleInterceptor: (text, textStyle) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              text,
              style: textStyle
            ),
          ),
          TapArea(
            onTap: () => orderDetailContainerListItemControllerState.onModifyWarehouseInOrder(
              AddWarehouseInOrderParameter(
                orderProductId: order.orderProductId,
                allRequiredFieldsWarehouseInOrderItemList: []
              )
            ),
            child: Text(
              "Add Item".tr,
              style: TextStyle(
                color: Constant.colorMain,
                fontWeight: FontWeight.bold
              )
            ),
          )
        ]
      ),
      padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem)
    );
    listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
      i, ListItemControllerStateWrapper(paymentTypeListItemControllerState), oldItemTypeList, newListItemControllerState
    );
    newListItemControllerState.add(
      VirtualSpacingListItemControllerState(height: padding())
    );

    ListItemControllerState orderListItemControllerState = PaddingContainerListItemControllerState(
      padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
      paddingChildListItemControllerState: BuilderListItemControllerState(
        buildListItemControllerState: () {
          if (additionalItemList.isEmpty) {
            return WidgetSubstitutionListItemControllerState(
              widgetSubstitution: (context, index) => Text(
                MultiLanguageString({
                  Constant.textEnUsLanguageKey: "No order send to warehouse list.",
                  Constant.textInIdLanguageKey: "Tidak ada daftar kirim barang ke warehouse.",
                }).toEmptyStringNonNull
              )
            );
          }
          return CompoundListItemControllerState(
            listItemControllerState: [
              ...additionalItemList.mapIndexed<ListItemControllerState>(
                (index, additionalItem) => CompoundListItemControllerState(
                  listItemControllerState: [
                    if (index > 0) VirtualSpacingListItemControllerState(height: 10),
                    AdditionalItemListItemControllerState(
                      additionalItem: additionalItem,
                      no: index + 1,
                      onEditAdditionalItem: (additionalItem) => orderDetailContainerListItemControllerState.onModifyWarehouseInOrder(
                        ChangeWarehouseInOrderParameter(
                          orderProductId: order.orderProductId,
                          id: additionalItem.id,
                          optionalFieldsWarehouseInOrderItem: OptionalFieldsWarehouseInOrderItem(
                            name: additionalItem.name,
                            weight: additionalItem.estimationWeight,
                            price: additionalItem.estimationPrice.toInt(),
                            quantity: additionalItem.quantity,
                            notes: additionalItem.notes
                          )
                        )
                      ),
                      onRemoveAdditionalItem: (additionalItem) => orderDetailContainerListItemControllerState.onModifyWarehouseInOrder(
                        RemoveWarehouseInOrderParameter(
                          warehouseInOrderItemId: additionalItem.id
                        )
                      ),
                      onLoadAdditionalItem: () {},
                      showEditAndRemoveIcon: true
                    )
                  ]
                )
              ).toList(),
              VirtualSpacingListItemControllerState(
                height: padding() - 8
              ),
              DividerListItemControllerState(
                lineColor: Colors.black
              ),
              VirtualSpacingListItemControllerState(
                height: padding() - 8
              ),
              AdditionalItemSummaryListItemControllerState(
                additionalItemList: additionalItemList
              )
            ]
          );
        }
      )
    );
    listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
      i, ListItemControllerStateWrapper(orderListItemControllerState), oldItemTypeList, newListItemControllerState
    );
    newListItemControllerState.add(
      VirtualSpacingListItemControllerState(height: additionalItemList.isNotEmpty ? padding() - 8 : padding())
    );
  }

  void _interceptForOtherProductInformation(
    int i,
    OrderDetailContainerListItemControllerState orderDetailContainerListItemControllerState,
    List<ListItemControllerState> oldItemTypeList,
    List<ListItemControllerState> newListItemControllerState
  ) {
    CombinedOrder order = orderDetailContainerListItemControllerState.order.combinedOrder;
    List<AdditionalItem> additionalItemList = order.orderPurchasingList.where(
      (orderPurchasing) => orderPurchasing.productEntryId == null && orderPurchasing.bundlingId == null
    ).map<AdditionalItem>(
      (orderPurchasing) => orderPurchasing.toAdditionalItem()
    ).toList();
    newListItemControllerState.add(
      VirtualSpacingListItemControllerState(height: padding())
    );
    ListItemControllerState paymentTypeListItemControllerState = TitleAndDescriptionListItemControllerState(
      title: "Other Order Product List".tr,
      padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem)
    );
    listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
      i, ListItemControllerStateWrapper(paymentTypeListItemControllerState), oldItemTypeList, newListItemControllerState
    );
    newListItemControllerState.add(
      VirtualSpacingListItemControllerState(height: padding())
    );

    ListItemControllerState orderListItemControllerState = PaddingContainerListItemControllerState(
      padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
      paddingChildListItemControllerState: BuilderListItemControllerState(
        buildListItemControllerState: () {
          if (additionalItemList.isEmpty) {
            return WidgetSubstitutionListItemControllerState(
              widgetSubstitution: (context, index) => Text(
                MultiLanguageString({
                  Constant.textEnUsLanguageKey: "No other order product list.",
                  Constant.textInIdLanguageKey: "Tidak ada daftar product lainnya.",
                }).toEmptyStringNonNull
              )
            );
          }
          return CompoundListItemControllerState(
            listItemControllerState: [
              ...additionalItemList.mapIndexed<ListItemControllerState>(
                (index, additionalItem) => CompoundListItemControllerState(
                  listItemControllerState: [
                    if (index > 0) VirtualSpacingListItemControllerState(height: 10),
                    AdditionalItemListItemControllerState(
                      additionalItem: additionalItem,
                      no: index + 1,
                      onLoadAdditionalItem: () {},
                      showEditAndRemoveIcon: false
                    )
                  ]
                )
              ).toList(),
            ]
          );
        }
      )
    );
    listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
      i, ListItemControllerStateWrapper(orderListItemControllerState), oldItemTypeList, newListItemControllerState
    );
    newListItemControllerState.add(
      VirtualSpacingListItemControllerState(height: additionalItemList.isNotEmpty ? padding() - 8 : padding())
    );
  }

  void _interceptForTransactionOrderSummaryInformation(
    int i,
    OrderDetailContainerListItemControllerState orderDetailContainerListItemControllerState,
    List<ListItemControllerState> oldItemTypeList,
    List<ListItemControllerState> newListItemControllerState
  ) {
    Order order = orderDetailContainerListItemControllerState.order;
    newListItemControllerState.add(
      VirtualSpacingListItemControllerState(height: padding())
    );
    ListItemControllerState paymentTypeListItemControllerState = TitleAndDescriptionListItemControllerState(
      title: "Order Summary".tr,
      padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem)
    );
    listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
      i, ListItemControllerStateWrapper(paymentTypeListItemControllerState), oldItemTypeList, newListItemControllerState
    );
    newListItemControllerState.add(
      VirtualSpacingListItemControllerState(height: padding())
    );
    ListItemControllerState orderSummaryDetailTypeListItemControllerState = PaddingContainerListItemControllerState(
      padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
      paddingChildListItemControllerState: WidgetSubstitutionListItemControllerState(
        widgetSubstitution: (BuildContext context, int index) => SummaryWidget(baseSummary: order.orderSummary)
      )
    );
    listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
      i, ListItemControllerStateWrapper(orderSummaryDetailTypeListItemControllerState), oldItemTypeList, newListItemControllerState
    );
    newListItemControllerState.add(
      VirtualSpacingListItemControllerState(height: padding())
    );
  }

  void _interceptForTransactionOrderInvoiceInformation(
    int i,
    OrderDetailContainerListItemControllerState orderDetailContainerListItemControllerState,
    List<ListItemControllerState> oldItemTypeList,
    List<ListItemControllerState> newListItemControllerState
  ) {
    Order order = orderDetailContainerListItemControllerState.order;
    newListItemControllerState.add(
      VirtualSpacingListItemControllerState(height: padding())
    );
    ListItemControllerState paymentTypeListItemControllerState = TitleAndDescriptionListItemControllerState(
      title: "Order Invoice".tr,
      padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem)
    );
    listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
      i, ListItemControllerStateWrapper(paymentTypeListItemControllerState), oldItemTypeList, newListItemControllerState
    );
    newListItemControllerState.add(
      VirtualSpacingListItemControllerState(height: padding())
    );
    ListItemControllerState orderInvoiceDescriptionListItemControllerState = PaddingContainerListItemControllerState(
      padding: EdgeInsets.symmetric(horizontal: padding()),
      paddingChildListItemControllerState: WidgetSubstitutionListItemControllerState(
        widgetSubstitution: (context, index) => Text(
          MultiLanguageString({
            Constant.textEnUsLanguageKey: "Order invoice is generated. Tap button below for open order invoice.",
            Constant.textInIdLanguageKey: "Invoice Pemesanan sudah dibuat. Tap tombol dibawah untuk membuka invoice pemesanan.",
          }).toEmptyStringNonNull
        )
      )
    );
    listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
      i, ListItemControllerStateWrapper(orderInvoiceDescriptionListItemControllerState), oldItemTypeList, newListItemControllerState
    );
    newListItemControllerState.add(
      VirtualSpacingListItemControllerState(height: padding())
    );
    ListItemControllerState orderInvoiceDetailTypeListItemControllerState = PaddingContainerListItemControllerState(
      padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
      paddingChildListItemControllerState: WidgetSubstitutionListItemControllerState(
        widgetSubstitution: (BuildContext context, int index) => Row(
          children: [
            Expanded(
              child: SizedOutlineGradientButton(
                onPressed: () {
                  WebHelper.launchUrl(
                    Uri.parse("${DioHttpClient.of().options.baseUrl}/user/order/generate/invoice/${order.combinedOrder.id}")
                  );
                },
                text: "Open".tr,
                customPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                outlineGradientButtonType: OutlineGradientButtonType.solid,
                outlineGradientButtonVariation: OutlineGradientButtonVariation.variation2,
              ),
            ),
          ],
        )
      )
    );
    listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
      i, ListItemControllerStateWrapper(orderInvoiceDetailTypeListItemControllerState), oldItemTypeList, newListItemControllerState
    );
    newListItemControllerState.add(
      VirtualSpacingListItemControllerState(height: padding())
    );
  }
}