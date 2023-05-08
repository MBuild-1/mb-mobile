import 'package:dio/dio.dart';
import 'package:masterbagasi/data/entitymappingext/address_entity_mapping_ext.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/response_wrapper_ext.dart';

import '../../../domain/dummy/addressdummy/address_dummy.dart';
import '../../../domain/entity/address/address.dart';
import '../../../domain/entity/address/address_list_parameter.dart';
import '../../../domain/entity/address/address_paging_parameter.dart';
import '../../../domain/entity/address/country.dart';
import '../../../domain/entity/address/country_list_parameter.dart';
import '../../../domain/entity/address/country_paging_parameter.dart';
import '../../../domain/entity/address/current_selected_address_parameter.dart';
import '../../../domain/entity/address/current_selected_address_response.dart';
import '../../../domain/entity/address/update_current_selected_address_parameter.dart';
import '../../../domain/entity/address/update_current_selected_address_response.dart';
import '../../../misc/paging/pagingresult/paging_data_result.dart';
import '../../../misc/processing/dio_http_client_processing.dart';
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
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/user/address", queryParameters: {"isPrimary": 1}, cancelToken: cancelToken)
        .map<CurrentSelectedAddressResponse>(
          onMap: (value) => CurrentSelectedAddressResponse(
            address: value.wrapResponse().mapFromResponseToAddress()
          )
        );
    });
  }

  @override
  FutureProcessing<PagingDataResult<Address>> addressPaging(AddressPagingParameter addressPagingParameter) {
    return DioHttpClientProcessing((cancelToken) {
      String pageParameterPath = "/?pageNumber=${addressPagingParameter.itemEachPageCount}&page=${addressPagingParameter.page}";
      return dio.get("/user/address$pageParameterPath", cancelToken: cancelToken)
        .map<PagingDataResult<Address>>(
          onMap: (value) => value.wrapResponse().mapFromResponseToAddressPaging()
      );
    });
  }

  @override
  FutureProcessing<List<Address>> addressList(AddressListParameter addressListParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/user/address", cancelToken: cancelToken)
        .map<List<Address>>(
          onMap: (value) => value.wrapResponse().mapFromResponseToAddressList()
        );
    });
  }

  @override
  FutureProcessing<UpdateCurrentSelectedAddressResponse> updateCurrentSelectedAddress(UpdateCurrentSelectedAddressParameter updateCurrentSelectedAddressParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.patch("/user/address/${updateCurrentSelectedAddressParameter.addressId}", cancelToken: cancelToken)
        .map<UpdateCurrentSelectedAddressResponse>(
          onMap: (value) => value.wrapResponse().mapFromResponseToUpdateCurrentSelectedAddressResponse()
        );
    });
  }

  @override
  FutureProcessing<List<Country>> countryList(CountryListParameter countryListParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/country", cancelToken: cancelToken)
        .map<List<Country>>(
          onMap: (value) => value.wrapResponse().mapFromResponseToCountryList()
        );
    });
  }

  @override
  FutureProcessing<PagingDataResult<Country>> countryPaging(CountryPagingParameter countryPagingParameter) {
    return DioHttpClientProcessing((cancelToken) {
      String pageParameterPath = "/?pageNumber=${countryPagingParameter.itemEachPageCount}&page=${countryPagingParameter.page}";
      return dio.get("/country$pageParameterPath", cancelToken: cancelToken)
        .map<PagingDataResult<Country>>(
          onMap: (value) => value.wrapResponse().mapFromResponseToCountryPaging()
      );
    });
  }
}