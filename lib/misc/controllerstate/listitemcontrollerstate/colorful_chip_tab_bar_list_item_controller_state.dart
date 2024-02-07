import 'package:flutter/material.dart';
import '../../../presentation/widget/colorful_chip_tab_bar.dart';
import 'list_item_controller_state.dart';

class ColorfulChipTabBarListItemControllerState extends ListItemControllerState {
  final List<ColorfulChipTabBarData> colorfulChipTabBarDataList;
  final BaseColorfulChipTabBarController colorfulChipTabBarController;
  final bool isWrap;
  final bool? canSelectAndUnselect;
  final Widget? Function(TextStyle?, ColorfulChipTabBarData)? chipLabelInterceptor;
  final Widget Function(ColorfulChipTabBarInterceptorParameter)? colorfulChipTabBarInterceptor;

  ColorfulChipTabBarListItemControllerState({
    required this.colorfulChipTabBarDataList,
    required this.colorfulChipTabBarController,
    this.isWrap = true,
    this.canSelectAndUnselect,
    this.chipLabelInterceptor,
    this.colorfulChipTabBarInterceptor
  });
}

class ShimmerColorfulChipTabBarListItemControllerState extends ListItemControllerState {}