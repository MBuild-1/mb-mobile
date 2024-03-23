import 'package:flutter/material.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../../domain/entity/order/combined_order.dart';
import '../../presentation/widget/colorful_chip_tab_bar.dart';
import '../constant.dart';
import '../controllerstate/listitemcontrollerstate/colorful_chip_tab_bar_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/compound_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/failed_prompt_indicator_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/orderlistitemcontrollerstate/is_running_order_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/orderlistitemcontrollerstate/order_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/orderlistitemcontrollerstate/vertical_order_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/orderlistitemcontrollerstate/waiting_for_payment_order_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import '../error/message_error.dart';
import '../error_helper.dart';
import '../itemtypelistinterceptor/itemtypelistinterceptorchecker/list_item_controller_state_item_type_list_interceptor_checker.dart';
import '../load_data_result.dart';
import '../multi_language_string.dart';
import '../paging/pagingresult/paging_data_result.dart';
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
      var defaultOrderContainerStateStorageListItemControllerState = oldItemType.orderContainerStateStorageListItemControllerState as DefaultOrderContainerStateStorageListItemControllerState;
      var defaultOrderContainerInterceptingActionListItemControllerState = oldItemType.orderContainerInterceptingActionListItemControllerState as DefaultOrderContainerInterceptingActionListItemControllerState;
      defaultOrderContainerInterceptingActionListItemControllerState._onRefreshCombinedOrderPagingDataResult = (combinedOrderResult) {
        defaultOrderContainerStateStorageListItemControllerState._combinedOrderPagingDataResult = combinedOrderResult;
        oldItemType.onUpdateState();
      };
      defaultOrderContainerInterceptingActionListItemControllerState._onRemoveOrder = (combinedOrderId) {
        oldItemType.orderList.removeWhere((combinedOrder) => combinedOrder.id == combinedOrderId);
        oldItemType.onUpdateState();
      };
      List<VerticalOrderListItemControllerState> verticalOrderListItemControllerStateList = oldItemType.orderList.map<VerticalOrderListItemControllerState>(
        (order) => VerticalOrderListItemControllerState(
          order: order,
          onBuyAgainTap: oldItemType.onBuyAgainTap,
          onConfirmArrived: oldItemType.onConfirmArrived
        )
      ).toList();
      List<ListItemControllerState> newListItemControllerState = [];
      newListItemControllerState.addAll([
        if (oldItemType.shortCartListItemControllerState != null) ...[
          oldItemType.shortCartListItemControllerState!(),
          VirtualSpacingListItemControllerState(
            height: 16
          ),
        ],
        ColorfulChipTabBarListItemControllerState(
          colorfulChipTabBarController: oldItemType.orderTabColorfulChipTabBarController,
          colorfulChipTabBarDataList: oldItemType.orderColorfulChipTabBarDataList,
          isWrap: false
        ),
      ]);
      if (defaultOrderContainerStateStorageListItemControllerState._combinedOrderPagingDataResult.isSuccess) {
        PagingDataResult<CombinedOrder> combinedOrderPagingDataResult = defaultOrderContainerStateStorageListItemControllerState._combinedOrderPagingDataResult.resultIfSuccess!;
        if (combinedOrderPagingDataResult.page == 1 && combinedOrderPagingDataResult.itemList.isEmpty) {
          listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
            i, ListItemControllerStateWrapper(VirtualSpacingListItemControllerState(height: 16)), oldItemTypeList, newListItemControllerState
          );
          listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
            i,
            ListItemControllerStateWrapper(
              FailedPromptIndicatorListItemControllerState(
                errorProvider: oldItemType.errorProvider,
                e: FailedLoadDataResult.throwException(() {
                  throw ErrorHelper.generateMultiLanguageDioError(
                    MultiLanguageMessageError(
                      title: MultiLanguageString({
                        Constant.textEnUsLanguageKey: "Cart Item Is Empty",
                        Constant.textInIdLanguageKey: "Order Kosong",
                      }),
                      message: MultiLanguageString({
                        Constant.textEnUsLanguageKey: "For now, cart Item is empty.",
                        Constant.textInIdLanguageKey: "Untuk sekarang, ordernya kosong.",
                      }),
                    )
                  );
                })!.e,
              )
            ),
            oldItemTypeList,
            newListItemControllerState
          );
          newItemTypeList.addAll(newListItemControllerState);
          return true;
        }
      }
      newListItemControllerState.add(
        VirtualSpacingListItemControllerState(height: padding())
      );
      int j = 0;
      while (j < verticalOrderListItemControllerStateList.length) {
        ListItemControllerState listItemControllerState = CompoundListItemControllerState(
          listItemControllerState: [
            if (j > 0) VirtualSpacingListItemControllerState(height: 12.0),
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

class DefaultOrderContainerStateStorageListItemControllerState extends OrderContainerStateStorageListItemControllerState {
  LoadDataResult<PagingDataResult<CombinedOrder>> _combinedOrderPagingDataResult = NoLoadDataResult<PagingDataResult<CombinedOrder>>();
}

class DefaultOrderContainerInterceptingActionListItemControllerState extends OrderContainerInterceptingActionListItemControllerState {
  void Function(LoadDataResult<PagingDataResult<CombinedOrder>>)? _onRefreshCombinedOrderPagingDataResult;
  void Function(String)? _onRemoveOrder;

  @override
  void Function(LoadDataResult<PagingDataResult<CombinedOrder>>)? get onRefreshCombinedOrderPagingDataResult => _onRefreshCombinedOrderPagingDataResult;

  @override
  void Function(String)? get onRemoveOrder => _onRemoveOrder;
}