import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../domain/entity/additionalitem/additional_item.dart';
import '../../../presentation/widget/check_list_item.dart';
import '../../../presentation/widget/tap_area.dart';
import '../../controllerstate/listitemcontrollerstate/additionalitemlistitemcontrollerstate/additional_item_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/cartlistitemcontrollerstate/cart_header_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/cartlistitemcontrollerstate/separatedcartcontainerlistitemcontrollerstate/warehouse_separated_container_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/compound_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/divider_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/spacing_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/widget_substitution_list_item_controller_state.dart';
import 'separated_cart_item_type_list_sub_interceptor.dart';

class WarehouseSeparatedCartItemTypeListSubInterceptor extends SeparatedCartItemTypeListSubInterceptor {
  WarehouseSeparatedCartItemTypeListSubInterceptor({
    required super.padding,
    required super.itemSpacing,
    required super.listItemControllerStateItemTypeInterceptorChecker
  });

  @override
  bool intercept(
    int i,
    ListItemControllerStateWrapper oldItemTypeWrapper,
    List<ListItemControllerState> oldItemTypeList,
    List<ListItemControllerState> newItemTypeList
  ) {
    ListItemControllerState oldItemType = oldItemTypeWrapper.listItemControllerState;
    if (oldItemType is WarehouseSeparatedCartContainerListItemControllerState) {
      List<ListItemControllerState> newAdditionalItemListControllerStateList = [];
      CartHeaderListItemControllerState cartHeaderListItemControllerState = CartHeaderListItemControllerState(
        isSelected: false,
        onChangeSelected: () {
          int k = 0;
          int selectedCount = 0;
          while (k < oldItemType.warehouseAdditionalItemStateValueList.length) {
            WarehouseAdditionalItemStateValue warehouseAdditionalItemStateValue = oldItemType.warehouseAdditionalItemStateValueList[k];
            if (warehouseAdditionalItemStateValue.isSelected) {
              selectedCount += 1;
            }
            k++;
          }
          if (selectedCount == oldItemType.warehouseAdditionalItemStateValueList.length) {
            for (var warehouseAdditionalItemStateValue in oldItemType.warehouseAdditionalItemStateValueList) {
              warehouseAdditionalItemStateValue.isSelected = false;
            }
          } else {
            for (var warehouseAdditionalItemStateValue in oldItemType.warehouseAdditionalItemStateValueList) {
              warehouseAdditionalItemStateValue.isSelected = true;
            }
          }
          oldItemType.onUpdateState();
        }
      );
      listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
        i,
        ListItemControllerStateWrapper(
          CompoundListItemControllerState(
            listItemControllerState: [
              cartHeaderListItemControllerState,
              SpacingListItemControllerState()
            ]
          )
        ),
        oldItemTypeList,
        newAdditionalItemListControllerStateList
      );
      int selectedCount = 0;
      List<AdditionalItem> selectedWarehouseAdditionalItem = [];
      int k = 0;
      while (k < oldItemType.warehouseAdditionalItemStateValueList.length) {
        WarehouseAdditionalItemStateValue warehouseAdditionalItemStateValue = oldItemType.warehouseAdditionalItemStateValueList[k];
        if (warehouseAdditionalItemStateValue.isSelected) {
          selectedCount += 1;
          selectedWarehouseAdditionalItem.add(warehouseAdditionalItemStateValue.additionalItem);
        }
        ListItemControllerState newAdditionalItemListControllerState = CompoundListItemControllerState(
          listItemControllerState: [
            if (k > 0) ...[
              PaddingContainerListItemControllerState(
                padding: EdgeInsets.symmetric(horizontal: padding()),
                paddingChildListItemControllerState: DividerListItemControllerState()
              )
            ],
            WidgetSubstitutionWithInjectionListItemControllerState(
              widgetSubstitutionWithInjection: (context, index, widgetList) {
                return CheckListItem(
                  value: warehouseAdditionalItemStateValue.isSelected,
                  showCheck: true,
                  checkListItemVerticalAlignment: CheckListItemVerticalAlignment.top,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widgetList
                  ),
                  onChanged: (value) {
                    if (value != null) {
                      warehouseAdditionalItemStateValue.isSelected = value;
                      oldItemType.onUpdateState();
                    }
                  },
                  reverse: true,
                  spaceBetweenCheckListAndTitle: 4.w,
                  spaceBetweenTitleAndContent: 4.w,
                );
              },
              onInjectListItemControllerState: () => [
                AdditionalItemListItemControllerState(
                  additionalItem: warehouseAdditionalItemStateValue.additionalItem,
                  no: k + 1,
                  onRemoveAdditionalItem: oldItemType.onRemoveWarehouseAdditionalItem,
                  onLoadAdditionalItem: oldItemType.onLoadWarehouseAdditionalItem
                )
              ]
            ),
          ]
        );
        listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
          i, ListItemControllerStateWrapper(newAdditionalItemListControllerState), oldItemTypeList, newAdditionalItemListControllerStateList
        );
        k++;
      }
      if (selectedCount == oldItemType.warehouseAdditionalItemStateValueList.length) {
        cartHeaderListItemControllerState.isSelected = true;
      } else {
        cartHeaderListItemControllerState.isSelected = false;
      }
      WarehouseSeparatedCartContainerStateStorageListItemControllerState warehouseSeparatedCartContainerStateStorageListItemControllerState = oldItemType.warehouseSeparatedCartContainerStateStorageListItemControllerState;
      WarehouseSeparatedCartContainerInterceptingActionListItemControllerState warehouseSeparatedCartContainerInterceptingActionListItemControllerState = oldItemType.warehouseSeparatedCartContainerInterceptingActionListItemControllerState;
      if (warehouseSeparatedCartContainerStateStorageListItemControllerState is DefaultWarehouseSeparatedCartContainerStateStorageListItemControllerState) {
        if (selectedCount != warehouseSeparatedCartContainerStateStorageListItemControllerState._lastSelectedCount) {
          warehouseSeparatedCartContainerStateStorageListItemControllerState._lastSelectedCount = selectedCount;
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            oldItemType.onChangeSelected(selectedWarehouseAdditionalItem);
          });
        }
        if (oldItemType.warehouseAdditionalItemStateValueList.length != warehouseSeparatedCartContainerStateStorageListItemControllerState._lastWarehouseAdditionalItemCount) {
          warehouseSeparatedCartContainerStateStorageListItemControllerState._lastWarehouseAdditionalItemCount = oldItemType.warehouseAdditionalItemStateValueList.length;
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            oldItemType.onWarehouseAdditionalItemChange();
          });
        }
      }
      if (warehouseSeparatedCartContainerInterceptingActionListItemControllerState is DefaultWarehouseSeparatedCartContainerInterceptingActionListItemControllerState) {
        warehouseSeparatedCartContainerInterceptingActionListItemControllerState._getWarehouseAdditionalItemCount = () => oldItemTypeList.length;
      }
      newItemTypeList.addAll(newAdditionalItemListControllerStateList);
      return true;
    }
    return false;
  }
}

class DefaultWarehouseSeparatedCartContainerStateStorageListItemControllerState extends WarehouseSeparatedCartContainerStateStorageListItemControllerState {
  int _lastSelectedCount = -1;
  int _lastWarehouseAdditionalItemCount = -1;
}

class DefaultWarehouseSeparatedCartContainerInterceptingActionListItemControllerState extends WarehouseSeparatedCartContainerInterceptingActionListItemControllerState {
  int Function()? _getWarehouseAdditionalItemCount;

  @override
  int Function()? get getWarehouseAdditionalItemCount => _getWarehouseAdditionalItemCount ?? (throw UnimplementedError());
}