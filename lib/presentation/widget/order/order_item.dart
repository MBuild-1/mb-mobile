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
import '../button/custombutton/sized_outline_gradient_button.dart';
import '../modified_divider.dart';
import '../modified_svg_picture.dart';
import '../modifiedcachednetworkimage/product_modified_cached_network_image.dart';

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
          onTap: () {},
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
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.grey.shade300,
                      ),
                      child: Text(
                        order.status,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    )
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
                      onPressed: () {},
                      text: "Buy Again".tr,
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
    return [
      _orderProductDetailWidget(orderProductDetailList.first),
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

  Widget _orderProductDetailWidget(OrderProductDetail orderProductDetail) {
    SupportOrderProduct supportOrderProduct = orderProductDetail.supportOrderProduct;
    return Row(
      children: [
        SizedBox(
          width: 70,
          child: AspectRatio(
            aspectRatio: 1.0,
            child: ClipRRect(
              child: ProductModifiedCachedNetworkImage(
                imageUrl: supportOrderProduct.orderImageUrl,
              )
            )
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                supportOrderProduct.orderTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis
                )
              ),
              Text(
                "${orderProductDetail.quantity} ${"Item".tr}",
                style: const TextStyle(
                  overflow: TextOverflow.ellipsis
                )
              )
            ]
          ),
        ),
      ]
    );
  }
}