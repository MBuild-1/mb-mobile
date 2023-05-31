import '../domain/entity/componententity/i_component_entity.dart';
import '../domain/entity/delivery/country_delivery_review.dart';
import '../domain/entity/delivery/country_delivery_review_paging_parameter.dart';
import '../domain/entity/delivery/countrydeliveryreviewmedia/country_delivery_review_media.dart';
import '../domain/entity/delivery/countrydeliveryreviewmedia/country_delivery_review_media_paging_parameter.dart';
import '../domain/usecase/get_country_delivery_review_media_paging_use_case.dart';
import '../domain/usecase/get_country_delivery_review_paging_use_case.dart';
import '../misc/load_data_result.dart';
import '../misc/paging/pagingresult/paging_data_result.dart';
import 'base_getx_controller.dart';

class CountryDeliveryReviewController extends BaseGetxController {
  final GetCountryDeliveryReviewPagingUseCase getCountryDeliveryReviewPagingUseCase;
  final GetCountryDeliveryReviewMediaPagingUseCase getCountryDeliveryReviewMediaPagingUseCase;

  CountryDeliveryReviewController(
    super.controllerManager,
    this.getCountryDeliveryReviewPagingUseCase,
    this.getCountryDeliveryReviewMediaPagingUseCase
  );

  Future<LoadDataResult<PagingDataResult<CountryDeliveryReview>>> getCountryDeliveryReview(CountryDeliveryReviewPagingParameter countryDeliveryReviewPagingParameter) {
    return getCountryDeliveryReviewPagingUseCase.execute(countryDeliveryReviewPagingParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("country-delivery").value
    );
  }

  Future<LoadDataResult<PagingDataResult<CountryDeliveryReviewMedia>>> getCountryDeliveryReviewMedia(CountryDeliveryReviewMediaPagingParameter countryDeliveryReviewMediaPagingParameter) {
    return getCountryDeliveryReviewMediaPagingUseCase.execute(countryDeliveryReviewMediaPagingParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("country-delivery-review-media").value
    );
  }

  IComponentEntity getCountryDeliveryReviewHeader() {

  }

  IComponentEntity getCountryDeliveryReviewMediaShortContent() {

  }
}