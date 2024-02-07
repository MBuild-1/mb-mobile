import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/search/store_search_last_seen_history_parameter.dart';
import '../entity/search/store_search_last_seen_history_response.dart';
import '../repository/search_repository.dart';

class StoreSearchLastSeenHistoryUseCase {
  final SearchRepository searchRepository;

  const StoreSearchLastSeenHistoryUseCase({
    required this.searchRepository
  });

  FutureProcessing<LoadDataResult<StoreSearchLastSeenHistoryResponse>> execute(StoreSearchLastSeenHistoryParameter storeSearchLastSeenHistoryParameter) {
    return searchRepository.storeSearchLastSeenHistory(storeSearchLastSeenHistoryParameter);
  }
}