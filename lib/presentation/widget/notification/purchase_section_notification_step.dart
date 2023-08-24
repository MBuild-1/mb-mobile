import 'package:flutter/material.dart';

class PurchaseSectionNotificationStep extends StatelessWidget {
  final Widget icon;
  final Widget text;

  const PurchaseSectionNotificationStep({
    super.key,
    required this.icon,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        icon,
        const SizedBox(height: 4),
        text
      ]
    );
  }
}