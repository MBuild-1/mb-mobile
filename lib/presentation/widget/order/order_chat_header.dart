import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../../../domain/entity/order/combined_order.dart';
import '../../../domain/entity/order/order.dart';
import '../../../domain/entity/order/order_product_detail.dart';
import '../../../misc/constant.dart';
import '../../../misc/date_util.dart';
import '../../../misc/errorprovider/error_provider.dart';
import '../../../misc/load_data_result.dart';
import '../colorful_chip.dart';
import '../loaddataresultimplementer/load_data_result_implementer_directly.dart';
import '../modified_svg_picture.dart';
import 'order_type.dart';

class OrderChatHeader extends StatelessWidget {
  final LoadDataResult<Order> orderLoadDataResult;
  final ErrorProvider errorProvider;

  const OrderChatHeader({
    super.key,
    required this.orderLoadDataResult,
    required this.errorProvider
  });

  @override
  Widget build(BuildContext context) {
    return LoadDataResultImplementerDirectlyWithDefault(
      loadDataResult: orderLoadDataResult,
      errorProvider: errorProvider,
      onImplementLoadDataResultDirectlyWithDefault: (orderLoadDataResult, errorProvider, defaultLoadDataResultWidget) {
        if (orderLoadDataResult.isFailed) {
          return defaultLoadDataResultWidget.failedLoadDataResultWidget(
            context, orderLoadDataResult as FailedLoadDataResult, errorProvider
          );
        }
        if (orderLoadDataResult.isNotLoading) {
          return defaultLoadDataResultWidget.noLoadDataResultWidget(
            context, orderLoadDataResult as NoLoadDataResult
          );
        }
        if (orderLoadDataResult.isLoading) {
          return defaultLoadDataResultWidget.isLoadingLoadDataResultWidget(
            context, orderLoadDataResult as IsLoadingLoadDataResult
          );
        }
        return SizedBox(
          child: Material(
            borderRadius: BorderRadius.circular(8.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(8.0),
              child: Builder(
                builder: (context) {
                  CombinedOrder combinedOrder = orderLoadDataResult.resultIfSuccess!.combinedOrder;
                  Widget result = Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ModifiedSvgPicture.asset(Constant.vectorOrderBag, overrideDefaultColorWithSingleColor: false),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        combinedOrder.orderCode,
                                        style: const TextStyle(fontWeight: FontWeight.bold)
                                      ),
                                    ]
                                  ),
                                ),
                              ]
                            ),
                          ],
                        ),
                      ),
                    ],
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