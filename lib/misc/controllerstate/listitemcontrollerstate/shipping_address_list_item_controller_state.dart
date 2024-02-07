import '../../../domain/entity/address/address.dart';
import '../../errorprovider/error_provider.dart';
import '../../load_data_result.dart';
import 'list_item_controller_state.dart';

class ShippingAddressListItemControllerState extends ListItemControllerState {
  LoadDataResult<Address> shippingLoadDataResult;
  ErrorProvider Function() errorProvider;

  ShippingAddressListItemControllerState({
    required this.shippingLoadDataResult,
    required this.errorProvider
  });
}