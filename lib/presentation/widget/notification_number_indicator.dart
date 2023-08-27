import 'package:flutter/material.dart';

import '../../misc/constant.dart';

class NotificationNumberIndicator extends StatelessWidget {
  final int notificationNumber;

  const NotificationNumberIndicator({
    super.key,
    required this.notificationNumber
  });

  @override
  Widget build(BuildContext context) {
    if (notificationNumber <= 0) {
      return Container();
    }
    int maxNumber = 99;
    bool moreThanMaxNumber = notificationNumber > maxNumber;
    return Container(
      width: moreThanMaxNumber ? 20 : 16,
      height: 16,
      decoration: BoxDecoration(
        color: Constant.colorMain,
        borderRadius: BorderRadius.circular(3)
      ),
      child: Center(
        child: Text(
          moreThanMaxNumber ? "$maxNumber+" : notificationNumber.toString(),
          style: const TextStyle(
            fontSize: 8,
            color: Colors.white
          )
        ),
      )
    );
  }
}