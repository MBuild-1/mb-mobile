import 'package:flutter/material.dart';

import '../../misc/constant.dart';

class NumberIndicator extends StatelessWidget {
  final int notificationNumber;
  final double? fontSize;

  const NumberIndicator({
    super.key,
    required this.notificationNumber,
    this.fontSize
  });

  @override
  Widget build(BuildContext context) {
    if (notificationNumber <= 0) {
      return Container();
    }
    int maxNumber = 99;
    bool moreThanMaxNumber = notificationNumber > maxNumber;
    return Container(
      decoration: BoxDecoration(
        color: Constant.colorMain,
        borderRadius: BorderRadius.circular(3)
      ),
      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
      child: Center(
        child: Text(
          moreThanMaxNumber ? "$maxNumber+" : notificationNumber.toString(),
          style: TextStyle(
            fontSize: fontSize ?? 7,
            color: Colors.white
          )
        ),
      )
    );
  }
}