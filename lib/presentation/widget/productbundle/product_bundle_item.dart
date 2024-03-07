import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/number_ext.dart';

import '../../../domain/entity/product/productbundle/product_bundle.dart';
import '../../../misc/constant.dart';
import '../../../misc/page_restoration_helper.dart';
import '../../../misc/widget_helper.dart';
import '../../page/product_bundle_detail_page.dart';
import '../modifiedcachednetworkimage/product_bundle_modified_cached_network_image.dart';

typedef OnAddWishlistWithProductBundle = void Function(ProductBundle);
typedef OnRemoveWishlistWithProductBundle = void Function(ProductBundle);
typedef OnAddCartWithProductBundle = void Function(ProductBundle);
typedef OnRemoveCartWithProductBundle = void Function(ProductBundle);

abstract class ProductBundleItem extends StatelessWidget {
  final ProductBundle productBundle;
  final OnAddWishlistWithProductBundle? onAddWishlist;
  final OnRemoveWishlistWithProductBundle? onRemoveWishlist;
  final OnAddCartWithProductBundle? onAddCart;
  final OnRemoveCartWithProductBundle? onRemoveCart;
  final bool hasBackground;

  const ProductBundleItem({
    super.key,
    required this.productBundle,
    this.onAddWishlist,
    this.onRemoveWishlist,
    this.onAddCart,
    this.onRemoveCart,
    required this.hasBackground
  });

  @override
  Widget build(BuildContext context) {
    String soldCount = "No Sold Count".tr;
    bool comingSoon = productBundle.price.isZeroResult.isZero;
    BorderRadius borderRadius = BorderRadius.circular(16.0);
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: AspectRatio(
        aspectRatio: Constant.aspectRatioValueProductBundleArea.toDouble(),
        child: Material(
          color: hasBackground ? Colors.white : Colors.transparent,
          borderRadius: borderRadius,
          elevation: hasBackground ? 3 : 0.0,
          child: InkWell(
            onTap: () => PageRestorationHelper.toProductBundleDetailPage(
              context, DefaultProductBundleDetailPageParameter(
                productBundleId: productBundle.id
              )
            ),
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
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(Constant.imageBadgeBlue),
                                      fit: BoxFit.cover
                                    ),
                                  ),
                                  child: Text(
                                    comingSoon ? "Coming Soon".tr : productBundle.price.toRupiah(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white
                                    )
                                  ),
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
                                wishlistAndCartIndicator(comingSoon)
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

  @protected
  Widget wishlistAndCartIndicator(bool comingSoon) {
    return WidgetHelper.productBundleWishlistAndCartIndicator(
      productBundle: productBundle,
      comingSoon: comingSoon,
      onAddWishlist: onAddWishlist,
      onRemoveWishlist: onRemoveWishlist,
      onAddCart: onAddCart,
      onRemoveCart: onRemoveCart
    );
  }
}