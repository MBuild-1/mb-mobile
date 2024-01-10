import 'package:flutter/material.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../../misc/constant.dart';
import 'select_language_item.dart';

class VerticalSelectLanguageItem extends SelectLanguageItem {
  @override
  double? get itemWidth => null;

  const VerticalSelectLanguageItem({
    super.key,
    required super.selectLanguage,
    required super.isSelected,
    required super.onSelectLanguage
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: itemWidth,
      child: Material(
        color: !isSelected ? Colors.transparent : Constant.colorLightOrange,
        child: InkWell(
          onTap: onSelectLanguage != null ? () => onSelectLanguage!(selectLanguage) : null,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text(
                  selectLanguage.nameMultiLanguageString.toStringNonNull,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold
                  )
                ),
              ]
            )
          ),
        ),
      ),
    );
  }
}