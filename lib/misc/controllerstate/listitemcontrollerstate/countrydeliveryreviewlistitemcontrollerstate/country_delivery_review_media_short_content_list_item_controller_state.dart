import '../../../../domain/entity/delivery/countrydeliveryreviewmedia/country_delivery_review_media.dart';
import '../../../load_data_result.dart';
import '../../../paging/pagingresult/paging_data_result.dart';
import '../list_item_controller_state.dart';

class CountryDeliveryReviewMediaShortContentListItemControllerState extends ListItemControllerState {
  LoadDataResult<PagingDataResult<CountryDeliveryReviewMedia>> countryDeliveryReviewMediaPagingLoadDataResult;

  CountryDeliveryReviewMediaShortContentListItemControllerState({
    required this.countryDeliveryReviewMediaPagingLoadDataResult
  });
}