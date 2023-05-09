import 'package:dio/dio.dart';
import 'package:masterbagasi/data/entitymappingext/news_entity_mapping_ext.dart';
import 'package:masterbagasi/data/entitymappingext/video_entity_mapping_ext.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/response_wrapper_ext.dart';

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
import '../../../misc/processing/dio_http_client_processing.dart';
import '../../../misc/processing/dummy_future_processing.dart';
import '../../../misc/processing/future_processing.dart';
import 'feed_data_source.dart';

class DefaultFeedDataSource implements FeedDataSource {
  final Dio dio;

  const DefaultFeedDataSource({
    required this.dio
  });

  @override
  FutureProcessing<PagingDataResult<ShortVideo>> shortVideoPaging(ShortVideoPagingParameter shortVideoPagingParameter) {
    throw UnimplementedError();
  }

  @override
  FutureProcessing<List<ShortVideo>> shortVideoList(ShortVideoListParameter shortVideoListParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/youtube/type/shorts", cancelToken: cancelToken)
        .map<List<ShortVideo>>(onMap: (value) => value.wrapResponse().mapFromResponseToShortVideoList());
    });
  }


  @override
  FutureProcessing<List<DefaultVideo>> defaultVideoList(DefaultVideoListParameter defaultVideoListParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/youtube/type/video", cancelToken: cancelToken)
        .map<List<DefaultVideo>>(onMap: (value) => value.wrapResponse().mapFromResponseToDefaultVideoList());
    });
  }

  @override
  FutureProcessing<List<DeliveryReview>> deliveryReviewList(DeliveryReviewListParameter deliveryReviewListParameter) {
    return DummyFutureProcessing((cancelToken) async {
      await Future.delayed(const Duration(seconds: 1));
      return <DeliveryReview>[
        DeliveryReview(
          id: "1",
          userName: "Ciya",
          userProfilePicture: "",
          rating: 5.0,
          country: "Korea Selatan",
          review: "Review 1"
        ),
        DeliveryReview(
          id: "2",
          userName: "Dandi",
          userProfilePicture: "",
          rating: 5.0,
          country: "Turki",
          review: "Review 2"
        ),
        DeliveryReview(
          id: "3",
          userName: "Naufal",
          userProfilePicture: "",
          rating: 5.0,
          country: "Jepang",
          review: "Review 3"
        )
      ];
    });
  }

  @override
  FutureProcessing<PagingDataResult<News>> newsPaging(NewsPagingParameter newsPagingParameter) {
    return DioHttpClientProcessing((cancelToken) {
      String pageParameterPath = "/?pageNumber=${newsPagingParameter.itemEachPageCount}&page=${newsPagingParameter.page}";
      return dio.get("/news$pageParameterPath", cancelToken: cancelToken)
        .map<PagingDataResult<News>>(onMap: (value) => value.wrapResponse().mapFromResponseToNewsPaging());
    });
  }
}