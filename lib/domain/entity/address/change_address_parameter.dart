class ChangeAddressParameter {
  String addressId;
  String name;
  String email;
  String label;
  String address;
  String? address2;
  String phoneNumber;
  String zipCode;
  String countryId;
  String city;
  String state;

  ChangeAddressParameter({
    required this.addressId,
    required this.name,
    required this.email,
    required this.label,
    required this.address,
    this.address2,
    required this.phoneNumber,
    required this.zipCode,
    required this.countryId,
    required this.city,
    required this.state
  });
}