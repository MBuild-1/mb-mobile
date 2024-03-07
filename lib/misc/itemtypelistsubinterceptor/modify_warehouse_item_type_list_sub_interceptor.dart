import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../presentation/widget/button/custombutton/sized_outline_gradient_button.dart';
import '../constant.dart';
import '../controllerstate/listitemcontrollerstate/additionalitemlistitemcontrollerstate/additional_item_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/additionalitemlistitemcontrollerstate/additional_item_summary_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/builder_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/compound_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/divider_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/modifywarehouselistitemcontrollerstate/modify_warehouse_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/widget_substitution_list_item_controller_state.dart';
import '../dialog_helper.dart';
import '../itemtypelistinterceptor/itemtypelistinterceptorchecker/list_item_controller_state_item_type_list_interceptor_checker.dart';
import '../multi_language_string.dart';
import '../page_restoration_helper.dart';
import '../typedef.dart';
import 'item_type_list_sub_interceptor.dart';

class ModifyWarehouseItemTypeListSubInterceptor extends ItemTypeListSubInterceptor<ListItemControllerState> {
  final DoubleReturned padding;
  final DoubleReturned itemSpacing;
  final ListItemControllerStateItemTypeInterceptorChecker listItemControllerStateItemTypeInterceptorChecker;

  ModifyWarehouseItemTypeListSubInterceptor({
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
    if (oldItemType is ModifyWarehouseContainerListItemControllerState) {
      listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
        i,
        ListItemControllerStateWrapper(
          PaddingContainerListItemControllerState(
            padding: EdgeInsets.symmetric(horizontal: padding()),
            paddingChildListItemControllerState: BuilderListItemControllerState(
              buildListItemControllerState: () {
                if (oldItemType.additionalItemList.isEmpty) {
                  return WidgetSubstitutionListItemControllerState(
                    widgetSubstitution: (context, index) => Column(
                      children: [
                        SizedBox(height: padding()),
                        Text(
                          MultiLanguageString({
                            Constant.textEnUsLanguageKey: "No order send to personal stuffs list.",
                            Constant.textInIdLanguageKey: "Tidak ada daftar kirim barang ke barang pribadi.",
                          }).toEmptyStringNonNull
                        ),
                        const SizedBox(height: 12.0),
                        SizedOutlineGradientButton(
                          onPressed: oldItemType.onGotoAddWarehouse,
                          text: "Add".tr,
                          outlineGradientButtonType: OutlineGradientButtonType.outline,
                          outlineGradientButtonVariation: OutlineGradientButtonVariation.variation1,
                        ),
                        SizedBox(height: padding())
                      ],
                    )
                  );
                }
                return CompoundListItemControllerState(
                  listItemControllerState: [
                    VirtualSpacingListItemControllerState(height: padding()),
                    WidgetSubstitutionListItemControllerState(
                      widgetSubstitution: (context, index) => Row(
                        children: [
                          Expanded(
                            child: SizedOutlineGradientButton(
                              onPressed: oldItemType.onGotoAddWarehouse,
                              text: "Add".tr,
                              outlineGradientButtonType: OutlineGradientButtonType.solid,
                              outlineGradientButtonVariation: OutlineGradientButtonVariation.variation1,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SizedOutlineGradientButton(
                              onPressed: () => oldItemType.onSubmitModifyWarehouse(oldItemType.additionalItemList),
                              text: "Submit".tr,
                              outlineGradientButtonType: OutlineGradientButtonType.solid,
                              outlineGradientButtonVariation: OutlineGradientButtonVariation.variation2,
                            ),
                          )
                        ],
                      )
                    ),
                    VirtualSpacingListItemControllerState(height: padding()),
                    ...oldItemType.additionalItemList.mapIndexed<ListItemControllerState>(
                      (index, additionalItem) => CompoundListItemControllerState(
                        listItemControllerState: [
                          if (index > 0) VirtualSpacingListItemControllerState(height: 14),
                          AdditionalItemListItemControllerState(
                            additionalItem: additionalItem,
                            no: index + 1,
                            onEditAdditionalItem: oldItemType.onGotoEditWarehouse,
                            onRemoveAdditionalItem: oldItemType.onRemoveWarehouse,
                            onLoadAdditionalItem: () {},
                            showEditAndRemoveIcon: true
                          )
                        ]
                      )
                    ).toList(),
                    VirtualSpacingListItemControllerState(
                      height: padding()
                    ),
                    DividerListItemControllerState(
                      lineColor: Colors.black
                    ),
                    VirtualSpacingListItemControllerState(
                      height: padding() - 8
                    ),
                    AdditionalItemSummaryListItemControllerState(
                      additionalItemList: oldItemType.additionalItemList
                    ),
                    VirtualSpacingListItemControllerState(height: padding() - 10),
                  ]
                );
              }
            )
          )
        ),
        oldItemTypeList,
        newItemTypeList,
      );
      return true;
    }
    return false;
  }
}