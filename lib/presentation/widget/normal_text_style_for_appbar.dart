import 'package:flutter/material.dart';

class NormalTextStyleForAppBar extends StatelessWidget {
  final TextStyle? style;
  final TextAlign? textAlign;
  final bool? softWrap;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextWidthBasis? textWidthBasis;
  final Widget child;

  const NormalTextStyleForAppBar({
    super.key,
    this.style,
    this.textAlign,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.textWidthBasis,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: Theme.of(context).textTheme.bodyMedium?.merge(style),
      softWrap: false,
      overflow: TextOverflow.ellipsis,
      child: child
    );
  }
}