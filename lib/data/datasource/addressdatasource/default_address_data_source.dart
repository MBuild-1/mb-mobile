import 'package:dio/dio.dart';

import '../../../domain/dummy/addressdummy/address_dummy.dart';
import '../../../domain/entity/address/current_selected_address_parameter.dart';
import '../../../domain/entity/address/current_selected_address_response.dart';
import '../../../misc/processing/dummy_future_processing.dart';
import '../../../misc/processing/future_processing.dart';
import 'address_data_source.dart';

class DefaultAddressDataSource implements AddressDataSource {
  final Dio dio;
  final AddressDummy addressDummy;

  const DefaultAddressDataSource({
    required this.dio,
    required this.addressDummy
  });

  @override
  FutureProcessing<CurrentSelectedAddressResponse> currentSelectedAddress(CurrentSelectedAddressParameter currentSelectedAddressParameter) {
    return DummyFutureProcessing((parameter) async {
      await Future.delayed(const Duration(seconds: 1));
      return CurrentSelectedAddressResponse(
        address: addressDummy.generateDefaultDummy()
      );
    });
  }
}