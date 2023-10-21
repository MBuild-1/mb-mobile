import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/search/search_last_seen_history_parameter.dart';
import '../entity/search/search_last_seen_history_response.dart';
import '../repository/search_repository.dart';

class SearchLastSeenHistoryUseCase {
  final SearchRepository searchRepository;

  const SearchLastSeenHistoryUseCase({
    required this.searchRepository
  });

  FutureProcessing<LoadDataResult<SearchLastSeenHistoryResponse>> execute(SearchLastSeenHistoryParameter searchLastSeenHistoryParameter) {
    return searchRepository.searchLastSeenHistory(searchLastSeenHistoryParameter);
  }
}