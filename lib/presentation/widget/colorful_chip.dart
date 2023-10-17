import 'package:flutter/material.dart';

class ColorfulChip extends StatelessWidget {
  final String text;
  final Color color;
  final Color? textColor;

  const ColorfulChip({
    super.key,
    required this.text,
    required this.color,
    this.textColor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: color,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}