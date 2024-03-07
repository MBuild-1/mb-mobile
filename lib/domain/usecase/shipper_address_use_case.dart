import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/address/shipper_address.dart';
import '../entity/address/shipper_address_parameter.dart';
import '../repository/address_repository.dart';

class ShipperAddressUseCase {
  final AddressRepository addressRepository;

  const ShipperAddressUseCase({
    required this.addressRepository
  });

  FutureProcessing<LoadDataResult<ShipperAddress>> execute(ShipperAddressParameter shipperAddressParameter) {
    return addressRepository.shippingAddress(shipperAddressParameter);
  }
}