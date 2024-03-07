import '../address/country.dart';

class OrderAddress {
  String id;
  String combinedOrderId;
  String countryId;
  String label;
  String address;
  String phoneNumber;
  String zipCode;
  String city;
  String state;
  String name;
  String email;
  String? address2;
  Country country;

  OrderAddress({
    required this.id,
    required this.combinedOrderId,
    required this.countryId,
    required this.label,
    required this.address,
    required this.phoneNumber,
    required this.zipCode,
    required this.city,
    required this.state,
    required this.name,
    required this.email,
    required this.address2,
    required this.country
  });
}