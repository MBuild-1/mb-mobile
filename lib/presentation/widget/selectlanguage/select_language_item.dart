import 'package:flutter/material.dart';

import '../../../domain/entity/selectlanguage/select_language.dart';

abstract class SelectLanguageItem extends StatelessWidget {
  @protected
  double? get itemWidth;

  final SelectLanguage selectLanguage;
  final bool isSelected;
  final void Function(SelectLanguage)? onSelectLanguage;

  const SelectLanguageItem({
    super.key,
    required this.selectLanguage,
    required this.isSelected,
    required this.onSelectLanguage
  });
}