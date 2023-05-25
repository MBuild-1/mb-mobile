import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/number_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../../domain/entity/order/combined_order.dart';
import '../../../domain/entity/order/order_product_detail.dart';
import '../../../domain/entity/order/support_order_product.dart';
import '../../../misc/constant.dart';
import '../../../misc/date_util.dart';
import '../../../misc/multi_language_string.dart';
import '../../../misc/page_restoration_helper.dart';
import '../../../misc/string_util.dart';
import '../button/custombutton/sized_outline_gradient_button.dart';
import '../colorful_chip.dart';
import '../modified_divider.dart';
import '../modified_svg_picture.dart';
import '../modifiedcachednetworkimage/product_modified_cached_network_image.dart';
import 'order_product_detail_item.dart';

abstract class OrderItem extends StatelessWidget {
  final CombinedOrder order;

  @protected
  double? get itemWidth;

  const OrderItem({
    super.key,
    required this.order
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: itemWidth,
      child: Material(
        borderRadius: BorderRadius.circular(16.0),
        child: InkWell(
          onTap: () => PageRestorationHelper.toOrderDetailPage(context, order.id),
          borderRadius: BorderRadius.circular(16.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(16.0)
            ),
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
                          Text("Shopping".tr, style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(DateUtil.standardDateFormat7.format(order.createdAt))
                        ]
                      ),
                    ),
                    ColorfulChip(
                      text: order.status,
                      color: Colors.grey.shade300
                    ),
                  ]
                ),
                const SizedBox(height: 12),
                const ModifiedDivider(),
                const SizedBox(height: 12),
                ..._allOrderProductDetailWidget(order.orderProduct.orderProductDetailList),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Shopping Total".tr),
                          const SizedBox(height: 3),
                          Text(
                            order.orderProduct.orderDetail.totalPrice.toRupiah(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17
                            ),
                          )
                        ]
                      ),
                    ),
                    SizedOutlineGradientButton(
                      onPressed: () {
                        Map<String, dynamic> webViewerParameter = <String, dynamic>{
                          Constant.textEncodedUrlKey: StringUtil.encodeBase64String("https://app.midtrans.com/snap/v2/vtweb/${order.orderProduct.orderDetail.snapToken}")
                        };
                        PageRestorationHelper.toWebViewerPage(context, webViewerParameter);
                      },
                      text: "Pay".tr,
                      customPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      outlineGradientButtonType: OutlineGradientButtonType.solid,
                      outlineGradientButtonVariation: OutlineGradientButtonVariation.variation2,
                    )
                  ],
                )
              ],
            )
          )
        )
      )
    );
  }

  List<Widget> _allOrderProductDetailWidget(List<OrderProductDetail> orderProductDetailList) {
    if (orderProductDetailList.isEmpty) {
      return [
        Text(
          MultiLanguageString({
            Constant.textEnUsLanguageKey: "No product.",
            Constant.textInIdLanguageKey: "Tidak ada produk.",
          }).toEmptyStringNonNull
        )
      ];
    }
    return [
      OrderProductDetailItem(
        orderProductDetail: orderProductDetailList.first
      ),
      if (orderProductDetailList.length > 1)
        ...[
          const SizedBox(height: 12),
          Text(
            MultiLanguageString({
              Constant.textEnUsLanguageKey: "+${orderProductDetailList.length - 1} other product",
              Constant.textInIdLanguageKey: "+${orderProductDetailList.length - 1} produk lainnya",
            }).toEmptyStringNonNull
          )
        ]
    ];
  }
}