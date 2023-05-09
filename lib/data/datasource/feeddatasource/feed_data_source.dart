import '../../../domain/entity/delivery/delivery_review.dart';
import '../../../domain/entity/delivery/delivery_review_list_parameter.dart';
import '../../../domain/entity/news/news.dart';
import '../../../domain/entity/news/news_paging_parameter.dart';
import '../../../domain/entity/video/defaultvideo/default_video.dart';
import '../../../domain/entity/video/defaultvideo/default_video_list_parameter.dart';
import '../../../domain/entity/video/shortvideo/short_video.dart';
import '../../../domain/entity/video/shortvideo/short_video_list_parameter.dart';
import '../../../domain/entity/video/shortvideo/short_video_paging_parameter.dart';
import '../../../misc/paging/pagingresult/paging_data_result.dart';
import '../../../misc/processing/future_processing.dart';

abstract class FeedDataSource {
  FutureProcessing<PagingDataResult<ShortVideo>> shortVideoPaging(ShortVideoPagingParameter shortVideoPagingParameter);
  FutureProcessing<List<ShortVideo>> shortVideoList(ShortVideoListParameter shortVideoPagingParameter);
  FutureProcessing<List<DefaultVideo>> defaultVideoList(DefaultVideoListParameter defaultVideoListParameter);
  FutureProcessing<List<DeliveryReview>> deliveryReviewList(DeliveryReviewListParameter deliveryReviewListParameter);
  FutureProcessing<PagingDataResult<News>> newsPaging(NewsPagingParameter newsPagingParameter);
}