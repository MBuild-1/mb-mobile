import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../icon_title_and_description_list_item.dart';
import '../modified_divider.dart';
import '../modified_svg_picture.dart';
import '../titleanddescriptionitem/title_and_description_item.dart';

class ProfileMenuInCardItem extends StatelessWidget {
  final VoidCallback? onTap;
  final WidgetBuilder? icon;
  final String title;
  final TitleInterceptor? titleInterceptor;
  final String? description;
  final DescriptionInterceptor? descriptionInterceptor;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final bool withSeparator;

  const ProfileMenuInCardItem({
    Key? key,
    this.onTap,
    this.icon,
    required this.title,
    this.titleInterceptor,
    this.description,
    this.descriptionInterceptor,
    this.color,
    this.padding,
    required this.withSeparator
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
    EdgeInsetsGeometry? effectivePadding = padding ?? const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: IconTitleAndDescriptionListItem(
          title: title,
          description: description,
          titleInterceptor: (title, titleTextStyle) {
            if (titleInterceptor != null) {
              return titleInterceptor!(title, const TextStyle());
            }
            return Text(
              title,
              style: const TextStyle()
            );
          },
          descriptionInterceptor: (description, descriptionTextStyle) {
            if (descriptionInterceptor != null) {
              return descriptionInterceptor!(description, const TextStyle(color: Colors.grey));
            }
            return Text(
              description,
              style: const TextStyle(color: Colors.grey)
            );
          },
          titleAndDescriptionItemInterceptor: (_, title, titleWidget, description, descriptionWidget, titleAndDescriptionWidget, titleAndDescriptionWidgetList) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (withSeparator) ...[
                  const ModifiedDivider(),
                ],
                Padding(
                  padding: () {
                    if (effectivePadding is EdgeInsets) {
                      return effectivePadding.copyWith(left: 0.0);
                    } else {
                      return effectivePadding;
                    }
                  }(),
                  child: titleAndDescriptionWidget
                )
              ]
            );
          },
          iconTitleAndDescriptionItemInterceptor: (icon, titleAndDescription, iconTitleAndDescriptionWidget) {
            return Padding(
              padding: () {
                if (effectivePadding is EdgeInsets) {
                  return effectivePadding.copyWith(top: 0.0, bottom: 0.0, right: 0.0);
                } else {
                  return effectivePadding;
                }
              }(),
              child: iconTitleAndDescriptionWidget
            );
          },
          space: 10.0,
          verticalSpace: (0.5).h,
          icon: effectiveIcon,
        )
      ),
    );
  }
}