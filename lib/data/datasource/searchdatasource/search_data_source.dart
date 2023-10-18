import '../../../domain/entity/search/search_parameter.dart';
import '../../../domain/entity/search/search_response.dart';
import '../../../misc/processing/future_processing.dart';

abstract class SearchDataSource {
  FutureProcessing<SearchResponse> search(SearchParameter searchParameter);
}