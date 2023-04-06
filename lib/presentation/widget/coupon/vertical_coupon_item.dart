import 'package:flutter/material.dart';

import '../modified_shimmer.dart';
import 'coupon_item.dart';

class VerticalCouponItem extends CouponItem {
  const VerticalCouponItem({
    super.key,
    required super.coupon,
    super.onSelectCoupon
  });
}

class ShimmerVerticalCouponItem extends VerticalCouponItem {
  const ShimmerVerticalCouponItem({
    super.key,
    required super.coupon,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ModifiedShimmer.fromColors(
        child: super.build(context)
      ),
    );
  }
}