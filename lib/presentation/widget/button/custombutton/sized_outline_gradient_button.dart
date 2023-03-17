import 'package:flutter/material.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../../../misc/constant.dart';
import '../../../../misc/error/message_error.dart';
import 'outline_gradient_button.dart';

enum OutlineGradientButtonType {
  solid, outline
}

enum OutlineGradientButtonVariation {
  variation1, variation2
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
  final OutlineGradientButtonVariation outlineGradientButtonVariation;

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
    this.outlineGradientButtonType = OutlineGradientButtonType.solid,
    this.outlineGradientButtonVariation = OutlineGradientButtonVariation.variation1
  }) : super(
    key: key,
  );

  @override
  Widget build(BuildContext context) {
    _GradientButtonVariation gradientButtonVariation = _getGradientButtonVariation();
    return SizedBox(
      width: width,
      height: height,
      child: OutlineGradientButton(
        onTap: onPressed,
        gradient: gradientButtonVariation.gradient,
        strokeWidth: 1.5,
        backgroundColor: gradientButtonVariation.backgroundColor,
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
            style: gradientButtonVariation.textStyle
          )
        ),
      )
    );
  }

  _GradientButtonVariation _getGradientButtonVariation() {
    if (outlineGradientButtonVariation == OutlineGradientButtonVariation.variation1) {
      return _Variation1GradientButtonVariation(outlineGradientButtonType: outlineGradientButtonType);
    } else if (outlineGradientButtonVariation == OutlineGradientButtonVariation.variation2) {
      return _Variation2GradientButtonVariation(outlineGradientButtonType: outlineGradientButtonType);
    } else {
      throw MessageError(title: "Outline gradient button is not suitable");
    }
  }
}

abstract class _GradientButtonVariation {
  OutlineGradientButtonType outlineGradientButtonType;
  Gradient get gradient;
  Color get backgroundColor;
  TextStyle? get textStyle;

  _GradientButtonVariation({
    required this.outlineGradientButtonType
  });
}

class _Variation1GradientButtonVariation extends _GradientButtonVariation {
  _Variation1GradientButtonVariation({required super.outlineGradientButtonType});

  @override
  Color get backgroundColor => outlineGradientButtonType == OutlineGradientButtonType.solid ? Constant.colorDarkBlue : Colors.transparent;

  @override
  Gradient get gradient => SweepGradient(
    stops: const [0, 0.25, 0.25, 0.5, 0.5, 1],
    colors: [Constant.colorButtonGradient1, Constant.colorButtonGradient1, Constant.colorButtonGradient2, Constant.colorButtonGradient2, Constant.colorButtonGradient3, Constant.colorButtonGradient3],
  );

  @override
  TextStyle? get textStyle => TextStyle(
    color: outlineGradientButtonType == OutlineGradientButtonType.solid ? Colors.white : null,
    fontWeight: FontWeight.bold
  );
}

class _Variation2GradientButtonVariation extends _GradientButtonVariation {
  _Variation2GradientButtonVariation({required super.outlineGradientButtonType});

  @override
  Color get backgroundColor => outlineGradientButtonType == OutlineGradientButtonType.solid ? Constant.colorMain : Colors.transparent;

  @override
  Gradient get gradient => SweepGradient(
    stops: const [1],
    colors: [Constant.colorMain],
  );

  @override
  TextStyle? get textStyle => TextStyle(
    color: outlineGradientButtonType == OutlineGradientButtonType.solid ? Colors.white : Constant.colorMain,
  );
}