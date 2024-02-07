import 'package:flutter/material.dart';

import '../../../misc/constant.dart';

typedef OnSelectValue<T> = void Function(T);
typedef OnConvertToStringForItemText<T> = String Function(T);

abstract class SelectValueItem<T> extends StatelessWidget {
  @protected
  double? get itemWidth;

  final T value;
  final bool isSelected;
  final OnSelectValue<T>? onSelectValue;
  final OnConvertToStringForItemText<T>? onConvertToStringForItemText;

  const SelectValueItem({
    super.key,
    required this.value,
    required this.isSelected,
    this.onSelectValue,
    this.onConvertToStringForItemText
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: itemWidth,
      child: Material(
        color: !isSelected ? Colors.transparent : Constant.colorLightOrange,
        child: InkWell(
          onTap: onSelectValue != null ? () => onSelectValue!(value) : null,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text(
                  onConvertToStringForItemText != null ? onConvertToStringForItemText!(value) : "",
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