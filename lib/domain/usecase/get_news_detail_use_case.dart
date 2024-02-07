import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/news/news.dart';
import '../entity/news/news_detail_parameter.dart';
import '../repository/feed_repository.dart';

class GetNewsDetailUseCase {
  final FeedRepository feedRepository;

  const GetNewsDetailUseCase({
    required this.feedRepository
  });

  FutureProcessing<LoadDataResult<News>> execute(NewsDetailParameter newsDetailParameter) {
    return feedRepository.newsDetail(
      NewsDetailParameter(newsId: newsDetailParameter.newsId)
    );
  }
}