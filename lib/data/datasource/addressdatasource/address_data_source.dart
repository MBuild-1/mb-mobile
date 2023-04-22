import '../../../domain/entity/address/current_selected_address_parameter.dart';
import '../../../domain/entity/address/current_selected_address_response.dart';
import '../../../misc/processing/future_processing.dart';

abstract class AddressDataSource {
  FutureProcessing<CurrentSelectedAddressResponse> currentSelectedAddress(CurrentSelectedAddressParameter currentSelectedAddressParameter);
}