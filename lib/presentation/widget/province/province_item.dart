import 'package:flutter/material.dart';

import '../../../domain/entity/province/province_map.dart';
import '../../../misc/constant.dart';

typedef OnSelectProvince = void Function(ProvinceMap);

abstract class ProvinceItem extends StatelessWidget {
  @protected
  double? get itemWidth;

  final ProvinceMap province;
  final bool isSelected;
  final OnSelectProvince? onSelectProvince;

  const ProvinceItem({
    super.key,
    required this.province,
    required this.isSelected,
    this.onSelectProvince
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: itemWidth,
      child: Material(
        color: !isSelected ? Colors.transparent : Constant.colorLightOrange,
        child: InkWell(
          onTap: onSelectProvince != null ? () => onSelectProvince!(province) : null,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text(province.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              ]
            )
          ),
        ),
      ),
    );
  }
}