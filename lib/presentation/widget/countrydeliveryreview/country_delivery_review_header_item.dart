import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../misc/constant.dart';
import '../modified_shimmer.dart';

class ShimmerCountryDeliveryReviewHeaderItem extends StatelessWidget {
  const ShimmerCountryDeliveryReviewHeaderItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ModifiedShimmer.fromColors(
      child: AspectRatio(
        aspectRatio: Constant.aspectRatioValueCountryDeliveryReviewCountryBackground.toDouble(),
        child: Container(
          color: Colors.black,
        )
      )
    );
  }
}

class CountryDeliveryReviewHeaderItem extends StatelessWidget {
  const CountryDeliveryReviewHeaderItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}