import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/number_ext.dart';
import 'package:sizer/sizer.dart';

import '../../../domain/entity/product/productbundle/product_bundle.dart';
import '../../../misc/constant.dart';
import '../../../misc/widget_helper.dart';
import '../button/add_or_remove_cart_button.dart';
import '../button/add_or_remove_wishlist_button.dart';
import '../button/custombutton/sized_outline_gradient_button.dart';
import '../modifiedcachednetworkimage/product_bundle_modified_cached_network_image.dart';
import 'product_bundle_item.dart';

class ProductBundleHeader extends StatelessWidget {
  final ProductBundle productBundle;
  final OnAddWishlistWithProductBundle? onAddWishlist;
  final OnRemoveWishlistWithProductBundle? onRemoveWishlist;
  final OnAddCartWithProductBundle? onAddCart;
  final OnRemoveCartWithProductBundle? onRemoveCart;

  const ProductBundleHeader({
    super.key,
    required this.productBundle,
    this.onAddWishlist,
    this.onRemoveWishlist,
    this.onAddCart,
    this.onRemoveCart
  });

  @override
  Widget build(BuildContext context) {
    String soldCount = "No Sold Count".tr;
    BorderRadius borderRadius = BorderRadius.circular(16.0);
    bool comingSoon = productBundle.price.isZeroResult.isZero;
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: AspectRatio(
        aspectRatio: Constant.aspectRatioValueProductBundleArea.toDouble(),
        child: Material(
          color: Colors.white,
          borderRadius: borderRadius,
          child: InkWell(
            onTap: null,
            borderRadius: borderRadius,
            child: Row(
              children: [
                SizedBox(
                  width: 200,
                  child: ProductBundleModifiedCachedNetworkImage(
                    imageUrl: productBundle.imageUrl,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          productBundle.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          )
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  productBundle.price.toRupiah(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                  )
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        soldCount,
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w300
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                WidgetHelper.productBundleWishlistAndCartIndicator(
                                  productBundle: productBundle,
                                  comingSoon: comingSoon,
                                  onAddWishlist: onAddWishlist,
                                  onRemoveWishlist: onRemoveWishlist,
                                  onAddCart: onAddCart,
                                  onRemoveCart: onRemoveCart
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                )
              ]
            )
          )
        ),
      ),
    );
  }
}