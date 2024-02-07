import '../searchfilter/support_search_filter.dart';

abstract class SearchRelated implements SupportSearchFilter {
  @override
  String get name => searchRelatedParameter.key;

  @override
  String get value => searchRelatedParameter.key;

  SearchRelatedParameter searchRelatedParameter;

  SearchRelated({
    required this.searchRelatedParameter
  });
}

class SearchRelatedParameter {
  String key;
  int count;

  SearchRelatedParameter({
    required this.key,
    required this.count
  });
}