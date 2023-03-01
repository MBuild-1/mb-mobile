import 'package:flutter/material.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../../../misc/constant.dart';
import 'outline_gradient_button.dart';

enum OutlineGradientButtonType {
  solid, outline
}

class SizedOutlineGradientButton extends StatelessWidget {
  final double? width;
  final double? height;
  final VoidCallback? onPressed;
  final Widget? child;
  final String? text;
  final VoidCallback? onLongPress;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  final FocusNode? focusNode;
  final bool autofocus;
  final OutlineGradientButtonType outlineGradientButtonType;

  const SizedOutlineGradientButton({
    Key? key,
    this.width,
    this.height,
    required this.onPressed,
    this.child,
    required this.text,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.focusNode,
    this.autofocus = false,
    this.outlineGradientButtonType = OutlineGradientButtonType.solid
  }) : super(
    key: key,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: OutlineGradientButton(
        onTap: onPressed,
        gradient: SweepGradient(
          stops: const [0, 0.25, 0.25, 0.5, 0.5, 1],
          colors: [Constant.colorButtonGradient1, Constant.colorButtonGradient1, Constant.colorButtonGradient2, Constant.colorButtonGradient2, Constant.colorButtonGradient3, Constant.colorButtonGradient3],
        ),
        strokeWidth: 1.5,
        backgroundColor: outlineGradientButtonType == OutlineGradientButtonType.solid ? Constant.colorDarkBlue : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        radius: const Radius.circular(8),
        inkWell: true,
        onLongPress: onLongPress,
        onHover: onHover,
        onFocusChange: onFocusChange,
        focusNode: focusNode,
        autofocus: autofocus,
        child: child != null ? child! : Center(
          child: Text(
            text.toEmptyStringNonNull,
            style: TextStyle(
              color: outlineGradientButtonType == OutlineGradientButtonType.solid ? Colors.white : null,
              fontWeight: FontWeight.bold
            )
          )
        ),
      )
    );
  }
}