import '../../../presentation/widget/colorful_chip_tab_bar.dart';
import 'list_item_controller_state.dart';

class ColorfulChipTabBarListItemControllerState extends ListItemControllerState {
  final List<ColorfulChipTabBarData> colorfulChipTabBarDataList;
  final BaseColorfulChipTabBarController colorfulChipTabBarController;
  final bool isWrap;
  final bool? canSelectAndUnselect;

  ColorfulChipTabBarListItemControllerState({
    required this.colorfulChipTabBarDataList,
    required this.colorfulChipTabBarController,
    this.isWrap = true,
    this.canSelectAndUnselect
  });
}

class ShimmerColorfulChipTabBarListItemControllerState extends ListItemControllerState {}