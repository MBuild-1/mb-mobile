import '../../domain/entity/search/search_parameter.dart';
import '../../domain/entity/search/search_response.dart';
import '../../domain/repository/search_repository.dart';
import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../datasource/searchdatasource/search_data_source.dart';

class DefaultSearchRepository implements SearchRepository {
  final SearchDataSource searchDataSource;

  const DefaultSearchRepository({
    required this.searchDataSource,
  });

  @override
  FutureProcessing<LoadDataResult<SearchResponse>> search(SearchParameter searchParameter) {
    return searchDataSource.search(searchParameter).mapToLoadDataResult<SearchResponse>();
  }
}