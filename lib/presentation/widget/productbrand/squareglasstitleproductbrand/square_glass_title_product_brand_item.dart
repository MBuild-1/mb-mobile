import 'package:flutter/material.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../../../domain/entity/product/productbrand/product_brand.dart';
import '../../../../domain/entity/product/productbrand/selected_product_brand.dart';
import '../../../../misc/page_restoration_helper.dart';
import '../../../page/product_entry_page.dart';
import '../../modifiedcachednetworkimage/product_modified_cached_network_image.dart';
import '../../tap_area.dart';

abstract class SquareGlassTitleProductBrandItem extends StatelessWidget {
  final ProductBrand productBrand;

  @protected
  double? get itemWidth;

  @protected
  double? get itemHeight;

  const SquareGlassTitleProductBrandItem({
    Key? key,
    required this.productBrand
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius = BorderRadius.circular(10.0);
    String? imageUrl;
    if (productBrand is SelectedProductBrand) {
      SelectedProductBrand selectedProductBrand = productBrand as SelectedProductBrand;
      imageUrl = selectedProductBrand.bannerBrandChosenMobile ?? selectedProductBrand.bannerBrandChosenDesktop ?? selectedProductBrand.icon;
    } else {
      imageUrl = productBrand.icon;
    }
    return SizedBox(
      width: itemWidth,
      height: itemHeight,
      child: Padding(
        // Use padding widget for avoiding shadow elevation overlap.
        padding: const EdgeInsets.only(top: 1.0, bottom: 5.0),
        child: TapArea(
          onTap: () => PageRestorationHelper.toProductEntryPage(
            context,
            ProductEntryPageParameter(
              productEntryParameterMap: {
                "brand_id": productBrand.id,
                "brand": productBrand.slug
              }
            )
          ),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1.0,
                  child: ClipRRect(
                    child: ProductModifiedCachedNetworkImage(
                      imageUrl: imageUrl.toEmptyStringNonNull
                    )
                  )
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        stops: const [0.0, 1.0],
                        colors: [Colors.white.withOpacity(0.7), Colors.white],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter
                      )
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                            child: Text(
                              productBrand.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            )
                          ),
                        )
                      ],
                    ),
                  )
                )
              ],
            )
          )
        )
      )
    );
  }
}