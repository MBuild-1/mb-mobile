import '../../../../domain/entity/delivery/country_delivery_review.dart';
import '../../../errorprovider/error_provider.dart';
import '../list_item_controller_state.dart';

class CountryDeliveryReviewContainerListItemControllerState extends ListItemControllerState {
  List<CountryDeliveryReview> countryDeliveryReviewList;
  void Function() onUpdateState;
  ErrorProvider errorProvider;
  ListItemControllerState Function() getCountryDeliveryReviewHeaderListItemControllerState;
  ListItemControllerState Function() getCountryDeliveryReviewMediaShortContentListItemControllerState;

  CountryDeliveryReviewContainerListItemControllerState({
    required this.countryDeliveryReviewList,
    required this.onUpdateState,
    required this.errorProvider,
    required this.getCountryDeliveryReviewHeaderListItemControllerState,
    required this.getCountryDeliveryReviewMediaShortContentListItemControllerState
  });
}