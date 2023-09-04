import 'province_item.dart';

class VerticalProvinceItem extends ProvinceItem {
  @override
  double? get itemWidth => null;

  const VerticalProvinceItem({
    super.key,
    required super.province,
    required super.isSelected,
    super.onSelectProvince,
  });
}