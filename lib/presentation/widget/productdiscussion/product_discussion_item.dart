import 'package:flutter/material.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/number_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../../domain/entity/discussion/support_discussion.dart';
import '../../../domain/entity/product/product_detail.dart';
import '../../../domain/entity/product/productbundle/product_bundle.dart';
import '../../../domain/entity/product/productdiscussion/product_discussion.dart';
import '../../../domain/entity/product/productentry/product_entry.dart';
import '../../../misc/errorprovider/error_provider.dart';
import '../../../misc/load_data_result.dart';
import '../../../misc/product_helper.dart';
import '../loaddataresultimplementer/load_data_result_implementer.dart';
import '../loaddataresultimplementer/load_data_result_implementer_directly.dart';
import '../modified_shimmer.dart';
import '../modifiedcachednetworkimage/product_modified_cached_network_image.dart';

abstract class ProductDiscussionItem extends StatelessWidget {
  final ProductDiscussion productDiscussion;
  final bool isExpanded;
  final void Function(ProductDiscussion)? onProductDiscussionTap;
  final LoadDataResult<SupportDiscussion> supportDiscussionLoadDataResult;
  final ErrorProvider errorProvider;

  @protected
  double? get itemWidth;

  const ProductDiscussionItem({
    super.key,
    required this.productDiscussion,
    required this.isExpanded,
    required this.supportDiscussionLoadDataResult,
    required this.errorProvider,
    this.onProductDiscussionTap,
  });

  @override
  Widget build(BuildContext context) {
    return LoadDataResultImplementerDirectlyWithDefault(
      loadDataResult: supportDiscussionLoadDataResult,
      errorProvider: errorProvider,
      onImplementLoadDataResultDirectlyWithDefault: (supportDiscussionLoadDataResult, errorProvider, defaultLoadDataResultWidget) {
        if (supportDiscussionLoadDataResult.isFailed) {
          return defaultLoadDataResultWidget.failedLoadDataResultWidget(
            context, supportDiscussionLoadDataResult as FailedLoadDataResult, errorProvider
          );
        }
        return SizedBox(
          width: itemWidth,
          child: Material(
            child: InkWell(
              onTap: onProductDiscussionTap != null ? () => onProductDiscussionTap!(productDiscussion) : null,
              child: Container(
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
                                imageUrl: supportDiscussionLoadDataResult.isSuccess ? supportDiscussionLoadDataResult.resultIfSuccess!.discussionImageUrl.toEmptyStringNonNull : "",
                              )
                            )
                          ),
                        );
                        return supportDiscussionLoadDataResult.isLoading ? ModifiedShimmer.fromColors(child: imageWidget) : imageWidget;
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
                          if (supportDiscussionLoadDataResult.isLoading) {
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
                          if (supportDiscussionLoadDataResult.isNotLoading) {
                            return Container();
                          }
                          SupportDiscussion supportDiscussion = supportDiscussionLoadDataResult.resultIfSuccess!;
                          if (supportDiscussion is ProductEntry) {
                            ProductEntry productEntry = supportDiscussion;
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
                          } else if (supportDiscussion is ProductBundle) {
                            ProductBundle productBundle = supportDiscussion;
                            columnWidget.addAll(<Widget>[
                              Text(
                                productBundle.name,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                                )
                              ),
                            ]);
                          } else if (supportDiscussion is ProductDetail) {
                            ProductDetail productDetail = supportDiscussion;
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
              )
            )
          ),
        );
      },
    );
  }
}