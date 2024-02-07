import 'package:flutter/material.dart';

import '../../../misc/constant.dart';
import '../../../misc/multi_language_string.dart';

class SolidTab extends StatelessWidget {
  final bool isActive;
  final String text;
  final dynamic value;
  final void Function(dynamic)? onTap;

  const SolidTab({
    super.key,
    required this.isActive,
    required this.text,
    required this.value,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isActive ? Constant.colorLightOrange3 : Colors.transparent,
      child: InkWell(
        onTap: !isActive ? () => onTap!(value) : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isActive ? Constant.colorMain : null
              )
            ),
          )
        ),
      )
    );
  }
}

class SolidTabValue {
  MultiLanguageString text;
  dynamic value;

  SolidTabValue({
    required this.text,
    required this.value
  });
}