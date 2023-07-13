import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../domain/entity/componententity/dynamic_item_carousel_directly_component_entity.dart';
import '../domain/entity/componententity/i_component_entity.dart';
import '../domain/entity/delivery/country_delivery_review.dart';
import '../domain/entity/delivery/country_delivery_review_header_content.dart';
import '../domain/entity/delivery/country_delivery_review_header_content_parameter.dart';
import '../domain/entity/delivery/country_delivery_review_paging_parameter.dart';
import '../domain/entity/delivery/countrydeliveryreviewmedia/country_delivery_review_media.dart';
import '../domain/entity/delivery/countrydeliveryreviewmedia/country_delivery_review_media_paging_parameter.dart';
import '../domain/usecase/get_country_delivery_review_header_content_use_case.dart';
import '../domain/usecase/get_country_delivery_review_media_paging_use_case.dart';
import '../domain/usecase/get_country_delivery_review_paging_use_case.dart';
import '../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../misc/error/message_error.dart';
import '../misc/load_data_result.dart';
import '../misc/multi_language_string.dart';
import '../misc/paging/pagingresult/paging_data_result.dart';
import 'base_getx_controller.dart';

class CountryDeliveryReviewController extends BaseGetxController {
  final GetCountryDeliveryReviewPagingUseCase getCountryDeliveryReviewPagingUseCase;
  final GetCountryDeliveryReviewMediaPagingUseCase getCountryDeliveryReviewMediaPagingUseCase;
  final GetCountryDeliveryReviewHeaderContentUseCase getCountryDeliveryReviewHeaderContentUseCase;
  CountryDeliveryReviewSubDelegate? _countryDeliveryReviewSubDelegate;

  CountryDeliveryReviewController(
    super.controllerManager,
    this.getCountryDeliveryReviewPagingUseCase,
    this.getCountryDeliveryReviewMediaPagingUseCase,
    this.getCountryDeliveryReviewHeaderContentUseCase
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

  IComponentEntity getCountryDeliveryReviewHeader(String countryId) {
    return DynamicItemCarouselDirectlyComponentEntity(
      title: MultiLanguageString(""),
      onDynamicItemAction: (title, description, observer) async {
        observer(title, description, IsLoadingLoadDataResult<CountryDeliveryReviewHeaderContent>());
        LoadDataResult<CountryDeliveryReviewHeaderContent> countryDeliveryReviewHeaderContentLoadDataResult = await getCountryDeliveryReviewHeaderContentUseCase.execute(
          CountryDeliveryReviewHeaderContentParameter(countryId: countryId)
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPart("country-delivery-review-header-content").value
        );
        if (countryDeliveryReviewHeaderContentLoadDataResult.isFailedBecauseCancellation) {
          return;
        }
        observer(title, description, countryDeliveryReviewHeaderContentLoadDataResult);
      },
      observeDynamicItemActionStateDirectly: (title, description, itemLoadDataResult, errorProvider) {
        LoadDataResult<CountryDeliveryReviewHeaderContent> countryDeliveryReviewHeaderContentLoadDataResult = itemLoadDataResult.castFromDynamic<CountryDeliveryReviewHeaderContent>();
        if (_countryDeliveryReviewSubDelegate != null) {
          return _countryDeliveryReviewSubDelegate!.onObserveLoadCountryDeliveryReviewHeader(
            _OnObserveLoadCountryDeliveryReviewHeaderParameter(
              countryDeliveryReviewHeaderContentLoadDataResult: countryDeliveryReviewHeaderContentLoadDataResult
            )
          );
        } else {
          throw MessageError(title: "Country delivery review sub delegate must be not null");
        }
      },
    );
  }

  IComponentEntity getCountryDeliveryReviewMediaShortContent(String countryId) {
    return DynamicItemCarouselDirectlyComponentEntity(
      title: MultiLanguageString(""),
      onDynamicItemAction: (title, description, observer) async {
        observer(title, description, IsLoadingLoadDataResult<CountryDeliveryReviewMedia>());
        LoadDataResult<PagingDataResult<CountryDeliveryReviewMedia>> countryDeliveryReviewMediaPagingLoadDataResult = await getCountryDeliveryReviewMediaPagingUseCase.execute(
          CountryDeliveryReviewMediaPagingParameter(
            countryId: countryId,
            page: 1,
            itemEachPageCount: 5
          )
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPart("country-delivery-review-media-short-content").value
        );
        if (countryDeliveryReviewMediaPagingLoadDataResult.isFailedBecauseCancellation) {
          return;
        }
        observer(title, description, countryDeliveryReviewMediaPagingLoadDataResult);
      },
      observeDynamicItemActionStateDirectly: (title, description, itemLoadDataResult, errorProvider) {
        LoadDataResult<PagingDataResult<CountryDeliveryReviewMedia>> countryDeliveryReviewMediaPagingLoadDataResult = itemLoadDataResult.castFromDynamic<PagingDataResult<CountryDeliveryReviewMedia>>();
        if (_countryDeliveryReviewSubDelegate != null) {
          return _countryDeliveryReviewSubDelegate!.onObserveLoadCountryDeliveryReviewMediaShortContent(
            _OnObserveLoadCountryDeliveryReviewMediaShortContentParameter(
              countryDeliveryReviewMediaPagingLoadDataResult: countryDeliveryReviewMediaPagingLoadDataResult
            )
          );
        } else {
          throw MessageError(title: "Country delivery review sub delegate must be not null");
        }
      },
    );
  }

  CountryDeliveryReviewController setCountryDeliveryReviewSubDelegate(CountryDeliveryReviewSubDelegate countryDeliveryReviewSubDelegate) {
    _countryDeliveryReviewSubDelegate = countryDeliveryReviewSubDelegate;
    return this;
  }
}

class CountryDeliveryReviewSubDelegate {
  ListItemControllerState Function(_OnObserveLoadCountryDeliveryReviewHeaderParameter) onObserveLoadCountryDeliveryReviewHeader;
  ListItemControllerState Function(_OnObserveLoadCountryDeliveryReviewMediaShortContentParameter) onObserveLoadCountryDeliveryReviewMediaShortContent;

  CountryDeliveryReviewSubDelegate({
    required this.onObserveLoadCountryDeliveryReviewHeader,
    required this.onObserveLoadCountryDeliveryReviewMediaShortContent
  });
}

class _OnObserveLoadCountryDeliveryReviewHeaderParameter {
  LoadDataResult<CountryDeliveryReviewHeaderContent> countryDeliveryReviewHeaderContentLoadDataResult;

  _OnObserveLoadCountryDeliveryReviewHeaderParameter({
    required this.countryDeliveryReviewHeaderContentLoadDataResult
  });
}

class _OnObserveLoadCountryDeliveryReviewMediaShortContentParameter {
  LoadDataResult<PagingDataResult<CountryDeliveryReviewMedia>> countryDeliveryReviewMediaPagingLoadDataResult;

  _OnObserveLoadCountryDeliveryReviewMediaShortContentParameter({
    required this.countryDeliveryReviewMediaPagingLoadDataResult
  });
}