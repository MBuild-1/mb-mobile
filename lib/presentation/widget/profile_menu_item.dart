import 'package:flutter/material.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:sizer/sizer.dart';

import 'icon_title_and_description_list_item.dart';
import 'modified_svg_picture.dart';

class ProfileMenuItem extends StatelessWidget {
  final VoidCallback? onTap;
  final WidgetBuilder? icon;
  final String title;
  final String? description;
  final Color? color;
  final EdgeInsetsGeometry? padding;

  const ProfileMenuItem({
    Key? key,
    this.onTap,
    this.icon,
    required this.title,
    this.description,
    this.color,
    this.padding
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget? effectiveIcon;
    if (icon != null) {
      effectiveIcon = icon!(context);
    }
    if (effectiveIcon is ModifiedSvgPicture && color != null) {
      effectiveIcon = effectiveIcon.copy(color: color);
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: padding ?? EdgeInsets.all(4.w),
          child: IconTitleAndDescriptionListItem(
            title: title,
            description: description,
            titleInterceptor: (title, titleTextStyle) {
              return Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold)
              );
            },
            descriptionInterceptor: (description, descriptionTextStyle) {
              return Text(
                description,
                style: const TextStyle(color: Colors.grey)
              );
            },
            space: 4.w,
            verticalSpace: (0.5).h,
            icon: effectiveIcon,
          )
        ),
      ),
    );
  }
}