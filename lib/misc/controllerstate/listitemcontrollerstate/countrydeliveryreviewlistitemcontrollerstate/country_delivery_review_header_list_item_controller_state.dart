import '../../../../domain/entity/address/country.dart';
import '../../../load_data_result.dart';
import '../list_item_controller_state.dart';

class CountryDeliveryReviewHeaderListItemControllerState extends ListItemControllerState {
  LoadDataResult<Country> countryLoadDataResult;

  CountryDeliveryReviewHeaderListItemControllerState({
    required this.countryLoadDataResult
  });
}