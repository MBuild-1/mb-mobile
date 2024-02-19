import '../../domain/entity/address/address.dart';
import '../../domain/entity/order/order_address.dart';

extension OrderAddressExt on OrderAddress? {
  Address? toAddress() {
    if (this == null) {
      return null;
    }
    return Address(
      id: "",
      email: this!.email,
      name: this!.name,
      userId: "",
      label: this!.label,
      countryId: this!.countryId,
      isPrimary: 0,
      address: this!.address,
      address2: this!.address2,
      phoneNumber: this!.phoneNumber,
      zipCode: this!.zipCode,
      city: this!.city,
      state: this!.state,
      country: this!.country,
      addressUser: null
    );
  }
}