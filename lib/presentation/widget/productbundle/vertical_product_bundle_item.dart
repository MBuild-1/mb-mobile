import 'package:flutter/material.dart';

import '../../../domain/entity/product/productbundle/product_bundle.dart';
import '../modified_shimmer.dart';
import 'product_bundle_item.dart';

class VerticalProductBundleItem extends ProductBundleItem {
  @override
  double? get itemWidth => 180.0;

  const VerticalProductBundleItem({
    Key? key,
    required ProductBundle productBundle
  }) : super(key: key, productBundle: productBundle);
}

class ShimmerVerticalProductBundleItem extends VerticalProductBundleItem {
  const ShimmerVerticalProductBundleItem({
    Key? key,
    required ProductBundle productBundle
  }) : super(key: key, productBundle: productBundle);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ModifiedShimmer.fromColors(
        child: super.build(context)
      ),
    );
  }
}