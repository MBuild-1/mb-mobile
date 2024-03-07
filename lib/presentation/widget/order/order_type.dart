import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/entity/order/combined_order.dart';
import '../../../domain/entity/order/order_product_detail.dart';

class OrderType extends StatelessWidget {
  final CombinedOrder combinedOrder;

  const OrderType({
    super.key,
    required this.combinedOrder
  });

  @override
  Widget build(BuildContext context) {
    List<OrderProductDetail> orderProductDetailList = combinedOrder.orderProduct.orderProductDetailList;
    return Text(
      orderProductDetailList.isEmpty ? "Personal Stuffs".tr : "Shopping".tr,
      style: const TextStyle(fontWeight: FontWeight.bold)
    );
  }
}