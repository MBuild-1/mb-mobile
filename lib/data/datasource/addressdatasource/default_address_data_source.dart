import 'package:dio/dio.dart';
import 'package:masterbagasi/data/entitymappingext/address_entity_mapping_ext.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/response_wrapper_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../../domain/dummy/addressdummy/address_dummy.dart';
import '../../../domain/entity/address/add_address_parameter.dart';
import '../../../domain/entity/address/add_address_response.dart';
import '../../../domain/entity/address/address.dart';
import '../../../domain/entity/address/address_based_id_parameter.dart';
import '../../../domain/entity/address/address_list_parameter.dart';
import '../../../domain/entity/address/address_paging_parameter.dart';
import '../../../domain/entity/address/change_address_parameter.dart';
import '../../../domain/entity/address/change_address_response.dart';
import '../../../domain/entity/address/country.dart';
import '../../../domain/entity/address/country_list_parameter.dart';
import '../../../domain/entity/address/country_paging_parameter.dart';
import '../../../domain/entity/address/current_selected_address_parameter.dart';
import '../../../domain/entity/address/current_selected_address_response.dart';
import '../../../domain/entity/address/remove_address_parameter.dart';
import '../../../domain/entity/address/remove_address_response.dart';
import '../../../domain/entity/address/shipper_address.dart';
import '../../../domain/entity/address/shipper_address_parameter.dart';
import '../../../domain/entity/address/update_current_selected_address_parameter.dart';
import '../../../domain/entity/address/update_current_selected_address_response.dart';
import '../../../domain/entity/delivery/country_based_country_code_parameter.dart';
import '../../../domain/entity/delivery/country_based_country_code_response.dart';
import '../../../domain/entity/delivery/country_based_id_parameter.dart';
import '../../../domain/entity/delivery/country_based_id_response.dart';
import '../../../misc/constant.dart';
import '../../../misc/error_helper.dart';
import '../../../misc/option_builder.dart';
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
    return DioHttpClientProcessing((cancelToken) async {
      try {
        return await (
          dio.get("/user/address", queryParameters: {"isPrimary": 1}, cancelToken: cancelToken)
            .map<CurrentSelectedAddressResponse>(
              onMap: (value) => CurrentSelectedAddressResponse(
                address: value.wrapResponse().mapFromResponseToAddress()
              )
            )
        );
      } on DioError catch (e) {
        throw ErrorHelper.generatePleaseLoginFirstDioError(e);
      } catch (e) {
        rethrow;
      }
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

  @override
  FutureProcessing<AddAddressResponse> addAddress(AddAddressParameter addAddressParameter) {
    FormData formData = FormData.fromMap(
      <String, dynamic> {
        "name": addAddressParameter.name,
        "email": addAddressParameter.email,
        "label": addAddressParameter.label,
        "address": addAddressParameter.address,
        if (addAddressParameter.address2.isNotEmptyString) "address2": addAddressParameter.address2,
        "phone_number": addAddressParameter.phoneNumber,
        "zip_code": addAddressParameter.zipCode,
        "country_id": addAddressParameter.countryId,
        "city": addAddressParameter.city,
        "state": addAddressParameter.state,
      }
    );
    return DioHttpClientProcessing((cancelToken) {
      return dio.post("/user/address", data: formData, cancelToken: cancelToken, options: OptionsBuilder.multipartData().build())
        .map<AddAddressResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToAddAddressResponse());
    });
  }

  @override
  FutureProcessing<ChangeAddressResponse> changeAddress(ChangeAddressParameter changeAddressParameter) {
    dynamic formData = <String, dynamic>{
      "name": changeAddressParameter.name,
      "email": changeAddressParameter.email,
      "label": changeAddressParameter.label,
      "address": changeAddressParameter.address,
      if (changeAddressParameter.address2.isEmptyString) ...{
        "address2": null,
      } else ...{
        "address2": changeAddressParameter.address2.toEmptyStringNonNull,
      },
      "phone_number": changeAddressParameter.phoneNumber,
      "zip_code": changeAddressParameter.zipCode,
      "country_id": changeAddressParameter.countryId,
      "city": changeAddressParameter.city,
      "state": changeAddressParameter.state,
    };
    return DioHttpClientProcessing((cancelToken) {
      return dio.put("/user/address/${changeAddressParameter.addressId}", data: formData, cancelToken: cancelToken)
        .map<ChangeAddressResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToChangeAddressResponse());
    });
  }

  @override
  FutureProcessing<RemoveAddressResponse> removeAddress(RemoveAddressParameter removeAddressParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.delete("/user/address/${removeAddressParameter.addressId}", cancelToken: cancelToken)
        .map<RemoveAddressResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToRemoveAddressResponse());
    });
  }

  @override
  FutureProcessing<Address> addressBasedId(AddressBasedIdParameter addressBasedIdParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/user/address/${addressBasedIdParameter.addressId}", cancelToken: cancelToken)
        .map<Address>(onMap: (value) => value.wrapResponse().mapFromResponseToAddress());
    });
  }

  @override
  FutureProcessing<ShipperAddress> shipperAddress(ShipperAddressParameter shippingAddressParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/user/order/shipper/address", cancelToken: cancelToken)
        .map<ShipperAddress>(onMap: (value) => value.wrapResponse().mapFromResponseToShipperAddress());
    });
  }

  @override
  FutureProcessing<CountryBasedCountryCodeResponse> countryBasedCountryCode(CountryBasedCountryCodeParameter countryBasedCountryCodeParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/country/code/${countryBasedCountryCodeParameter.countryCode}", cancelToken: cancelToken)
        .map<CountryBasedCountryCodeResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToCountryBasedCountryCodeResponse());
    });
  }

  @override
  FutureProcessing<CountryBasedIdResponse> countryBasedId(CountryBasedIdParameter countryBasedIdParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/country/${countryBasedIdParameter.countryId}", cancelToken: cancelToken)
        .map<CountryBasedIdResponse>(onMap: (value) => value.wrapResponse().mapFromResponseCountryBasedIdResponse());
    });
  }
}