import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/number_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../presentation/page/modaldialogpage/input_value_modal_dialog_page.dart';
import '../../presentation/widget/colorful_chip_tab_bar.dart';
import '../../presentation/widget/modified_chip.dart';
import '../constant.dart';
import '../controllerstate/listitemcontrollerstate/colorful_chip_tab_bar_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/compound_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/searchfilterlistitemcontrollerstate/search_filter_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/title_and_description_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/widget_substitution_list_item_controller_state.dart';
import '../dialog_helper.dart';
import '../error/validation_error.dart';
import '../itemtypelistinterceptor/itemtypelistinterceptorchecker/list_item_controller_state_item_type_list_interceptor_checker.dart';
import '../multi_language_string.dart';
import '../searchfiltercontainermemberlistitemvalue/search_filter_container_member_list_item_value.dart';
import '../searchfiltercontainermemberlistitemvalue/search_filter_group_list_item_value.dart';
import '../searchfiltercontainermemberlistitemvalue/search_filter_number_range_list_item_value.dart';
import '../typedef.dart';
import '../validation/validation_result.dart';
import 'item_type_list_sub_interceptor.dart';

class SearchFilterItemTypeListSubInterceptor extends ItemTypeListSubInterceptor<ListItemControllerState> {
  final DoubleReturned padding;
  final DoubleReturned itemSpacing;
  final ListItemControllerStateItemTypeInterceptorChecker listItemControllerStateItemTypeInterceptorChecker;

  SearchFilterItemTypeListSubInterceptor({
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
    if (oldItemType is SearchFilterContainerListItemControllerState) {
      List<ListItemControllerState> newListItemControllerStateList = [];
      int k = 0;
      int itemCount = 0;
      void addMemberListItemControllerState(ListItemControllerState listItemControllerState) {
        listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
          i,
          ListItemControllerStateWrapper(
            CompoundListItemControllerState(
              listItemControllerState: [
                if (itemCount > 0) VirtualSpacingListItemControllerState(height: 20),
                listItemControllerState
              ]
            )
          ),
          oldItemTypeList,
          newListItemControllerStateList
        );
        itemCount += 1;
      }
      while (k < oldItemType.searchFilterContainerMemberListItemValueList.length) {
        SearchFilterContainerMemberListItemValue searchFilterContainerMemberListItemValue = oldItemType.searchFilterContainerMemberListItemValueList[k];
        if (searchFilterContainerMemberListItemValue is SearchFilterGroupListItemValue) {
          addMemberListItemControllerState(
            _searchFilterGroupListItemControllerState(
              oldItemType: oldItemType,
              searchFilterGroupListItemValue: searchFilterContainerMemberListItemValue
            )
          );
        } else if (searchFilterContainerMemberListItemValue is SearchFilterNumberRangeListItemValue) {
          addMemberListItemControllerState(
            _searchFilterNumberRangeListItemControllerState(
              oldItemType: oldItemType,
              searchFilterNumberRangeListItemValue: searchFilterContainerMemberListItemValue
            )
          );
        }
        k++;
      }
      newItemTypeList.addAll(newListItemControllerStateList);
      return true;
    }
    return false;
  }

