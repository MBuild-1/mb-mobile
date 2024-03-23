import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart';

import '../../misc/constant.dart';
import 'modified_divider.dart';

class ModifiedPinInput extends StatelessWidget {
  final FocusNode focusNode;
  final TextEditingController textEditingController;
  final ValueChanged<String>? onCompleted;

  const ModifiedPinInput({
    super.key,
    required this.focusNode,
    required this.textEditingController,
    required this.onCompleted
  });

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600
    );
    double pinInputWidth = 40.w;
    return SizedBox(
      width: pinInputWidth,
      child: Column(
        children: [
          Pinput(
            focusNode: focusNode,
            length: 6,
            obscureText: true,
            defaultPinTheme: PinTheme(
              width: pinInputWidth / 6,
              textStyle: textStyle,
            ),
            animationDuration: const Duration(milliseconds: 0),
            controller: textEditingController,
            keyboardType: TextInputType.number,
            obscuringCharacter: '●',
            onCompleted: onCompleted,
            preFilledWidget: Text('●', style: textStyle.copyWith(color: Constant.colorGrey13)),
            separatorBuilder: (index) => const SizedBox(width: 0),
          ),
          const SizedBox(height: 6),
          ModifiedDivider(
            lineColor: Theme.of(context).colorScheme.primary,
            lineHeight: 2
          )
        ],
      ),
    );
  }
}