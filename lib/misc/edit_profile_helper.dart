import 'package:flutter/material.dart';

class _EditProfileHelperImpl {
  Widget Function(String, TextStyle?)? setTitleInterceptor(String value, {bool isLoading = false}) {
    return (text, textStyle) {
      Color? backgroundColor = isLoading ? Colors.grey : null;
      return Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    text,
                    style: textStyle?.copyWith(backgroundColor: backgroundColor),
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.edit, size: 16)
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            value,
            style: textStyle?.copyWith(fontWeight: FontWeight.normal, backgroundColor: backgroundColor),
          ),
        ]
      );
    };
  }
}

// ignore: non_constant_identifier_names
var EditProfileHelper = _EditProfileHelperImpl();