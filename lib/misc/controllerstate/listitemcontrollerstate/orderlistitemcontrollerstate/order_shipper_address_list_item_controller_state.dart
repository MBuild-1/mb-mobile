import '../../../../domain/entity/address/shipper_address.dart';
import '../../../errorprovider/error_provider.dart';
import '../../../load_data_result.dart';
import '../list_item_controller_state.dart';

class OrderShipperAddressListItemControllerState extends ListItemControllerState {
  LoadDataResult<ShipperAddress> shipperAddressLoadDataResult;
  ErrorProvider Function() errorProvider;

  OrderShipperAddressListItemControllerState({
    required this.shipperAddressLoadDataResult,
    required this.errorProvider
  });
}