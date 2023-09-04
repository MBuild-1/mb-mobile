import '../../../../domain/entity/province/province_map.dart';
import '../../../../presentation/widget/province/province_item.dart';
import '../list_item_controller_state.dart';

abstract class ProvinceListItemControllerState extends ListItemControllerState {
  ProvinceMap province;
  bool isSelected;
  OnSelectProvince? onSelectProvince;

  ProvinceListItemControllerState({
    required this.province,
    required this.isSelected,
    this.onSelectProvince
  });
}