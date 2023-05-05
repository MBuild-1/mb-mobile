/*"id": "0fd95e66-b71b-4e38-9182-856d496ad297",
"user_id": "c617c55c-e4b5-4815-b0de-b422b78434b7",
"label": "kantor",
"country_id": "60e63795-a3f9-4f7f-a4c0-fd4d98e01f13",
"is_primary": 0,
"address": "jl. raya perjuangan no .2",
"phone_number": "+ 08 611 111111111",
"zip_code": "03000",
"user": {
    "id": "c617c55c-e4b5-4815-b0de-b422b78434b7",
    "name": "Test 1",
    "role": 0,
    "email": "user1@masterbagasi.com",
    "email_verified_at": null
},
"country": {
    "id": "60e63795-a3f9-4f7f-a4c0-fd4d98e01f13",
    "zone_id": "c455c895-94eb-4607-a54a-08cb7d78164c",
    "name": "ALGERIA",
    "code": "DZ",
    "zone": {
        "id": "c455c895-94eb-4607-a54a-08cb7d78164c",
        "name": "Zone 8",
        "code": "8"
    }
}*/

import 'package:masterbagasi/misc/ext/response_wrapper_ext.dart';

import '../../domain/entity/address/address.dart';
import '../../domain/entity/address/address_user.dart';
import '../../domain/entity/address/country.dart';
import '../../domain/entity/address/update_current_selected_address_response.dart';
import '../../domain/entity/address/zone.dart';
import '../../misc/constant.dart';
import '../../misc/error/message_error.dart';
import '../../misc/multi_language_string.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/response_wrapper.dart';

extension AddressEntityMappingExt on ResponseWrapper {
  List<Address> mapFromResponseToAddressList() {
    return response.map<Address>((addressResponse) => ResponseWrapper(addressResponse).mapFromResponseToAddress()).toList();
  }

  PagingDataResult<Address> mapFromResponseToAddressPaging() {
    return ResponseWrapper(response).mapFromResponseToPagingDataResult(
      (dataResponse) => dataResponse.map<Address>(
        (productBrandResponse) => ResponseWrapper(productBrandResponse).mapFromResponseToAddress()
      ).toList()
    );
  }
}

extension AddressDetailEntityMappingExt on ResponseWrapper {
  Address mapFromResponseToAddress() {
    if (response == null) {
      throw MultiLanguageMessageError(
        title: MultiLanguageString({
          Constant.textEnUsLanguageKey: "No address selected.",
          Constant.textInIdLanguageKey: "Tidak ada alamat dipilih."
        })
      );
    }
    return Address(
      id: response["id"],
      userId: response["user_id"],
      label: response["label"],
      countryId: response["country_id"],
      isPrimary: response["is_primary"],
      address: response["address"],
      phoneNumber: response["phone_number"],
      zipCode: response["zip_code"],
      addressUser: response["user"] != null ? ResponseWrapper(response["user"]).mapFromResponseToAddressUser() : null,
      country: ResponseWrapper(response["country"]).mapFromResponseToCountry(),
    );
  }

  AddressUser mapFromResponseToAddressUser() {
    return AddressUser(
      id: response["id"],
      name: response["name"],
      role: response["role"],
      email: response["email"],
    );
  }

  Country mapFromResponseToCountry() {
    return Country(
      id: response["id"],
      zoneId: response["zone_id"],
      name: response["name"],
      code: response["code"],
      zone: ResponseWrapper(response["zone"]).mapFromResponseToZone()
    );
  }

  Zone mapFromResponseToZone() {
    return Zone(
      id: response["id"],
      name: response["name"],
      code: response["code"]
    );
  }

  UpdateCurrentSelectedAddressResponse mapFromResponseToUpdateCurrentSelectedAddressResponse() {
    return UpdateCurrentSelectedAddressResponse();
  }
}