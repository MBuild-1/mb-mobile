import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

import '../../../domain/entity/address/country.dart';
import '../../../misc/constant.dart';
import '../modified_country_flag.dart';

typedef OnSelectCountry = void Function(Country);

abstract class CountryItem extends StatelessWidget {
  @protected
  double? get itemWidth;

  final Country country;
  final bool isSelected;
  final OnSelectCountry? onSelectCountry;

  const CountryItem({
    super.key,
    required this.country,
    required this.isSelected,
    this.onSelectCountry
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: itemWidth,
      child: Material(
        color: !isSelected ? Colors.transparent : Constant.colorLightOrange,
        child: InkWell(
          onTap: onSelectCountry != null ? () => onSelectCountry!(country) : null,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                ModifiedCountryFlag(
                  width: 16,
                  countryCode: country.code,
                ),
                const SizedBox(width: 12),
                Text(country.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              ]
            )
          ),
        ),
      ),
    );
  }
}