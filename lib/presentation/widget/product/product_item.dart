import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/number_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:sizer/sizer.dart';

import '../../../domain/entity/product.dart';
import '../../../domain/entity/product_with_detail_endpoint.dart';
import '../../../misc/constant.dart';
import '../../../misc/page_restoration_helper.dart';
import '../modified_cached_network_image.dart';

abstract class ProductItem extends StatelessWidget {
  final Product product;

  @protected
  String get priceString => _priceString(product.productSellingPrice.toDouble());

  @protected
  String? get discountPriceString {
    double discountPrice = product.productDiscountPrice.toDouble();
    double currentPrice = product.productSellingPrice.toDouble();
    return discountPrice == currentPrice ? null : _priceString(discountPrice);
  }

  Widget _nonDiscountPriceWidget(BuildContext context) {
    return Text(
      discountPriceString != null ? discountPriceString! : priceString,
      style: discountPriceString != null ? Theme.of(context).textTheme.labelLarge?.merge(
        TextStyle(
          color: Theme.of(context).colorScheme.primary
        )
      ) : TextStyle(
        color: Constant.colorProductItemDiscountOrNormal
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
    required this.product
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
    return SizedBox(
      width: itemWidth,
      child: Material(
        borderRadius: BorderRadius.circular(16.0),
        child: InkWell(
          onTap: () {
            if (product is ProductWithDetailEndpoint) {
              PageRestorationHelper.toProductDetailPage((product as ProductWithDetailEndpoint).detailEndpoint, context);
            }
          },
          borderRadius: BorderRadius.circular(16.0),
          child: Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              border: Border.all(color: Constant.colorProductItemBorder),
              borderRadius: BorderRadius.circular(16.0)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: ModifiedCachedNetworkImage(
                      imageUrl: product.defaultImageUrl.toEmptyStringNonNull,
                    )
                  )
                ),
                SizedBox(height: 1.h),
                Tooltip(
                  message: product.name.toStringNonNull,
                  child: Text(
                    product.name.toStringNonNull,
                    style: Theme.of(context).textTheme.labelLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  product.unit,
                  style: const TextStyle(fontSize: 10),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis
                ),
                SizedBox(height: 1.h),
                priceWidget(context, _nonDiscountPriceWidget(context), _discountPriceWidget(context)),
              ],
            )
          )
        )
      )
    );
  }
}