import '../searchfilter/support_search_filter.dart';

class SearchSortBy implements SupportSearchFilter {
  @override
  String name;

  @override
  String value;

  SearchSortBy({
    required this.name,
    required this.value
  });
}