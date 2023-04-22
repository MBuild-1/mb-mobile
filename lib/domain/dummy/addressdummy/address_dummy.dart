import '../../entity/address/address.dart';
import 'country_dummy.dart';

class AddressDummy {
  CountryDummy countryDummy;

  AddressDummy({
    required this.countryDummy
  });

  Address generateShimmerDummy() {
    return Address(
      id: "",
      userId: "",
      label: "",
      countryId: "",
      isPrimary: 1,
      address: "",
      phoneNumber: "",
      zipCode: "",
      country: countryDummy.generateShimmerDummy()
    );
  }

  Address generateDefaultDummy() {
    return Address(
      id: "1e448fe8-4dbe-4315-a7d6-381c7e5a37d0",
      userId: "c617c55c-e4b5-4815-b0de-b422b78434b7",
      label: "Address 2",
      countryId: "19e0e323-35b2-445c-9a0a-6c62fa9ee8d4",
      isPrimary: 1,
      address: "Street 2",
      phoneNumber: "08512412521532",
      zipCode: "16517",
      country: countryDummy.generateShimmerDummy()
    );
  }
}