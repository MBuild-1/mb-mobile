import 'package:flutter/material.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../../../domain/entity/product/product_detail.dart';
import '../../../domain/entity/product/support_product_indicator.dart';
import '../../../misc/errorprovider/error_provider.dart';
import '../../../misc/load_data_result.dart';
import '../loaddataresultimplementer/load_data_result_implementer_directly.dart';
import 'product_indicator.dart';

class ProductChatHeader extends StatelessWidget {
  final LoadDataResult<ProductDetail> productDetailLoadDataResult;
  final ErrorProvider errorProvider;
  final void Function(ProductDetail) onTap;

  const ProductChatHeader({
    super.key,
    required this.productDetailLoadDataResult,
    required this.errorProvider,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return LoadDataResultImplementerDirectlyWithDefault(
      loadDataResult: productDetailLoadDataResult,
      errorProvider: errorProvider,
      onImplementLoadDataResultDirectlyWithDefault: (productDetailLoadDataResult, errorProvider, defaultLoadDataResultWidget) {
        if (productDetailLoadDataResult.isFailed) {
          return defaultLoadDataResultWidget.failedLoadDataResultWidget(
            context, productDetailLoadDataResult as FailedLoadDataResult, errorProvider
          );
        }
        if (productDetailLoadDataResult.isNotLoading) {
          return defaultLoadDataResultWidget.noLoadDataResultWidget(
            context, productDetailLoadDataResult as NoLoadDataResult
          );
        }
        if (productDetailLoadDataResult.isLoading) {
          return defaultLoadDataResultWidget.isLoadingLoadDataResultWidget(
            context, productDetailLoadDataResult as IsLoadingLoadDataResult
          );
        }
        return SizedBox(
          child: Material(
            borderRadius: BorderRadius.circular(8.0),
            child: InkWell(
              onTap: productDetailLoadDataResult.isSuccess ? () => onTap(productDetailLoadDataResult.resultIfSuccess!) : null,
              borderRadius: BorderRadius.circular(8.0),
              child: Builder(
                builder: (context) {
                  Widget result = ProductIndicator(
                    supportProductIndicatorLoadDataResult: productDetailLoadDataResult.map<SupportProductIndicator>(
                      (productDetail) => productDetail
                    ),
                  );
                  return Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Visibility(
                          visible: false,
                          maintainState: true,
                          maintainAnimation: true,
                          maintainSize: true,
                          child: result,
                        )
                      ),
                      Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: result,
                      )
                    ],
                  );
                }
              )
            )
          )
        );
      },
    );
  }
}