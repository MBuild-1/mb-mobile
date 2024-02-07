import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/search/search_parameter.dart';
import '../entity/search/search_response.dart';
import '../repository/search_repository.dart';

class SearchUseCase {
  final SearchRepository searchRepository;

  const SearchUseCase({
    required this.searchRepository
  });

  FutureProcessing<LoadDataResult<SearchResponse>> execute(SearchParameter searchParameter) {
    return searchRepository.search(searchParameter);
  }
}