import '../../misc/load_data_result.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/address/address.dart';
import '../entity/address/address_list_parameter.dart';
import '../entity/address/address_paging_parameter.dart';
import '../entity/address/country.dart';
import '../entity/address/country_list_parameter.dart';
import '../entity/address/country_paging_parameter.dart';
import '../entity/address/current_selected_address_parameter.dart';
import '../entity/address/current_selected_address_response.dart';
import '../entity/address/update_current_selected_address_parameter.dart';
import '../entity/address/update_current_selected_address_response.dart';

abstract class AddressRepository {
  FutureProcessing<LoadDataResult<CurrentSelectedAddressResponse>> currentSelectedAddress(CurrentSelectedAddressParameter currentSelectedAddressParameter);
  FutureProcessing<LoadDataResult<PagingDataResult<Address>>> addressPaging(AddressPagingParameter addressPagingParameter);
  FutureProcessing<LoadDataResult<List<Address>>> addressList(AddressListParameter addressListParameter);
  FutureProcessing<LoadDataResult<UpdateCurrentSelectedAddressResponse>> updateCurrentSelectedAddress(UpdateCurrentSelectedAddressParameter updateCurrentSelectedAddressParameter);
  FutureProcessing<LoadDataResult<List<Country>>> countryList(CountryListParameter countryListParameter);
  FutureProcessing<LoadDataResult<PagingDataResult<Country>>> countryPaging(CountryPagingParameter countryPagingParameter);
}