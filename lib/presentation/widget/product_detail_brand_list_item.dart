import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:sizer/sizer.dart';

import '../../domain/entity/product/productbrand/product_brand.dart';
import '../../misc/aspect_ratio_value.dart';
import '../../misc/constant.dart';
import 'modifiedcachednetworkimage/brand_modified_cached_network_image.dart';
import 'modifiedcachednetworkimage/modified_cached_network_image.dart';
import 'profile_picture_cache_network_image.dart';

class ProductDetailBrandListItem extends StatelessWidget {
  final ProductBrand productBrand;

  const ProductDetailBrandListItem({super.key, required this.productBrand});

  @override
  Widget build(BuildContext context) {
    AspectRatioValue aspectRatioValue = Constant.aspectRatioValueBrandImage;
    double measuredWidth = Get.width - (Constant.paddingListItem * 2);
    double measuredHeight = measuredWidth * aspectRatioValue.height / aspectRatioValue.width;
    double profilePictureDimension = 20.w;
    double containerHeight = measuredHeight + (profilePictureDimension / 2);
    return SizedBox(
      width: double.infinity,
      height: containerHeight,
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: aspectRatioValue.toDouble(),
            child: ClipRRect(
              child: ModifiedCachedNetworkImage(
                imageUrl: productBrand.bannerMobile.toEmptyStringNonNull,
              )
            )
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 4.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  BrandModifiedCachedNetworkImage(
                    imageUrl: productBrand.icon.toEmptyStringNonNull,
                    dimension: profilePictureDimension,
                  ),
                  const SizedBox(width: 10),
                  Text(productBrand.name, style: const TextStyle(fontWeight: FontWeight.bold))
                ]
              )
            )
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 4.w),
              child: BrandModifiedCachedNetworkImage(
                imageUrl: productBrand.icon.toEmptyStringNonNull,
                dimension: profilePictureDimension,
              ),
            )
          ),
        ]
      )
    );
  }
}