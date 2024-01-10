import 'package:collection/collection.dart';

import '../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/selectlanguagelistitemcontrollerstate/select_language_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/selectlanguagelistitemcontrollerstate/vertical_select_language_list_item_controller_state.dart';
import '../itemtypelistinterceptor/itemtypelistinterceptorchecker/list_item_controller_state_item_type_list_interceptor_checker.dart';
import '../typedef.dart';
import 'item_type_list_sub_interceptor.dart';

class SelectLanguageItemTypeListSubInterceptor extends ItemTypeListSubInterceptor<ListItemControllerState> {
  final DoubleReturned padding;
  final DoubleReturned itemSpacing;
  final ListItemControllerStateItemTypeInterceptorChecker listItemControllerStateItemTypeInterceptorChecker;

  SelectLanguageItemTypeListSubInterceptor({
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
    if (oldItemType is SelectLanguageContainerListItemControllerState) {
      List<ListItemControllerState> resultListItemControllerStateList = oldItemType.selectLanguageList.mapIndexed<ListItemControllerState>(
        (index, selectLanguage) => VerticalSelectLanguageListItemControllerState(
          selectLanguage: selectLanguage,
          isSelected: oldItemType.onGetSelectLanguage != null ? oldItemType.onGetSelectLanguage!()?.localeString == selectLanguage.localeString : false,
          onSelectLanguage: (value) {
            oldItemType.onSelectLanguage(selectLanguage);
            oldItemType.onUpdateState();
          },
        )
      ).toList();
      for (var listItemControllerState in resultListItemControllerStateList) {
        listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
          i, ListItemControllerStateWrapper(listItemControllerState), oldItemTypeList, newItemTypeList
        );
      }
      return true;
    }
    return false;
  }
}