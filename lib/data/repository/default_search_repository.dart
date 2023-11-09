import '../../domain/entity/search/remove_all_search_history_parameter.dart';
import '../../domain/entity/search/remove_all_search_history_response.dart';
import '../../domain/entity/search/search_history_parameter.dart';
import '../../domain/entity/search/search_history_response.dart';
import '../../domain/entity/search/search_last_seen_history_parameter.dart';
import '../../domain/entity/search/search_last_seen_history_response.dart';
import '../../domain/entity/search/search_parameter.dart';
import '../../domain/entity/search/search_response.dart';
import '../../domain/entity/search/store_keyword_for_search_history_parameter.dart';
import '../../domain/entity/search/store_keyword_for_search_history_response.dart';
import '../../domain/entity/search/store_search_last_seen_history_parameter.dart';
import '../../domain/entity/search/store_search_last_seen_history_response.dart';
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

  @override
  FutureProcessing<LoadDataResult<SearchHistoryResponse>> searchHistory(SearchHistoryParameter searchHistoryParameter) {
    return searchDataSource.searchHistory(searchHistoryParameter).mapToLoadDataResult<SearchHistoryResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<SearchLastSeenHistoryResponse>> searchLastSeenHistory(SearchLastSeenHistoryParameter searchLastSeenHistoryParameter) {
    return searchDataSource.searchLastSeenHistory(searchLastSeenHistoryParameter).mapToLoadDataResult<SearchLastSeenHistoryResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<RemoveAllSearchHistoryResponse>> removeAllSearchHistory(RemoveAllSearchHistoryParameter removeAllSearchHistoryParameter) {
    return searchDataSource.removeAllSearchHistory(removeAllSearchHistoryParameter).mapToLoadDataResult<RemoveAllSearchHistoryResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<StoreKeywordForSearchHistoryResponse>> storeKeywordForSearchHistory(StoreKeywordForSearchHistoryParameter storeKeywordForSearchHistoryParameter) {
    return searchDataSource.storeKeywordForSearchHistory(storeKeywordForSearchHistoryParameter).mapToLoadDataResult<StoreKeywordForSearchHistoryResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<StoreSearchLastSeenHistoryResponse>> storeSearchLastSeenHistory(StoreSearchLastSeenHistoryParameter storeSearchLastSeenHistoryParameter) {
    return searchDataSource.storeSearchLastSeenHistory(storeSearchLastSeenHistoryParameter).mapToLoadDataResult<StoreSearchLastSeenHistoryResponse>();
  }
}