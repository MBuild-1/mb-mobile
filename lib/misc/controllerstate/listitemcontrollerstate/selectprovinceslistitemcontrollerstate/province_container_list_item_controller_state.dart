import '../../../../domain/entity/province/province_map.dart';
import '../../../../presentation/widget/province/province_item.dart';
import '../list_item_controller_state.dart';

typedef OnGetSelectProvince = ProvinceMap? Function();

class ProvinceContainerListItemControllerState extends ListItemControllerState {
  List<ProvinceMap> province;
  OnSelectProvince? onSelectProvince;
  OnGetSelectProvince? onGetSelectProvince;
  void Function() onUpdateState;

  ProvinceContainerListItemControllerState({
    required this.province,
    this.onSelectProvince,
    this.onGetSelectProvince,
    required this.onUpdateState
  });
}