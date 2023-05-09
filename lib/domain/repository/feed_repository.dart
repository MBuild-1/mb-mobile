import '../../misc/load_data_result.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/delivery/delivery_review.dart';
import '../entity/delivery/delivery_review_list_parameter.dart';
import '../entity/news/news.dart';
import '../entity/news/news_paging_parameter.dart';
import '../entity/video/defaultvideo/default_video.dart';
import '../entity/video/defaultvideo/default_video_list_parameter.dart';
import '../entity/video/shortvideo/short_video.dart';
import '../entity/video/shortvideo/short_video_list_parameter.dart';
import '../entity/video/shortvideo/short_video_paging_parameter.dart';

abstract class FeedRepository {
  FutureProcessing<LoadDataResult<PagingDataResult<ShortVideo>>> shortVideoPaging(ShortVideoPagingParameter shortVideoPagingParameter);
  FutureProcessing<LoadDataResult<List<ShortVideo>>> shortVideoList(ShortVideoListParameter shortVideoListParameter);
  FutureProcessing<LoadDataResult<List<DefaultVideo>>> defaultVideoList(DefaultVideoListParameter defaultVideoListParameter);
  FutureProcessing<LoadDataResult<List<DeliveryReview>>> deliveryReviewList(DeliveryReviewListParameter deliveryReviewListParameter);
  FutureProcessing<LoadDataResult<PagingDataResult<News>>> newsPaging(NewsPagingParameter newsPagingParameter);
}