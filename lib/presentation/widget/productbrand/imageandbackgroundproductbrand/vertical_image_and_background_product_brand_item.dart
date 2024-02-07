import 'package:flutter/material.dart';

import '../../modified_shimmer.dart';
import 'image_and_background_product_brand_item.dart';

class VerticalImageAndBackgroundProductBrandItem extends ImageAndBackgroundProductBrandItem {
  @override
  double? get itemWidth => null;

  const VerticalImageAndBackgroundProductBrandItem({
    super.key,
    required super.productBrand
  });
}

class ShimmerVerticalImageAndBackgroundProductBrandItem extends VerticalImageAndBackgroundProductBrandItem {
  const ShimmerVerticalImageAndBackgroundProductBrandItem({
    super.key,
    required super.productBrand
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