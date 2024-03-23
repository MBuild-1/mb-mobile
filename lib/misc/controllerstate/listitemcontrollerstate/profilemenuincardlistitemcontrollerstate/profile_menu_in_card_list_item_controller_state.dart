import 'package:flutter/material.dart';

import '../../../../presentation/widget/titleanddescriptionitem/title_and_description_item.dart';
import '../list_item_controller_state.dart';

class ProfileMenuInCardListItemControllerState extends ListItemControllerState {
  void Function()? onTap;
  WidgetBuilder? icon;
  String title;
  TitleInterceptor? titleInterceptor;
  String? description;
  DescriptionInterceptor? descriptionInterceptor;
  Color? color;
  EdgeInsetsGeometry? padding;
  bool withSeparator;

  ProfileMenuInCardListItemControllerState({
    required this.onTap,
    required this.icon,
    required this.title,
    this.titleInterceptor,
    this.description,
    this.descriptionInterceptor,
    this.color,
    this.padding,
    this.withSeparator = false
  });
}