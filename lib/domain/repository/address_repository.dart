import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/address/current_selected_address_parameter.dart';
import '../entity/address/current_selected_address_response.dart';

abstract class AddressRepository {
  FutureProcessing<LoadDataResult<CurrentSelectedAddressResponse>> currentSelectedAddress(CurrentSelectedAddressParameter currentSelectedAddressParameter);
}