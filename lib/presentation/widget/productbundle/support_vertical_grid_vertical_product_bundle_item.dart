import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/number_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:sizer/sizer.dart';

import '../../../domain/entity/product/productbundle/product_bundle.dart';
import '../../../misc/constant.dart';
import '../../../misc/page_restoration_helper.dart';
import '../../page/product_bundle_detail_page.dart';
import '../button/add_or_remove_cart_button.dart';
import '../button/add_or_remove_wishlist_button.dart';
import '../button/custombutton/sized_outline_gradient_button.dart';
import '../modified_divider.dart';
import '../modified_vertical_divider.dart';
import '../modifiedcachednetworkimage/product_modified_cached_network_image.dart';
import 'product_bundle_item.dart';

class SupportVerticalGridVerticalProductBundleItem extends ProductBundleItem {
  const SupportVerticalGridVerticalProductBundleItem({
    super.key,
    required super.productBundle,
    super.onAddWishlist,
    super.onRemoveWishlist,
    super.onAddCart,
    super.onRemoveCart,
    super.hasBackground = true
  });

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius = const BorderRadius.only(
      topRight: Radius.circular(16.0),
      bottomLeft: Radius.circular(16.0),
      bottomRight: Radius.circular(16.0)
    );
    bool comingSoon = productBundle.price.isZeroResult.isZero;
    String soldCount = "No Sold Count".tr;
    void onWishlist(void Function(ProductBundle)? onWishlistCallback) {
      if (onWishlistCallback != null) {
        onWishlistCallback(productBundle);
      }
    }
    return SizedBox(
      child: Padding(
        // Use padding widget for avoiding shadow elevation overlap.
        padding: const EdgeInsets.only(top: 1.0, bottom: 5.0),
        child: Material(
          color: Colors.white,
          borderRadius: borderRadius,
          elevation: 3,
          child: InkWell(
            onTap: () => PageRestorationHelper.toProductBundleDetailPage(
              context, DefaultProductBundleDetailPageParameter(
                productBundleId: productBundle.id
              )
            ),
            borderRadius: borderRadius,
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: borderRadius
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 1.0,
                    child: ClipRRect(
                      child: ProductModifiedCachedNetworkImage(
                        imageUrl: productBundle.imageUrl,
                      )
                    )
                  ),
                  ModifiedDivider(
                    lineHeight: 3.5,
                    lineColor: Constant.colorGrey5
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Tooltip(
                          message: productBundle.name.toStringNonNull,
                          child: Text(
                            productBundle.name.toStringNonNull,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                productBundle.price.toRupiah(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                                )
                              ),
                            )
                          ]
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(soldCount, style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        wishlistAndCartIndicator(comingSoon)
                      ],
                    ),
                  ),
                ],
              )
            )
          )
        ),
      )
    );
  }
}