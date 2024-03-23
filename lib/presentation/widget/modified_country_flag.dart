import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

class ModifiedCountryFlag extends StatelessWidget {
  final double? width;
  final double? height;
  final String countryCode;

  const ModifiedCountryFlag({
    super.key,
    this.width,
    this.height,
    required this.countryCode
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 1.2,
            spreadRadius: 1.2,
            color: Colors.black.withOpacity(0.5)
          )
        ]
      ),
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: CountryFlags.flag(countryCode)
      ),
    );
  }
}