import '../../domain/entity/search/searchfilter/search_filter_group.dart';
import '../../presentation/widget/colorful_chip_tab_bar.dart';
import 'search_filter_container_member_list_item_value.dart';

class SearchFilterGroupListItemValue extends SearchFilterContainerMemberListItemValue {
  SearchFilterGroup searchFilterGroup;
  BaseColorfulChipTabBarController Function() onGetColorfulChipTabBarController;
  bool? canSelectAndUnselect;

  SearchFilterGroupListItemValue({
    required this.searchFilterGroup,
    required this.onGetColorfulChipTabBarController,
    this.canSelectAndUnselect
  });
}