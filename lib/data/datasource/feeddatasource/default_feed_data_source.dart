import 'package:dio/dio.dart';
import 'package:masterbagasi/data/entitymappingext/delivery_review_entity_mapping_ext.dart';
import 'package:masterbagasi/data/entitymappingext/news_entity_mapping_ext.dart';
import 'package:masterbagasi/data/entitymappingext/video_entity_mapping_ext.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/response_wrapper_ext.dart';

import '../../../domain/entity/delivery/check_your_contribution_delivery_review_detail_parameter.dart';
import '../../../domain/entity/delivery/check_your_contribution_delivery_review_detail_response.dart';
import '../../../domain/entity/delivery/country_delivery_review_based_country_parameter.dart';
import '../../../domain/entity/delivery/country_delivery_review_response.dart';
import '../../../domain/entity/delivery/delivery_review.dart';
import '../../../domain/entity/delivery/delivery_review_list_parameter.dart';
import '../../../domain/entity/delivery/delivery_review_paging_parameter.dart';
import '../../../domain/entity/delivery/give_review_delivery_review_detail_parameter.dart';
import '../../../domain/entity/delivery/give_review_delivery_review_detail_response.dart';
import '../../../domain/entity/delivery/givedeliveryreviewvalue/give_delivery_review_value.dart';
import '../../../domain/entity/news/news.dart';
import '../../../domain/entity/news/news_detail_parameter.dart';
import '../../../domain/entity/news/news_paging_parameter.dart';
import '../../../domain/entity/order/combined_order.dart';
import '../../../domain/entity/video/defaultvideo/default_video.dart';
import '../../../domain/entity/video/defaultvideo/default_video_list_parameter.dart';
import '../../../domain/entity/video/defaultvideo/default_video_paging_parameter.dart';
import '../../../domain/entity/video/shortvideo/short_video.dart';
import '../../../domain/entity/video/shortvideo/short_video_list_parameter.dart';
import '../../../domain/entity/video/shortvideo/short_video_paging_parameter.dart';
import '../../../misc/option_builder.dart';
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
    return DioHttpClientProcessing((cancelToken) {
      String pageParameterPath = "/?pageNumber=${shortVideoPagingParameter.itemEachPageCount}&page=${shortVideoPagingParameter.page}";
      return dio.get("/youtube/type/shorts$pageParameterPath", cancelToken: cancelToken)
        .map<PagingDataResult<ShortVideo>>(onMap: (value) => value.wrapResponse().mapFromResponseToShortVideoPaging());
    });
  }

  @override
  FutureProcessing<List<ShortVideo>> shortVideoList(ShortVideoListParameter shortVideoListParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/youtube/type/shorts", cancelToken: cancelToken)
        .map<List<ShortVideo>>(onMap: (value) => value.wrapResponse().mapFromResponseToShortVideoList());
    });
  }

  @override
  FutureProcessing<PagingDataResult<DefaultVideo>> defaultVideoPaging(DefaultVideoPagingParameter defaultVideoPagingParameter) {
    return DioHttpClientProcessing((cancelToken) {
      String pageParameterPath = "/?pageNumber=${defaultVideoPagingParameter.itemEachPageCount}&page=${defaultVideoPagingParameter.page}";
      return dio.get("/youtube/type/video$pageParameterPath", cancelToken: cancelToken)
        .map<PagingDataResult<DefaultVideo>>(onMap: (value) => value.wrapResponse().mapFromResponseToDefaultVideoPaging());
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
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/shipping-review", cancelToken: cancelToken)
        .map<List<DeliveryReview>>(onMap: (value) => value.wrapResponse().mapFromResponseToDeliveryReviewList());
    });
  }

  @override
  FutureProcessing<PagingDataResult<DeliveryReview>> deliveryReviewPaging(DeliveryReviewPagingParameter deliveryReviewPagingParameter) {
    return DummyFutureProcessing((cancelToken) async {
      await Future.delayed(const Duration(seconds: 1));
      return PagingDataResult<DeliveryReview>(
        page: 1,
        totalPage: 1,
        totalItem: 1,
        itemList: [
          DeliveryReview(
            id: "1",
            userName: "Ciya",
            userProfilePicture: "",
            productImageUrl: "",
            productName: "",
            rating: 5.0,
            country: "Korea Selatan",
            countryId: "",
            review: "Review 1",
            reviewDate: DateTime.now(),
          ),
          DeliveryReview(
            id: "2",
            userName: "Dandi",
            userProfilePicture: "",
            productImageUrl: "",
            productName: "",
            rating: 5.0,
            country: "Turki",
            countryId: "",
            review: "Review 2",
            reviewDate: DateTime.now(),
          ),
          DeliveryReview(
            id: "3",
            userName: "Naufal",
            userProfilePicture: "",
            productImageUrl: "",
            productName: "",
            rating: 5.0,
            country: "Jepang",
            countryId: "",
            review: "Review 3",
            reviewDate: DateTime.now(),
          )
        ]
      );
    });
  }

  @override
  FutureProcessing<PagingDataResult<DeliveryReview>> waitingToBeReviewedDeliveryReviewPaging(DeliveryReviewPagingParameter deliveryReviewPagingParameter) {
    return DummyFutureProcessing((cancelToken) async {
      await Future.delayed(const Duration(seconds: 1));
      return PagingDataResult<DeliveryReview>(
        page: 1,
        totalPage: 1,
        totalItem: 1,
        itemList: [
          DeliveryReview(
            id: "1",
            userName: "Ciya",
            userProfilePicture: "",
            productImageUrl: "",
            productName: "",
            rating: 5.0,
            country: "Korea Selatan",
            countryId: "",
            review: "Review 1",
            reviewDate: DateTime.now(),
          ),
          DeliveryReview(
            id: "2",
            userName: "Dandi",
            userProfilePicture: "",
            productImageUrl: "",
            productName: "",
            rating: 5.0,
            country: "Turki",
            countryId: "",
            review: "Review 2",
            reviewDate: DateTime.now(),
          ),
          DeliveryReview(
            id: "3",
            userName: "Naufal",
            userProfilePicture: "",
            productImageUrl: "",
            productName: "",
            rating: 5.0,
            country: "Jepang",
            countryId: "",
            review: "Review 3",
            reviewDate: DateTime.now(),
          )
        ]
      );
    });
  }

  @override
  FutureProcessing<PagingDataResult<DeliveryReview>> historyDeliveryReviewPaging(DeliveryReviewPagingParameter deliveryReviewPagingParameter) {
    return DioHttpClientProcessing((cancelToken) {
      String pageParameterPath = "/?pageNumber=${deliveryReviewPagingParameter.itemEachPageCount}&page=${deliveryReviewPagingParameter.page}";
      return dio.get("/shipping-review/user$pageParameterPath", cancelToken: cancelToken)
        .map<PagingDataResult<DeliveryReview>>(onMap: (value) => value.wrapResponse().mapFromResponseToDeliveryReviewPaging());
    });
  }

  @override
  FutureProcessing<List<DeliveryReview>> historyDeliveryReviewList(DeliveryReviewListParameter deliveryReviewListParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/shipping-review/user", cancelToken: cancelToken)
        .map<List<DeliveryReview>>(onMap: (value) => value.wrapResponse().mapFromResponseToDeliveryReviewList());
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

  @override
  FutureProcessing<News> newsDetail(NewsDetailParameter newsDetailParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/news/${newsDetailParameter.newsId}", cancelToken: cancelToken)
        .map<News>(onMap: (value) => value.wrapResponse().mapFromResponseToNews());
    });
  }

  @override
  FutureProcessing<CheckYourContributionDeliveryReviewDetailResponse> checkYourContributionDeliveryReviewDetail(CheckYourContributionDeliveryReviewDetailParameter checkYourContributionDeliveryReviewDetailParameter) {
    return DummyFutureProcessing((cancelToken) async {
      await Future.delayed(const Duration(seconds: 1));
      return CheckYourContributionDeliveryReviewDetailResponse(
        ratingCount: 10,
        fullReviewCount: 10,
        photoAndVideoCount: 10
      );
    });
  }

  @override
  FutureProcessing<GiveReviewDeliveryReviewDetailResponse> giveReviewDeliveryReviewDetail(GiveReviewDeliveryReviewDetailParameter giveReviewDeliveryReviewDetailParameter) {
    return DioHttpClientProcessing((cancelToken) async {
      GiveDeliveryReviewValue giveDeliveryReviewValue = giveReviewDeliveryReviewDetailParameter.giveDeliveryReviewValue;
      Map<String, dynamic> formDataMap = <String, dynamic> {
        "combined_order_id": giveDeliveryReviewValue.combinedOrderId,
        "country_id": giveDeliveryReviewValue.countryId,
        "rating": giveDeliveryReviewValue.rating,
        "review": giveDeliveryReviewValue.review,
      };
      int i = 0;
      for (String attachmentFilePath in giveDeliveryReviewValue.attachmentFilePath) {
        formDataMap["attachments[$i]"] = await MultipartFile.fromFile(attachmentFilePath) ;
        i++;
      }
      FormData formData = FormData.fromMap(formDataMap);
      return dio.post("/shipping-review", data: formData, cancelToken: cancelToken, options: OptionsBuilder.multipartData().build())
        .map<GiveReviewDeliveryReviewDetailResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToGiveReviewDeliveryReviewDetailResponse());
    });
  }

  @override
  FutureProcessing<CountryDeliveryReviewResponse> countryDeliveryReview(CountryDeliveryReviewBasedCountryParameter countryDeliveryReviewBasedCountryParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/shipping-review/country/${countryDeliveryReviewBasedCountryParameter.countryId}", cancelToken: cancelToken)
        .map<CountryDeliveryReviewResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToCountryDeliveryReviewResponse());
    });
  }
}