import 'address_user.dart';
import 'country.dart';
import 'zone.dart';

class Address {
  String id;
  String userId;
  String label;
  String countryId;
  int isPrimary;
  String address;
  String phoneNumber;
  String zipCode;
  Country country;
  AddressUser addressUser;

  Address({
    required this.id,
    required this.userId,
    required this.label,
    required this.countryId,
    required this.isPrimary,
    required this.address,
    required this.phoneNumber,
    required this.zipCode,
    required this.country,
    required this.addressUser
  });
}