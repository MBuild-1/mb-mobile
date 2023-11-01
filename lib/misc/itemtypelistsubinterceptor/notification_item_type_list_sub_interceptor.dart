import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:provider/provider.dart';

import '../../presentation/notifier/notification_notifier.dart';
import '../../presentation/widget/colorful_chip_tab_bar.dart';
import '../../presentation/widget/tap_area.dart';
import '../controllerstate/listitemcontrollerstate/colorful_chip_tab_bar_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/compound_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/divider_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/load_data_result_dynamic_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/notificationlistitemcontrollerstate/notification_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/notificationlistitemcontrollerstate/notification_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/notificationlistitemcontrollerstate/purchase_section_notification_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/widget_substitution_list_item_controller_state.dart';
import '../itemtypelistinterceptor/itemtypelistinterceptorchecker/list_item_controller_state_item_type_list_interceptor_checker.dart';
import '../load_data_result.dart';
import '../notification_helper.dart';
import '../typedef.dart';
import 'item_type_list_sub_interceptor.dart';

class NotificationItemTypeListSubInterceptor extends ItemTypeListSubInterceptor<ListItemControllerState> {
  final DoubleReturned padding;
  final DoubleReturned itemSpacing;
  final ListItemControllerStateItemTypeInterceptorChecker listItemControllerStateItemTypeInterceptorChecker;

  NotificationItemTypeListSubInterceptor({
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
    if (oldItemType is NotificationContainerListItemControllerState) {
      List<NotificationListItemControllerState> notificationListItemControllerStateList = oldItemType.notificationList.map<NotificationListItemControllerState>(
        (shortNotification) => NotificationListItemControllerState(shortNotification: shortNotification)
      ).toList();
      List<ListItemControllerState> newListItemControllerState = [];
      newListItemControllerState.add(
        LoadDataResultDirectlyDynamicListItemControllerState<int>(
          loadDataResult: oldItemType.purchaseStatusLoadDataResult(),
          errorProvider: oldItemType.onGetErrorProvider(),
          onImplementLoadDataResultDirectlyListItemControllerState: (loadDataResult, errorProvider) {
            return PaddingContainerListItemControllerState(
              padding: EdgeInsets.symmetric(horizontal: padding()),
              paddingChildListItemControllerState: PurchaseSectionNotificationListItemControllerState(
                step: loadDataResult.isSuccess ? loadDataResult.resultIfSuccess! : 0,
                isLoadingStep: loadDataResult.isLoading
              )
            );
          }
        )
      );
      newListItemControllerState.add(
        VirtualSpacingListItemControllerState(height: padding())
      );
      newListItemControllerState.add(
        WidgetSubstitutionWithInjectionListItemControllerState(
          onInjectListItemControllerState: () => [
            ColorfulChipTabBarListItemControllerState(
              colorfulChipTabBarController: oldItemType.notificationTabColorfulChipTabBarController,
              colorfulChipTabBarDataList: oldItemType.notificationColorfulChipTabBarDataList,
              isWrap: false
            )
          ],
          widgetSubstitutionWithInjection: (context, index, injectedWidget) {
            Iterable<Widget> injectedWidgetFilteredCount = injectedWidget.whereType<ColorfulChipTabBar>();
            if (injectedWidgetFilteredCount.isNotEmpty) {
              ColorfulChipTabBar colorfulChipTabBar = injectedWidgetFilteredCount.first as ColorfulChipTabBar;
              List<ColorfulChipTabBarData> colorfulChipTabBarDataList = colorfulChipTabBar.colorfulChipTabBarDataList;
              colorfulChipTabBarDataList.clear();
              colorfulChipTabBarDataList.addAll(
                NotificationHelper.colorfulChipTabBarDataList.map<ColorfulChipTabBarData>(
                  (colorfulChipTabBarData) {
                    dynamic data = colorfulChipTabBarData.data;
                    String newData = colorfulChipTabBarData.title.toStringNonNull;
                    if (data == "transaction") {
                      LoadDataResult<int> transactionNotificationLoadDataResult = oldItemType.transactionNotificationLoadDataResult();
                      if (transactionNotificationLoadDataResult.isSuccess) {
                        newData += " (${transactionNotificationLoadDataResult.resultIfSuccess})";
                      }
                    } else if (data == "info") {
                      LoadDataResult<int> infoNotificationLoadDataResult = oldItemType.infoNotificationLoadDataResult();
                      if (infoNotificationLoadDataResult.isSuccess) {
                        newData += " (${infoNotificationLoadDataResult.resultIfSuccess})";
                      }
                    } else if (data == "promo") {
                      LoadDataResult<int> promoNotificationLoadDataResult = oldItemType.promoNotificationLoadDataResult();
                      if (promoNotificationLoadDataResult.isSuccess) {
                        newData += " (${promoNotificationLoadDataResult.resultIfSuccess})";
                      }
                    }
                    colorfulChipTabBarData.title = newData;
                    return colorfulChipTabBarData;
                  }
                )
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: injectedWidget,
            );
          }
        )
      );
      newListItemControllerState.add(
        VirtualSpacingListItemControllerState(height: padding())
      );
      newListItemControllerState.add(
        PaddingContainerListItemControllerState(
          padding: EdgeInsets.symmetric(horizontal: padding()),
          paddingChildListItemControllerState: WidgetSubstitutionListItemControllerState(
            widgetSubstitution: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TapArea(
                    onTap: oldItemType.onMarkAllNotification,
                    child: Text(
                      "Mark All".tr,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary
                      )
                    ),
                  ),
                ],
              );
            }
          )
        )
      );
      newListItemControllerState.add(
        VirtualSpacingListItemControllerState(height: padding())
      );
      int j = 0;
      while (j < notificationListItemControllerStateList.length) {
        ListItemControllerState listItemControllerState = CompoundListItemControllerState(
          listItemControllerState: [
            if (j > 0) ...[
              VirtualSpacingListItemControllerState(height: padding()),
            ],
            PaddingContainerListItemControllerState(
              padding: EdgeInsets.symmetric(horizontal: padding()),
              paddingChildListItemControllerState: notificationListItemControllerStateList[j],
            ),
            if (j == notificationListItemControllerStateList.length - 1) VirtualSpacingListItemControllerState(height: padding())
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