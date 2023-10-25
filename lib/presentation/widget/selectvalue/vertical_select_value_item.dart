import 'select_value_item.dart';

class VerticalSelectValueItem extends SelectValueItem {
  @override
  double? get itemWidth => null;

  const VerticalSelectValueItem({
    super.key,
    required super.value,
    required super.isSelected,
    super.onSelectValue,
    super.onConvertToStringForItemText
  });
}