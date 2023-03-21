import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/number_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:sizer/sizer.dart';

import '../../../domain/entity/product/product_appearance_data.dart';
import '../../../misc/constant.dart';
import '../../../misc/page_restoration_helper.dart';
import '../button/add_or_remove_wishlist_button.dart';
import '../button/custombutton/sized_outline_gradient_button.dart';
import '../modified_divider.dart';
import '../modified_vertical_divider.dart';
import '../modifiedcachednetworkimage/product_modified_cached_network_image.dart';
import '../rating_indicator.dart';

abstract class ProductItem extends StatelessWidget {
  final ProductAppearanceData productAppearanceData;

  @protected
  String get priceString => _priceString(productAppearanceData.price.toDouble());

  @protected
  String? get discountPriceString {
    double? price = productAppearanceData.discountPrice;
    return price != null ? _priceString(price) : null;
  }

  Widget _nonDiscountPriceWidget(BuildContext context) {
    return Text(
      discountPriceString != null ? discountPriceString! : priceString,
      style: discountPriceString != null ? TextStyle(
        color: Theme.of(context).colorScheme.primary
      ) : const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold
      )
    );
  }

  Widget _discountPriceWidget(BuildContext context) {
    return Text(
      priceString,
      style: TextStyle(
        color: Constant.colorProductItemDiscountOrNormal,
        decoration: TextDecoration.lineThrough
      )
    );
  }

  @protected
  Widget priceWidget(BuildContext context, Widget nonDiscountPriceWidget, Widget discountPriceWidget);

  @protected
  double? get itemWidth;

  const ProductItem({
    Key? key,
    required this.productAppearanceData
  }) : super(key: key);

  String _priceString(double price) {
    if (price == 0.0) {
      return "Free".tr;
    } else {
      return price.toRupiah();
    }
  }

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius = const BorderRadius.only(
      topRight: Radius.circular(16.0),
      bottomLeft: Radius.circular(16.0),
      bottomRight: Radius.circular(16.0)
    );
    String weight = productAppearanceData.weight.toString();
    String soldCount = "No Sold Count".tr;
    return SizedBox(
      width: itemWidth,
      child: Padding(
        // Use padding widget for avoiding shadow elevation overlap.
        padding: const EdgeInsets.only(top: 1.0, bottom: 5.0),
        child: Material(
          color: Colors.white,
          borderRadius: borderRadius,
          elevation: 3,
          child: InkWell(
            onTap: () {},
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
                        imageUrl: productAppearanceData.imageUrl.toEmptyStringNonNull,
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
                          message: productAppearanceData.name.toStringNonNull,
                          child: Text(
                            productAppearanceData.name.toStringNonNull,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: priceWidget(context, _nonDiscountPriceWidget(context), _discountPriceWidget(context)),
                            ),
                            SizedBox(width: 1.5.w),
                            const ModifiedVerticalDivider(
                              lineWidth: 1,
                              lineHeight: 20,
                              lineColor: Colors.black,
                            ),
                            const SizedBox(width: 15),
                            Text(weight, style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)),
                          ]
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
                              onAddWishlist: () {}
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
                ],
              )
            )
          )
        ),
      )
    );
  }
}