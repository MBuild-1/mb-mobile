import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import 'solid_tab.dart';

class SolidTabGroup extends StatelessWidget {
  final List<SolidTabValue> solidTabValueList;
  final dynamic selectedValue;
  final void Function(dynamic)? onSelectTab;

  const SolidTabGroup({
    super.key,
    required this.solidTabValueList,
    this.selectedValue,
    this.onSelectTab
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: solidTabValueList.mapIndexed<Widget>((index, solidTabValue) {
        return Expanded(
          child: SolidTab(
            isActive: solidTabValue.value == selectedValue,
            text: solidTabValue.text.toStringNonNull,
            value: solidTabValue.value,
            onTap: onSelectTab
          ),
        );
      }).toList()
    );
  }
}