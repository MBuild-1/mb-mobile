import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/search/remove_all_search_history_parameter.dart';
import '../entity/search/remove_all_search_history_response.dart';
import '../repository/search_repository.dart';

class RemoveAllSearchHistoryUseCase {
  final SearchRepository searchRepository;

  const RemoveAllSearchHistoryUseCase({
    required this.searchRepository
  });

  FutureProcessing<LoadDataResult<RemoveAllSearchHistoryResponse>> execute(RemoveAllSearchHistoryParameter removeAllSearchHistoryParameter) {
    return searchRepository.removeAllSearchHistory(removeAllSearchHistoryParameter);
  }
}