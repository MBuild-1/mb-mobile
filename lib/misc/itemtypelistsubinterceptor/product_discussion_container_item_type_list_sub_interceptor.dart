import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:masterbagasi/misc/load_data_result.dart';

import '../../domain/entity/product/productdiscussion/product_discussion_dialog.dart';
import '../../presentation/page/product_detail_page.dart';
import '../../presentation/widget/modified_svg_picture.dart';
import '../../presentation/widget/tap_area.dart';
import '../../presentation/widget/titleanddescriptionitem/title_and_description_item.dart';
import '../constant.dart';
import '../controllerstate/listitemcontrollerstate/builder_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/compound_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/divider_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/no_content_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/non_expanded_item_in_row_child_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/productdiscussionlistitemcontrollerstate/base_product_discussion_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/productdiscussionlistitemcontrollerstate/product_discussion_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/productdiscussionlistitemcontrollerstate/product_discussion_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/productdiscussionlistitemcontrollerstate/productdiscussiondialoglistitemcontrollerstate/vertical_product_discussion_dialog_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/productdiscussionlistitemcontrollerstate/short_product_discussion_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/productdiscussionlistitemcontrollerstate/vertical_product_discussion_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/row_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/spacing_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/title_and_description_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/widget_substitution_list_item_controller_state.dart';
import '../itemtypelistinterceptor/itemtypelistinterceptorchecker/list_item_controller_state_item_type_list_interceptor_checker.dart';
import '../multi_language_string.dart';
import '../page_restoration_helper.dart';
import '../paging/pagingresult/paging_data_result.dart';
import '../typedef.dart';
import 'item_type_list_sub_interceptor.dart';
import 'dart:math' as math;

class ProductDiscussionContainerItemTypeListSubInterceptor extends ItemTypeListSubInterceptor<ListItemControllerState> {
  final DoubleReturned padding;
  final DoubleReturned itemSpacing;
  final ListItemControllerStateItemTypeInterceptorChecker listItemControllerStateItemTypeInterceptorChecker;

