import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/search/search_history_parameter.dart';
import '../entity/search/search_history_response.dart';
import '../repository/search_repository.dart';

class SearchHistoryUseCase {
  final SearchRepository searchRepository;

  const SearchHistoryUseCase({
    required this.searchRepository
  });

  FutureProcessing<LoadDataResult<SearchHistoryResponse>> execute(SearchHistoryParameter searchHistoryParameter) {
    return searchRepository.searchHistory(searchHistoryParameter);
  }
}