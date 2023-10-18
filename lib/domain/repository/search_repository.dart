import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/search/search_parameter.dart';
import '../entity/search/search_response.dart';

abstract class SearchRepository {
  FutureProcessing<LoadDataResult<SearchResponse>> search(SearchParameter searchParameter);
}