  ProductDiscussionContainerItemTypeListSubInterceptor({
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
    if (oldItemType is BaseProductDiscussionContainerListItemControllerState) {
      ProductDiscussionListItemValue productDiscussionListItemValue = oldItemType.productDiscussionListItemValue;
      if (oldItemType is ProductDiscussionContainerListItemControllerState) {
        var productDiscussionContainerInterceptingActionListItemControllerState = oldItemType.productDiscussionContainerInterceptingActionListItemControllerState;
        if (productDiscussionContainerInterceptingActionListItemControllerState is DefaultProductDiscussionContainerInterceptingActionListItemControllerState) {
          productDiscussionContainerInterceptingActionListItemControllerState._onUpdateProductDiscussionListItemValue = (productDiscussionListItemValue) {
            oldItemType.productDiscussionListItemValue = productDiscussionListItemValue;
            oldItemType.onUpdateState();
          };
        }
      }
      VerticalProductDiscussionListItemControllerState verticalProductDiscussionListItemControllerState = VerticalProductDiscussionListItemControllerState(
        productDiscussionDetailListItemValue: productDiscussionListItemValue.productDiscussionDetailListItemValue,
        isExpanded: productDiscussionListItemValue.isExpanded,
        errorProvider: oldItemType.onGetErrorProvider(),
        supportDiscussionLoadDataResult: oldItemType is ProductDiscussionContainerListItemControllerState ? oldItemType.onGetSupportDiscussion() : NoLoadDataResult(),
        onProductDiscussionTap: null
      );
      List<ListItemControllerState> newListItemControllerState = [];
      ProductDiscussionDetailListItemValue productDiscussionDetailListItemValue = verticalProductDiscussionListItemControllerState.productDiscussionDetailListItemValue;
      List<ProductDiscussionDialogListItemValue> productDiscussionDialogListItemValueList = [];
      int moreCount = productDiscussionDetailListItemValue.productDiscussionDialogListItemValueList.length;
      ProductDiscussionDialogListItemValue? mainInReplyProductDiscussionDialogListItemValue;
      if (oldItemType is ProductDiscussionContainerListItemControllerState) {
        String? discussionProductId = oldItemType.onGetDiscussionProductId();
        if (discussionProductId != null) {
          var iterableProductDiscussionDialogListItemValueIterable = productDiscussionDetailListItemValue.productDiscussionDialogListItemValueList.where(
            (value) => value.productDiscussionDialogContainsListItemValue.id == discussionProductId
          );
          if (iterableProductDiscussionDialogListItemValueIterable.isNotEmpty) {
            ProductDiscussionDialogListItemValue selectedProductDiscussionDialogListItemValue = iterableProductDiscussionDialogListItemValueIterable.first;
            mainInReplyProductDiscussionDialogListItemValue = selectedProductDiscussionDialogListItemValue;
            productDiscussionDialogListItemValueList = selectedProductDiscussionDialogListItemValue.replyProductDiscussionDialogListItemValueList;
          }
        } else {
          productDiscussionDialogListItemValueList = productDiscussionDetailListItemValue.productDiscussionDialogListItemValueList;
        }
      } else {
        productDiscussionDialogListItemValueList = productDiscussionDetailListItemValue.productDiscussionDialogListItemValueList.take(3).toList();
      }
      ListItemControllerState listItemControllerState = CompoundListItemControllerState(
        listItemControllerState: [
          if (oldItemType is ShortProductDiscussionContainerListItemControllerState) ...[
            PaddingContainerListItemControllerState(
              padding: EdgeInsets.symmetric(horizontal: padding()),
              paddingChildListItemControllerState: TitleAndDescriptionListItemControllerState(
                title: "Discussion".tr
              ),
            ),
            VirtualSpacingListItemControllerState(height: 10)
          ],
          if (oldItemType is ProductDiscussionContainerListItemControllerState) ...[
            verticalProductDiscussionListItemControllerState,
          ],
          BuilderListItemControllerState(
            buildListItemControllerState: () {
              if (mainInReplyProductDiscussionDialogListItemValue != null) {
                return CompoundListItemControllerState(
                  listItemControllerState: [
                    VerticalProductDiscussionDialogListItemControllerState(
                      productDiscussionDialog: mainInReplyProductDiscussionDialogListItemValue.toProductDiscussionDialog(),
                      isExpanded: true,
                      onTapProductDiscussionDialog: null,
                      isMainProductDiscussion: true,
                      isLoading: mainInReplyProductDiscussionDialogListItemValue.isLoading
                    ),
                    VirtualSpacingListItemControllerState(height: 10),
                    PaddingContainerListItemControllerState(
                      padding: EdgeInsets.symmetric(horizontal: padding()),
                      paddingChildListItemControllerState: CompoundListItemControllerState(
                        listItemControllerState: [
                          DividerListItemControllerState(),
                          VirtualSpacingListItemControllerState(height: 10),
                          WidgetSubstitutionListItemControllerState(
                            widgetSubstitution: (context, index) => Text(
                              "${"Answer".tr} (${productDiscussionDialogListItemValueList.length})",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            )
                          ),
                          VirtualSpacingListItemControllerState(height: 10),
                        ]
                      )
                    ),
                  ]
                );
              } else {
                return NoContentListItemControllerState();
              }
            }
          ),
          if (verticalProductDiscussionListItemControllerState.isExpanded)
            BuilderListItemControllerState(
              buildListItemControllerState: () {
                if (productDiscussionDialogListItemValueList.isEmpty) {
                  return CompoundListItemControllerState(
                    listItemControllerState: [
                      VirtualSpacingListItemControllerState(height: 5),
                      PaddingContainerListItemControllerState(
                        padding: EdgeInsets.symmetric(horizontal: padding()),
                        paddingChildListItemControllerState: WidgetSubstitutionListItemControllerState(
                          widgetSubstitution: (BuildContext context, int index) {
                            return Text(
                              MultiLanguageString({
                                Constant.textEnUsLanguageKey: "For now, there is no discussion this time.",
                                Constant.textInIdLanguageKey: "Untuk sementara, kali ini tidak ada diskusi."
                              }).toString()
                            );
                          }
                        )
                      )
                    ]
                  );
                }
                int k = 0;
                List<CompoundListItemControllerState> productDiscussionDialogListItemControllerState = [];
                while (k < productDiscussionDialogListItemValueList.length) {
                  ProductDiscussionDialogListItemValue productDiscussionDialogListItemValue = productDiscussionDialogListItemValueList[k];
                  ProductDiscussionDialog productDiscussionDialog = productDiscussionDialogListItemValueList[k].toProductDiscussionDialog();
                  productDiscussionDialogListItemControllerState.add(
                    CompoundListItemControllerState(
                      listItemControllerState: [
                        VerticalProductDiscussionDialogListItemControllerState(
                          productDiscussionDialog: productDiscussionDialog,
                          isExpanded: productDiscussionDialogListItemValue.isExpanded,
                          onTapProductDiscussionDialog: null,
                          isMainProductDiscussion: true,
                          isLoading: productDiscussionDialogListItemValue.isLoading
                        ),
                        PaddingContainerListItemControllerState(
                          padding: EdgeInsets.symmetric(horizontal: padding()),
                          paddingChildListItemControllerState: RowContainerListItemControllerState(
                            rowChildListItemControllerState: [
                              NonExpandedItemInRowChildControllerState(
                                childListItemControllerState: WidgetSubstitutionListItemControllerState(
                                  widgetSubstitution: (context, index) {
                                    List<ProductDiscussionDialog> replyProductDiscussionDialogList = productDiscussionDialog.replyProductDiscussionDialogList;
                                    void Function()? onTap;
                                    if (oldItemType is ProductDiscussionContainerListItemControllerState) {
                                      if (oldItemType.onGetDiscussionProductId() != null) {
                                        return Container();
                                      }
                                    }
                                    if (oldItemType.onGotoReplyProductDiscussionPage != null) {
                                      onTap = () => oldItemType.onGotoReplyProductDiscussionPage!(productDiscussionDialog);
                                    }
                                    return TapArea(
                                      onTap: onTap,
                                      child: Row(
                                        children: [
                                          Transform.rotate(
                                            angle: !productDiscussionDialogListItemValue.isExpanded ? math.pi / 2 : -math.pi / 2,
                                            child: ModifiedSvgPicture.asset(
                                              Constant.vectorArrow,
                                              height: 10,
                                            )
                                          ),
                                          const SizedBox(width: 10),
                                          if (replyProductDiscussionDialogList.isNotEmpty) ...[
                                            Text(
                                              "${"Answer".tr} (${replyProductDiscussionDialogList.length})",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold
                                              )
                                            )
                                          ] else ...[
                                            Text(
                                              "No Reply".tr,
                                              style: const TextStyle()
                                            )
                                          ]
                                        ]
                                      ),
                                    );
                                  }
                                ),
                              ),
                            ]
                          )
                        ),
                        VirtualSpacingListItemControllerState(height: 16),
                      ]
                    )
                  );
                  k++;
                }
                return CompoundListItemControllerState(
                  listItemControllerState: productDiscussionDialogListItemControllerState
                );
              }
            ),
          if (oldItemType is ShortProductDiscussionContainerListItemControllerState) ...[
            VirtualSpacingListItemControllerState(height: 10),
            PaddingContainerListItemControllerState(
              padding: EdgeInsets.only(left: padding()),
              paddingChildListItemControllerState: WidgetSubstitutionListItemControllerState(
                widgetSubstitution: (context, index) {
                  void Function()? onTap;
                  if (oldItemType.onTapMore != null) {
                    onTap = () => oldItemType.onTapMore!(
                      oldItemType.productDiscussionListItemValue.productDiscussionDetailListItemValue.toProductDiscussion()
                    );
                  }
                  return TapArea(
                    onTap: onTap,
                    child: Text(
                      "${"More".tr} ($moreCount)",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold
                      )
                    ),
                  );
                }
              ),
            ),
          ],
          if (oldItemType is ProductDiscussionContainerListItemControllerState) ...[
            VirtualSpacingListItemControllerState(height: padding())
          ]
        ]
      );
      listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
        i, ListItemControllerStateWrapper(listItemControllerState), oldItemTypeList, newListItemControllerState
      );
      newItemTypeList.addAll(newListItemControllerState);
      return true;
    }
    return false;
  }
}

class DefaultProductDiscussionListItemValueStorage extends ProductDiscussionListItemValueStorage {
  final Map<String, PagingDataResult<ProductDiscussionDialog>> _lastProductDiscussionDialogPagingDataResult = {};
  final Map<String, LoadDataResult<PagingDataResult<ProductDiscussionDialog>>> _productDiscussionDialogPagingLoadDataResult = {};
  final Map<String, List<ProductDiscussionDialog>> _productDiscussionDialogList = {};
}

class DefaultProductDiscussionContainerInterceptingActionListItemControllerState extends ProductDiscussionContainerInterceptingActionListItemControllerState {
  void Function(ProductDiscussionListItemValue)? _onUpdateProductDiscussionListItemValue;

  @override
  void Function(ProductDiscussionListItemValue)? get onUpdateProductDiscussionListItemValue => _onUpdateProductDiscussionListItemValue;
}