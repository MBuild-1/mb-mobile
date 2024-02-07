import 'dart:ui';

import '../../../searchfiltercontainermemberlistitemvalue/search_filter_container_member_list_item_value.dart';
import '../list_item_controller_state.dart';

class SearchFilterContainerListItemControllerState extends ListItemControllerState {
  List<SearchFilterContainerMemberListItemValue> searchFilterContainerMemberListItemValueList;
  Color Function() onGetColorfulChipTabBarColor;
  void Function() onUpdateState;

  SearchFilterContainerListItemControllerState({
    required this.searchFilterContainerMemberListItemValueList,
    required this.onGetColorfulChipTabBarColor,
    required this.onUpdateState
  });
}