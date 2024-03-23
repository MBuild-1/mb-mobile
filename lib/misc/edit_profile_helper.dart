import 'package:flutter/material.dart';

import '../presentation/widget/modified_svg_picture.dart';
import 'constant.dart';

class _EditProfileHelperImpl {
  Widget setTitle(String title) {
    return SizedBox(
      width: 130,
      child: Text(title)
    );
  }

  Widget Function(String, TextStyle?)? setContentInterceptor(String value, {bool isLoading = false}) {
    return (text, textStyle) {
      return setContentInterceptorWithWidget(
        (textStyle) => Text(
          value,
          style: textStyle,
        )
      )!(text, textStyle);
    };
  }

  Widget Function(String, TextStyle?)? setContentInterceptorWithWidget(Widget Function(TextStyle?) widget, {bool isLoading = false}) {
    return (text, textStyle) {
      Color? backgroundColor = isLoading ? Colors.grey : null;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              children: [
                Expanded(
                  child: widget(
                    textStyle?.copyWith(
                      fontWeight: FontWeight.normal,
                      backgroundColor: backgroundColor
                    )
                  ),
                ),
                const SizedBox(width: 10.0),
                ModifiedSvgPicture.asset(
                  height: 14,
                  Constant.vectorEdit,
                  overrideDefaultColorWithSingleColor: false
                ),
              ],
            ),
          ),
        ]
      );
    };
  }
}

// ignore: non_constant_identifier_names
var EditProfileHelper = _EditProfileHelperImpl();