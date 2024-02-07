import 'support_search_filter.dart';

class SearchFilterGroup<T extends SupportSearchFilter> {
  String name;
  String? description;
  List<T> filterSupportSearchFilterList;

  SearchFilterGroup({
    required this.name,
    this.description,
    required this.filterSupportSearchFilterList
  });
}