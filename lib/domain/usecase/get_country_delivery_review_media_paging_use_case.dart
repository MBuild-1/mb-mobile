import '../../misc/load_data_result.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/delivery/countrydeliveryreviewmedia/country_delivery_review_media.dart';
import '../entity/delivery/countrydeliveryreviewmedia/country_delivery_review_media_paging_parameter.dart';
import '../repository/feed_repository.dart';

class GetCountryDeliveryReviewMediaPagingUseCase {
  final FeedRepository feedRepository;

  const GetCountryDeliveryReviewMediaPagingUseCase({
    required this.feedRepository
  });

  FutureProcessing<LoadDataResult<PagingDataResult<CountryDeliveryReviewMedia>>> execute(CountryDeliveryReviewMediaPagingParameter countryDeliveryReviewMediaPagingParameter) {
    return feedRepository.countryDeliveryReviewMediaPaging(countryDeliveryReviewMediaPagingParameter);
  }
}