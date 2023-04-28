import '../../domain/entity/address/address.dart';
import '../../domain/entity/address/address_list_parameter.dart';
import '../../domain/entity/address/address_paging_parameter.dart';
import '../../domain/entity/address/current_selected_address_parameter.dart';
import '../../domain/entity/address/current_selected_address_response.dart';
import '../../domain/entity/address/update_current_selected_address_parameter.dart';
import '../../domain/entity/address/update_current_selected_address_response.dart';
import '../../domain/repository/address_repository.dart';
import '../../misc/load_data_result.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
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

  @override
  FutureProcessing<LoadDataResult<PagingDataResult<Address>>> addressPaging(AddressPagingParameter addressPagingParameter) {
    return addressDataSource.addressPaging(addressPagingParameter).mapToLoadDataResult<PagingDataResult<Address>>();
  }

  @override
  FutureProcessing<LoadDataResult<List<Address>>> addressList(AddressListParameter addressListParameter) {
    return addressDataSource.addressList(addressListParameter).mapToLoadDataResult<List<Address>>();
  }

  @override
  FutureProcessing<LoadDataResult<UpdateCurrentSelectedAddressResponse>> updateCurrentSelectedAddress(UpdateCurrentSelectedAddressParameter updateCurrentSelectedAddressParameter) {
    return addressDataSource.updateCurrentSelectedAddress(updateCurrentSelectedAddressParameter).mapToLoadDataResult<UpdateCurrentSelectedAddressResponse>();
  }
}