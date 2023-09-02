import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../misc/constant.dart';

class BadgeIndicator extends StatelessWidget {
  final BadgeIndicatorType badgeIndicatorType;
  final double? paddingLeft;
  final double? paddingRight;

  const BadgeIndicator({
    super.key,
    required this.badgeIndicatorType,
    this.paddingLeft,
    this.paddingRight
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: badgeIndicatorType.width,
      height: 25,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(badgeIndicatorType.assetImageUrl),
          fit: BoxFit.cover
        ),
        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(10))
      ),
      child: Padding(
        padding: EdgeInsets.only(left: paddingLeft ?? 0.0, right: paddingRight ?? 0.0),
        child: Center(
          child: Text(
            badgeIndicatorType.badgeName,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),
          ),
        ),
      ),
    );
  }
}

abstract class BadgeIndicatorType {
  double get width;
  String get assetImageUrl;
  String get badgeName;
}

class IsViralBadgeIndicatorType extends BadgeIndicatorType {
  @override
  double get width => 80;

  @override
  String get assetImageUrl => Constant.imageBadgeOrange;

  @override
  String get badgeName => "Is Viral".tr;
}

class BestsellerBadgeIndicatorType extends BadgeIndicatorType {
  @override
  double get width => 80;

  @override
  String get assetImageUrl => Constant.imageBadgeBlue;

  @override
  String get badgeName => "Bestseller".tr;
}