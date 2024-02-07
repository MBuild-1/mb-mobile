import 'package:collection/collection.dart';

import '../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/selectprovinceslistitemcontrollerstate/province_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/selectprovinceslistitemcontrollerstate/vertical_province_list_item_controller_state.dart';
import '../itemtypelistinterceptor/itemtypelistinterceptorchecker/list_item_controller_state_item_type_list_interceptor_checker.dart';
import '../typedef.dart';
import 'item_type_list_sub_interceptor.dart';

class ProvinceItemTypeListSubInterceptor extends ItemTypeListSubInterceptor<ListItemControllerState> {
  final DoubleReturned padding;
  final DoubleReturned itemSpacing;
  final ListItemControllerStateItemTypeInterceptorChecker listItemControllerStateItemTypeInterceptorChecker;

  ProvinceItemTypeListSubInterceptor({
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
    if (oldItemType is ProvinceContainerListItemControllerState) {
      List<ListItemControllerState> resultListItemControllerStateList = oldItemType.province.mapIndexed<ListItemControllerState>(
        (index, province) => VerticalProvinceListItemControllerState(
          province: province,
          isSelected: oldItemType.onGetSelectProvince!()?.id == province.id,
          onSelectProvince: (province) {
            if (oldItemType.onSelectProvince != null) {
              oldItemType.onSelectProvince!(province);
            }
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