import 'package:flutter/material.dart';

import '../../../domain/entity/product/productbundle/product_bundle.dart';
import 'product_bundle_item.dart';

class HorizontalProductBundleItem extends ProductBundleItem {
  const HorizontalProductBundleItem({
    super.key,
    required super.productBundle,
    super.onAddWishlist,
    super.onRemoveWishlist,
    super.onAddCart,
    super.onRemoveCart,
    super.hasBackground = true
  });
}