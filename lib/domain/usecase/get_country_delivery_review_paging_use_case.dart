import '../../misc/load_data_result.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/delivery/country_delivery_review.dart';
import '../entity/delivery/country_delivery_review_paging_parameter.dart';
import '../repository/feed_repository.dart';

class GetCountryDeliveryReviewPagingUseCase {
  final FeedRepository feedRepository;

  const GetCountryDeliveryReviewPagingUseCase({
    required this.feedRepository
  });

  FutureProcessing<LoadDataResult<PagingDataResult<CountryDeliveryReview>>> execute(CountryDeliveryReviewPagingParameter countryDeliveryReviewPagingParameter) {
    return feedRepository.countryDeliveryReviewPaging(countryDeliveryReviewPagingParameter);
  }
}