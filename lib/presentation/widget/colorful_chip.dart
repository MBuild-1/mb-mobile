import 'package:flutter/material.dart';

class ColorfulChip extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final Color color;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const ColorfulChip({
    super.key,
    required this.text,
    this.textStyle,
    required this.color,
    this.textColor,
    this.padding,
    this.borderRadius
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(8.0),
        color: color,
      ),
      child: Text(
        text,
        style: textStyle ?? TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}