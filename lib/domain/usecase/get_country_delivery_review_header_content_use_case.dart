import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/delivery/country_delivery_review_header_content.dart';
import '../entity/delivery/country_delivery_review_header_content_parameter.dart';
import '../repository/feed_repository.dart';

class GetCountryDeliveryReviewHeaderContentUseCase {
  final FeedRepository feedRepository;

  const GetCountryDeliveryReviewHeaderContentUseCase({
    required this.feedRepository
  });

  FutureProcessing<LoadDataResult<CountryDeliveryReviewHeaderContent>> execute(CountryDeliveryReviewHeaderContentParameter countryDeliveryReviewHeaderContentParameter) {
    return feedRepository.countryDeliveryReviewHeaderContent(countryDeliveryReviewHeaderContentParameter);
  }
}