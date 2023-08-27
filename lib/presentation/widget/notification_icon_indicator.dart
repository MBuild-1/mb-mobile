import 'package:flutter/material.dart';

import 'notification_number_indicator.dart';
import 'tap_area.dart';

class NotificationIconIndicator extends StatelessWidget {
  final void Function()? onTap;
  final Widget icon;
  final int notificationNumber;

  const NotificationIconIndicator({
    super.key,
    this.onTap,
    required this.icon,
    required this.notificationNumber
  });

  @override
  Widget build(BuildContext context) {
    return TapArea(
      onTap: onTap,
      child: SizedBox(
        width: 30,
        height: 25,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              child: icon,
            ),
            Positioned(
              top: 0,
              right: 0,
              child: NotificationNumberIndicator(
                notificationNumber: notificationNumber
              )
            )
          ],
        ),
      ),
    );
  }
}