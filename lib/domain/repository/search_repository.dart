import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/search/remove_all_search_history_parameter.dart';
import '../entity/search/remove_all_search_history_response.dart';
import '../entity/search/search_history_parameter.dart';
import '../entity/search/search_history_response.dart';
import '../entity/search/search_last_seen_history_parameter.dart';
import '../entity/search/search_last_seen_history_response.dart';
import '../entity/search/search_parameter.dart';
import '../entity/search/search_response.dart';
import '../entity/search/store_keyword_for_search_history_parameter.dart';
import '../entity/search/store_keyword_for_search_history_response.dart';
import '../entity/search/store_search_last_seen_history_parameter.dart';
import '../entity/search/store_search_last_seen_history_response.dart';

abstract class SearchRepository {
  FutureProcessing<LoadDataResult<SearchResponse>> search(SearchParameter searchParameter);
  FutureProcessing<LoadDataResult<SearchHistoryResponse>> searchHistory(SearchHistoryParameter searchHistoryParameter);
  FutureProcessing<LoadDataResult<SearchLastSeenHistoryResponse>> searchLastSeenHistory(SearchLastSeenHistoryParameter searchLastSeenHistoryParameter);
  FutureProcessing<LoadDataResult<RemoveAllSearchHistoryResponse>> removeAllSearchHistory(RemoveAllSearchHistoryParameter removeAllSearchHistoryParameter);
  FutureProcessing<LoadDataResult<StoreKeywordForSearchHistoryResponse>> storeKeywordForSearchHistory(StoreKeywordForSearchHistoryParameter storeKeywordForSearchHistoryParameter);
  FutureProcessing<LoadDataResult<StoreSearchLastSeenHistoryResponse>> storeSearchLastSeenHistory(StoreSearchLastSeenHistoryParameter storeSearchLastSeenHistoryParameter);
}