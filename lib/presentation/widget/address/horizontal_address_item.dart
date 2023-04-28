import 'address_item.dart';

class HorizontalAddressItem extends AddressItem {
  @override
  double? get itemWidth => null;

  const HorizontalAddressItem({
    super.key,
    required super.address,
    super.onSelectAddress
  });
}