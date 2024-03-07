import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/delivery/country_based_country_code_parameter.dart';
import '../entity/delivery/country_based_country_code_response.dart';
import '../repository/address_repository.dart';

class GetCountryBasedCountryCodeUseCase {
  final AddressRepository addressRepository;

  const GetCountryBasedCountryCodeUseCase({
    required this.addressRepository
  });

  FutureProcessing<LoadDataResult<CountryBasedCountryCodeResponse>> execute(CountryBasedCountryCodeParameter countryBasedCountryCodeParameter) {
    return addressRepository.countryBasedCountryCode(countryBasedCountryCodeParameter);
  }
}