import '../../domain/entity/address/current_selected_address_parameter.dart';
import '../../domain/entity/address/current_selected_address_response.dart';
import '../../domain/repository/address_repository.dart';
import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../datasource/addressdatasource/address_data_source.dart';

class DefaultAddressRepository implements AddressRepository {
  final AddressDataSource addressDataSource;

  const DefaultAddressRepository({
    required this.addressDataSource
  });

  @override
  FutureProcessing<LoadDataResult<CurrentSelectedAddressResponse>> currentSelectedAddress(CurrentSelectedAddressParameter currentSelectedAddressParameter) {
    return addressDataSource.currentSelectedAddress(currentSelectedAddressParameter).mapToLoadDataResult<CurrentSelectedAddressResponse>();
  }
}