import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/search/store_keyword_for_search_history_parameter.dart';
import '../entity/search/store_keyword_for_search_history_response.dart';
import '../repository/search_repository.dart';

class StoreKeywordForSearchHistoryUseCase {
  final SearchRepository searchRepository;

  const StoreKeywordForSearchHistoryUseCase({
    required this.searchRepository
  });

  FutureProcessing<LoadDataResult<StoreKeywordForSearchHistoryResponse>> execute(StoreKeywordForSearchHistoryParameter storeKeywordForSearchHistoryParameter) {
    return searchRepository.storeKeywordForSearchHistory(storeKeywordForSearchHistoryParameter);
  }
}