  ListItemControllerState _searchFilterGroupListItemControllerState({
    required SearchFilterContainerListItemControllerState oldItemType,
    required SearchFilterGroupListItemValue searchFilterGroupListItemValue
  }) {
    BaseColorfulChipTabBarController baseColorfulChipTabBarController = searchFilterGroupListItemValue.onGetColorfulChipTabBarController();
    return CompoundListItemControllerState(
      listItemControllerState: [
        PaddingContainerListItemControllerState(
          padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
          paddingChildListItemControllerState: TitleAndDescriptionListItemControllerState(
            title: searchFilterGroupListItemValue.searchFilterGroup.name,
            description: null,
            verticalSpace: 25,
            titleAndDescriptionItemInterceptor: (padding, title, titleWidget, description, descriptionWidget, titleAndDescriptionWidget, titleAndDescriptionWidgetList) {
              titleAndDescriptionWidgetList.first = Text(title.toStringNonNull, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold));
              return titleAndDescriptionWidget;
            }
          )
        ),
        VirtualSpacingListItemControllerState(height: 10.0),
        ColorfulChipTabBarListItemControllerState(
          colorfulChipTabBarController: baseColorfulChipTabBarController,
          colorfulChipTabBarDataList: searchFilterGroupListItemValue.searchFilterGroup.filterSupportSearchFilterList.map<ColorfulChipTabBarData>(
            (searchRelated) => ColorfulChipTabBarData(
              title: searchRelated.name,
              color: oldItemType.onGetColorfulChipTabBarColor(),
              data: searchRelated.value
            )
          ).toList(),
          canSelectAndUnselect: searchFilterGroupListItemValue.canSelectAndUnselect
        ),
      ],
    );
  }

  ListItemControllerState _searchFilterNumberRangeListItemControllerState({
    required SearchFilterContainerListItemControllerState oldItemType,
    required SearchFilterNumberRangeListItemValue searchFilterNumberRangeListItemValue
  }) {
    return CompoundListItemControllerState(
      listItemControllerState: [
        PaddingContainerListItemControllerState(
          padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
          paddingChildListItemControllerState: TitleAndDescriptionListItemControllerState(
            title: searchFilterNumberRangeListItemValue.name,
            description: null,
            verticalSpace: 25,
            titleAndDescriptionItemInterceptor: (padding, title, titleWidget, description, descriptionWidget, titleAndDescriptionWidget, titleAndDescriptionWidgetList) {
              titleAndDescriptionWidgetList.first = Text(title.toStringNonNull, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold));
              return titleAndDescriptionWidget;
            }
          )
        ),
        VirtualSpacingListItemControllerState(height: 10.0),
        PaddingContainerListItemControllerState(
          padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
          paddingChildListItemControllerState: WidgetSubstitutionListItemControllerState(
            widgetSubstitution: (context, index) {
              ValidationResult onValidate(String input) {
                if (input.trim().isEmptyString) {
                  return SuccessValidationResult();
                }
                return int.tryParse(input) != null ? SuccessValidationResult() : FailedValidationResult(
                  e: ValidationError(
                    message: MultiLanguageString({
                      Constant.textEnUsLanguageKey: "This input must be a number.",
                      Constant.textInIdLanguageKey: "Inputnya harus berupa angka."
                    }).toEmptyStringNonNull
                  )
                );
              }
              return Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          searchFilterNumberRangeListItemValue.range1Text,
                          style: const TextStyle(
                            fontSize: 12.0
                          ),
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          width: double.infinity,
                          child: ModifiedChipButton(
                            label: Text(
                              () {
                                String text = searchFilterNumberRangeListItemValue.onGetRange1TextEditingController().text;
                                if (text.isEmptyString) {
                                  return "No Value".tr;
                                }
                                int? value = int.tryParse(text);
                                if (value != null) {
                                  return value.toRupiah(withFreeTextIfZero: false);
                                }
                                return text;
                              }()
                            ),
                            backgroundColor: Constant.colorGrey6,
                            statedLabelStyleFunction: (oldLabelStyle, backgroundColor, unselectedBackgroundColor, isSelected) {
                              return oldLabelStyle?.copyWith(color: Constant.colorDarkBlack);
                            },
                            isSelected: true,
                            canSelectAndUnselect: true,
                            onTap: () async {
                              dynamic result = await DialogHelper.showModalDialogPage<String, InputValueModalDialogPageParameter>(
                                context: context,
                                modalDialogPageBuilder: (context, parameter) => InputValueModalDialogPage(
                                  inputValueModalDialogPageParameter: parameter!
                                ),
                                parameter: InputValueModalDialogPageParameter(
                                  value: searchFilterNumberRangeListItemValue.onGetRange1TextEditingController().text,
                                  title: () => searchFilterNumberRangeListItemValue.range1Text,
                                  inputTitle: () => searchFilterNumberRangeListItemValue.range1InputText,
                                  inputHint: () => searchFilterNumberRangeListItemValue.range1InputHintText,
                                  inputSubmitText: () => "Submit".tr,
                                  requiredMessage: () => "",
                                  onValidate: onValidate
                                ),
                              );
                              if (result is String) {
                                searchFilterNumberRangeListItemValue.onGetRange1TextEditingController().text = result.trim();
                                oldItemType.onUpdateState();
                              }
                            }
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          searchFilterNumberRangeListItemValue.range2Text,
                          style: const TextStyle(
                            fontSize: 12.0
                          ),
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          width: double.infinity,
                          child: ModifiedChipButton(
                            label: Text(
                              () {
                                String text = searchFilterNumberRangeListItemValue.onGetRange2TextEditingController().text;
                                if (text.isEmptyString) {
                                  return "No Value".tr;
                                }
                                int? value = int.tryParse(text);
                                if (value != null) {
                                  return value.toRupiah(withFreeTextIfZero: false);
                                }
                                return text;
                              }()
                            ),
                            backgroundColor: Constant.colorGrey6,
                            statedLabelStyleFunction: (oldLabelStyle, backgroundColor, unselectedBackgroundColor, isSelected) {
                              return oldLabelStyle?.copyWith(color: Constant.colorDarkBlack);
                            },
                            isSelected: true,
                            canSelectAndUnselect: true,
                            onTap: () async {
                              dynamic result = await DialogHelper.showModalDialogPage<String, InputValueModalDialogPageParameter>(
                                context: context,
                                modalDialogPageBuilder: (context, parameter) => InputValueModalDialogPage(
                                  inputValueModalDialogPageParameter: parameter!
                                ),
                                parameter: InputValueModalDialogPageParameter(
                                  value: searchFilterNumberRangeListItemValue.onGetRange2TextEditingController().text,
                                  title: () => searchFilterNumberRangeListItemValue.range2Text,
                                  inputTitle: () => searchFilterNumberRangeListItemValue.range2InputText,
                                  inputHint: () => searchFilterNumberRangeListItemValue.range2InputHintText,
                                  inputSubmitText: () => "Submit".tr,
                                  requiredMessage: () => "",
                                  onValidate: onValidate,
                                ),
                              );
                              if (result is String) {
                                searchFilterNumberRangeListItemValue.onGetRange2TextEditingController().text = result.trim();
                                oldItemType.onUpdateState();
                              }
                            }
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            }
          )
        )
      ],
    );
  }
}