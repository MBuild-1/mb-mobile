import 'package:flutter/material.dart';

import '../../domain/entity/product/productbundle/product_bundle.dart';
import 'product_bundle_highlight_list_item.dart';
import 'productbundle/product_bundle_item.dart';

class ProductBundleHeaderListItem extends StatelessWidget {
  final ProductBundle productBundle;
  final OnAddWishlistWithProductBundle? onAddWishlist;
  final OnRemoveWishlistWithProductBundle? onRemoveWishlist;
  final OnAddCartWithProductBundle? onAddCart;
  final OnRemoveCartWithProductBundle? onRemoveCart;

  const ProductBundleHeaderListItem({
    super.key,
    required this.productBundle,
    this.onAddWishlist,
    this.onRemoveWishlist,
    this.onAddCart,
    this.onRemoveCart
  });

  @override
  Widget build(BuildContext context) {
    return ProductBundleHighlightListItem(
      productBundle: productBundle,
      onAddWishlist: onAddWishlist,
      onRemoveWishlist: onRemoveWishlist,
      onAddCart: onAddCart,
      onRemoveCart: onRemoveCart
    );
  }
}