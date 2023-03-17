import 'package:flutter/material.dart';

import '../../../domain/entity/product/productbundle/product_bundle.dart';
import 'product_bundle_item.dart';

class HorizontalProductBundleItem extends ProductBundleItem {
  @override
  double? get itemWidth => 180.0;

  const HorizontalProductBundleItem({
    Key? key,
    required ProductBundle productBundle
  }) : super(key: key, productBundle: productBundle);
}