abstract class SearchRelated {
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