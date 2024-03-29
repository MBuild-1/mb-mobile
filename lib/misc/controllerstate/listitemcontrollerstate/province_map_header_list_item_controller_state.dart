import '../../../domain/entity/province/province_map.dart';
import 'list_item_controller_state.dart';

class ProvinceMapHeaderListItemControllerState extends ListItemControllerState {
  ProvinceMap provinceMap;
  void Function(ProvinceMap)? onSelectProvince;

  ProvinceMapHeaderListItemControllerState({
    required this.provinceMap,
    this.onSelectProvince
  });
}