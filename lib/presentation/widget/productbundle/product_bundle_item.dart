import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/number_ext.dart';
import 'package:sizer/sizer.dart';

import '../../../domain/entity/product/productbundle/product_bundle.dart';
import '../../../misc/constant.dart';
import '../../../misc/page_restoration_helper.dart';
import '../button/add_or_remove_wishlist_button.dart';
import '../button/custombutton/sized_outline_gradient_button.dart';
import '../modified_vertical_divider.dart';
import '../modifiedcachednetworkimage/product_bundle_modified_cached_network_image.dart';
import '../rating_indicator.dart';

typedef OnAddWishlistWithProductBundleId = void Function(String);
typedef OnRemoveWishlistWithProductBundleId = void Function(String);

abstract class ProductBundleItem extends StatelessWidget {
  final ProductBundle productBundle;
  final OnAddWishlistWithProductBundleId? onAddWishlist;
  final OnRemoveWishlistWithProductBundleId? onRemoveWishlist;

  const ProductBundleItem({
    super.key,
    required this.productBundle,
    this.onAddWishlist,
    this.onRemoveWishlist
  });

  @override
  Widget build(BuildContext context) {
    String soldCount = "No Sold Count".tr;
    BorderRadius borderRadius = BorderRadius.circular(16.0);
    void onWishlist(void Function(String)? onWishlistCallback) {
      if (onWishlistCallback != null) {
        onWishlistCallback(productBundle.id);
      }
    }
    return Material(
      color: Colors.white,
      borderRadius: borderRadius,
      elevation: 3,
      child: InkWell(
        onTap: () => PageRestorationHelper.toProductBundleDetailPage(context, productBundle.id),
        borderRadius: borderRadius,
        child: AspectRatio(
          aspectRatio: Constant.aspectRatioValueProductBundleArea.toDouble(),
          child: ClipRRect(
            borderRadius: borderRadius,
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: AspectRatio(
                      aspectRatio: Constant.aspectRatioValueProductBundleImage.toDouble(),
                      child: ProductBundleModifiedCachedNetworkImage(
                        imageUrl: productBundle.imageUrl
                      )
                    ),
                  )
                ),
                SizedBox(
                  width: 150,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
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
                                    const RatingIndicator(rating: 5.0),
                                    SizedBox(width: 1.5.w),
                                    const ModifiedVerticalDivider(
                                      lineWidth: 1,
                                      lineHeight: 10,
                                      lineColor: Colors.black,
                                    ),
                                    SizedBox(width: 1.5.w),
                                    Text(soldCount, style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    AddOrRemoveWishlistButton(
                                      onAddWishlist: onAddWishlist != null ? () => onWishlist(onAddWishlist) : null,
                                      onRemoveWishlist: onRemoveWishlist != null ? () => onWishlist(onRemoveWishlist) : null,
                                    ),
                                    SizedBox(width: 1.5.w),
                                    Expanded(
                                      child: SizedOutlineGradientButton(
                                        onPressed: () {},
                                        text: "+ ${"Cart".tr}",
                                        outlineGradientButtonType: OutlineGradientButtonType.outline,
                                        outlineGradientButtonVariation: OutlineGradientButtonVariation.variation2,
                                      )
                                    )
                                  ],
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
        )
      )
    );
  }
}