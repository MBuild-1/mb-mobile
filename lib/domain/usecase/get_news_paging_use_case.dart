import '../../misc/load_data_result.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/news/news.dart';
import '../entity/news/news_paging_parameter.dart';
import '../repository/feed_repository.dart';

class GetNewsPagingUseCase {
  final FeedRepository feedRepository;

  const GetNewsPagingUseCase({
    required this.feedRepository
  });

  FutureProcessing<LoadDataResult<PagingDataResult<News>>> execute(NewsPagingParameter newsPagingParameter) {
    return feedRepository.newsPaging(newsPagingParameter);
  }
}