import 'package:flutter/material.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/number_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../../domain/entity/product/product_detail.dart';
import '../../../domain/entity/product/productbundle/product_bundle.dart';
import '../../../domain/entity/product/productentry/product_entry.dart';
import '../../../domain/entity/product/support_product_indicator.dart';
import '../../../misc/load_data_result.dart';
import '../../../misc/product_helper.dart';
import '../modified_shimmer.dart';
import '../modifiedcachednetworkimage/product_modified_cached_network_image.dart';

class ProductIndicator extends StatelessWidget {
  final LoadDataResult<SupportProductIndicator> supportProductIndicatorLoadDataResult;

  const ProductIndicator({
    super.key,
    required this.supportProductIndicatorLoadDataResult
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Builder(
            builder: (context) {
              Widget imageWidget = SizedBox(
                width: 50,
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: ClipRRect(
                    child: ProductModifiedCachedNetworkImage(
                      imageUrl: supportProductIndicatorLoadDataResult.isSuccess ? supportProductIndicatorLoadDataResult.resultIfSuccess!.productIndicatorImageUrl.toEmptyStringNonNull : "",
                    )
                  )
                ),
              );
              return supportProductIndicatorLoadDataResult.isLoading ? ModifiedShimmer.fromColors(child: imageWidget) : imageWidget;
            }
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Builder(
              builder: (context) {
                List<Widget> columnWidget = [];
                Widget returnColumnWidget() {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: columnWidget
                  );
                }
                if (supportProductIndicatorLoadDataResult.isLoading) {
                  columnWidget.addAll(<Widget>[
                    const Text(
                      "Sample Name",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.grey
                      )
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Sampe Description",
                      style: TextStyle(
                        fontSize: 15,
                        backgroundColor: Colors.grey
                      )
                    ),
                  ]);
                  return ModifiedShimmer.fromColors(
                    child: returnColumnWidget()
                  );
                }
                if (supportProductIndicatorLoadDataResult.isNotLoading) {
                  return Container();
                }
                SupportProductIndicator supportProductIndicator = supportProductIndicatorLoadDataResult.resultIfSuccess!;
                if (supportProductIndicator is ProductEntry) {
                  ProductEntry productEntry = supportProductIndicator;
                  String productVariantDescription = ProductHelper.getProductVariantDescription(productEntry);
                  columnWidget.addAll(<Widget>[
                    Text(productEntry.name),
                    if (productEntry.product.productCategory.name.isNotEmptyString)
                      ...[
                        const SizedBox(height: 5),
                        Text(productEntry.product.productCategory.name.toEmptyStringNonNull, style: const TextStyle(color: Colors.grey)),
                      ],
                    if (productVariantDescription.isNotEmptyString)
                      ...[
                        const SizedBox(height: 10),
                        Text(productVariantDescription, style: const TextStyle(color: Colors.grey)),
                      ],
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            productEntry.sellingPrice.toRupiah(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            )
                          ),
                        ),
                        Text(
                          "${productEntry.weight.toWeightStringDecimalPlaced()} Kg",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                          )
                        ),
                      ]
                    )
                  ]);
                } else if (supportProductIndicator is ProductBundle) {
                  ProductBundle productBundle = supportProductIndicator;
                  columnWidget.addAll(<Widget>[
                    Text(
                      productBundle.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                      )
                    ),
                  ]);
                } else if (supportProductIndicator is ProductDetail) {
                  ProductDetail productDetail = supportProductIndicator;
                  columnWidget.addAll(<Widget>[
                    Text(
                      productDetail.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                      )
                    ),
                    const SizedBox(height: 4),
                    Text(
                      productDetail.productCategory.name,
                      style: const TextStyle(
                        fontSize: 15
                      )
                    ),
                  ]);
                }
                return returnColumnWidget();
              }
            ),
          )
        ],
      )
    );
  }
}