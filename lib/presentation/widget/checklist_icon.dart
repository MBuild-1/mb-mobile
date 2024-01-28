import 'package:flutter/material.dart';

import '../../misc/constant.dart';

class ChecklistIcon extends StatelessWidget {
  final double size;
  final Color? color;
  final bool activeValue;

  const ChecklistIcon({
    super.key,
    required this.size,
    this.color,
    required this.activeValue
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = Constant.colorGrey;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: activeValue ? (color ?? Theme.of(context).colorScheme.primary) : Theme.of(context).colorScheme.surface,
        border: activeValue ? null : Border.all(color: borderColor),
        shape: BoxShape.circle
      ),
      child: activeValue ? Center(
        child: Icon(
          Icons.check,
          size: size - 4,
          color: Colors.white
        ),
      ) : null
    );
  }
}