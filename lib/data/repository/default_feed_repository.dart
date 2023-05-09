import '../../domain/entity/delivery/delivery_review.dart';
import '../../domain/entity/delivery/delivery_review_list_parameter.dart';
import '../../domain/entity/news/news.dart';
import '../../domain/entity/news/news_paging_parameter.dart';
import '../../domain/entity/video/defaultvideo/default_video.dart';
import '../../domain/entity/video/defaultvideo/default_video_list_parameter.dart';
import '../../domain/entity/video/shortvideo/short_video.dart';
import '../../domain/entity/video/shortvideo/short_video_list_parameter.dart';
import '../../domain/entity/video/shortvideo/short_video_paging_parameter.dart';
import '../../domain/repository/feed_repository.dart';
import '../../misc/load_data_result.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../datasource/feeddatasource/feed_data_source.dart';

class DefaultFeedRepository implements FeedRepository {
  final FeedDataSource feedDataSource;

  const DefaultFeedRepository({
    required this.feedDataSource
  });

  @override
  FutureProcessing<LoadDataResult<PagingDataResult<ShortVideo>>> shortVideoPaging(ShortVideoPagingParameter shortVideoPagingParameter) {
    return feedDataSource.shortVideoPaging(shortVideoPagingParameter).mapToLoadDataResult<PagingDataResult<ShortVideo>>();
  }

  @override
  FutureProcessing<LoadDataResult<List<ShortVideo>>> shortVideoList(ShortVideoListParameter shortVideoListParameter) {
    return feedDataSource.shortVideoList(shortVideoListParameter).mapToLoadDataResult<List<ShortVideo>>();
  }

  @override
  FutureProcessing<LoadDataResult<List<DefaultVideo>>> defaultVideoList(DefaultVideoListParameter defaultVideoListParameter) {
    return feedDataSource.defaultVideoList(defaultVideoListParameter).mapToLoadDataResult<List<DefaultVideo>>();
  }

  @override
  FutureProcessing<LoadDataResult<List<DeliveryReview>>> deliveryReviewList(DeliveryReviewListParameter deliveryReviewListParameter) {
    return feedDataSource.deliveryReviewList(deliveryReviewListParameter).mapToLoadDataResult<List<DeliveryReview>>();
  }

  @override
  FutureProcessing<LoadDataResult<PagingDataResult<News>>> newsPaging(NewsPagingParameter newsPagingParameter) {
    return feedDataSource.newsPaging(newsPagingParameter).mapToLoadDataResult<PagingDataResult<News>>();
  }
}