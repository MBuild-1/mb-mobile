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
  final _GradientButtonVariation Function(OutlineGradientButtonType)? customGradientButtonVariation;
  final EdgeInsets? customPadding;

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
    this.outlineGradientButtonVariation = OutlineGradientButtonVariation.variation1,
    this.customGradientButtonVariation,
    this.customPadding
  }) : super(
    key: key,
  );

  @override
  Widget build(BuildContext context) {
    _GradientButtonVariation gradientButtonVariation = customGradientButtonVariation != null ? customGradientButtonVariation!(outlineGradientButtonType) : _getGradientButtonVariation();
    TextStyle disabledTextStyle = const TextStyle(
      color: Colors.grey
    );
    Color disabledBackgroundColor = Colors.grey.shade300;
    Gradient disabledGradient = SweepGradient(
      stops: const [1],
      colors: [disabledBackgroundColor],
    );
    return SizedBox(
      width: width,
      height: height,
      child: OutlineGradientButton(
        onTap: onPressed,
        gradient: onPressed != null ? gradientButtonVariation.gradient : disabledGradient,
        strokeWidth: 1.5,
        backgroundColor: onPressed != null ? gradientButtonVariation.backgroundColor : disabledBackgroundColor,
        padding: customPadding != null ? customPadding! : const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
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
            style: onPressed != null ? gradientButtonVariation.textStyle : disabledTextStyle,
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
  Gradient get gradient => Constant.buttonGradient;

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

class CustomGradientButtonVariation extends _GradientButtonVariation {
  final Color? _backgroundColor;
  final Gradient? _gradient;
  final TextStyle? _textStyle;

  CustomGradientButtonVariation({
    required super.outlineGradientButtonType,
    Color? backgroundColor,
    Gradient? gradient,
    TextStyle? textStyle
  }) : _backgroundColor = backgroundColor,
      _gradient = gradient,
      _textStyle = textStyle;

  @override
  Color get backgroundColor => _backgroundColor != null ? _backgroundColor! : (
    outlineGradientButtonType == OutlineGradientButtonType.solid ? Constant.colorMain : Colors.transparent
  );

  @override
  Gradient get gradient => _gradient != null ? _gradient! : Constant.buttonGradient;

  @override
  TextStyle? get textStyle => _textStyle != null ? _textStyle! : TextStyle(
    color: outlineGradientButtonType == OutlineGradientButtonType.solid ? Colors.white : null,
    fontWeight: FontWeight.bold
  );
}