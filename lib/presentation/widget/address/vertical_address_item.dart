import 'address_item.dart';

class VerticalAddressItem extends AddressItem {
  @override
  double? get itemWidth => 180;

  const VerticalAddressItem({
    super.key,
    required super.address,
    super.onSelectAddress,
    super.onRemoveAddress
  });
}