import '../domain/entity/address/shipper_address.dart';
import 'load_data_result.dart';

class ShipperAddressProcessAdditionalParameter {
  LoadDataResult<ShipperAddress> shipperAddressLoadDataResult;

  ShipperAddressProcessAdditionalParameter({
    required this.shipperAddressLoadDataResult,
  });
}