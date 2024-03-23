import 'package:flutter/material.dart';

class AppBarIconButton extends StatelessWidget {
  final Widget icon;
  final Widget? overlay;
  final double? size;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;
  final void Function()? onTap;
  final bool isClippedOverlay;

  const AppBarIconButton({
    super.key,
    required this.icon,
    this.overlay,
    this.size,
    this.iconSize,
    this.padding,
    this.onTap,
    this.isClippedOverlay = false
  });

  @override
  Widget build(BuildContext context) {
    double effectiveIconSize = iconSize ?? 23;
    Widget result = SizedBox(
      width: size,
      height: size,
      child: Material(
        borderRadius: BorderRadius.circular(8.0),
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: padding,
            child: SizedBox(
              width: effectiveIconSize,
              height: effectiveIconSize,
              child: icon,
            )
          )
        )
      ),
    );
    return overlay != null ? ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Stack(
        children: [
          result,
          overlay!
        ]
      )
    ) : result;
  }
}