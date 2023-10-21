import '../../../domain/entity/search/search_history_parameter.dart';
import '../../../domain/entity/search/search_history_response.dart';
import '../../../domain/entity/search/search_last_seen_history_parameter.dart';
import '../../../domain/entity/search/search_last_seen_history_response.dart';
import '../../../domain/entity/search/search_parameter.dart';
import '../../../domain/entity/search/search_response.dart';
import '../../../domain/entity/search/store_keyword_for_search_history_parameter.dart';
import '../../../domain/entity/search/store_keyword_for_search_history_response.dart';
import '../../../domain/entity/search/store_search_last_seen_history_parameter.dart';
import '../../../domain/entity/search/store_search_last_seen_history_response.dart';
import '../../../misc/processing/future_processing.dart';

abstract class SearchDataSource {
  FutureProcessing<SearchResponse> search(SearchParameter searchParameter);
  FutureProcessing<SearchHistoryResponse> searchHistory(SearchHistoryParameter searchHistoryParameter);
  FutureProcessing<SearchLastSeenHistoryResponse> searchLastSeenHistory(SearchLastSeenHistoryParameter searchLastSeenHistoryParameter);
  FutureProcessing<StoreKeywordForSearchHistoryResponse> storeKeywordForSearchHistory(StoreKeywordForSearchHistoryParameter storeKeywordForSearchHistoryParameter);
  FutureProcessing<StoreSearchLastSeenHistoryResponse> storeSearchLastSeenHistory(StoreSearchLastSeenHistoryParameter storeSearchLastSeenHistoryParameter);
}