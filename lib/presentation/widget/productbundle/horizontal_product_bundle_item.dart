import 'package:flutter/material.dart';

import '../../../domain/entity/product/productbundle/product_bundle.dart';
import 'product_bundle_item.dart';

class HorizontalProductBundleItem extends ProductBundleItem {
  const HorizontalProductBundleItem({
    Key? key,
    required ProductBundle productBundle,
    OnAddWishlistWithProductBundleId? onAddWishlist,
    OnRemoveWishlistWithProductBundleId? onRemoveWishlist,
  }) : super(
    key: key,
    productBundle: productBundle,
    onAddWishlist: onAddWishlist,
    onRemoveWishlist: onRemoveWishlist
  );
}