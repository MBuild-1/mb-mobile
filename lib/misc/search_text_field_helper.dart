import 'package:flutter/material.dart';

class _SearchTextFieldHelperImpl {
  InputDecoration searchTextFieldStyle(BuildContext context, InputDecoration decoration) {
    final ThemeData themeData = Theme.of(context);
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    TextStyle style = TextStyle(
      color: decoration.enabled ? themeData.hintColor : themeData.disabledColor,
    );
    if (style.inherit) {
      style = defaultTextStyle.style.merge(style);
    }
    if (MediaQuery.boldTextOverride(context)) {
      style = style.merge(const TextStyle(fontWeight: FontWeight.bold));
    }
    return decoration.copyWith(hintStyle: style);
  }
}

// ignore: non_constant_identifier_names
final SearchTextFieldHelper = _SearchTextFieldHelperImpl();