import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/number_ext.dart';

import '../../../domain/entity/order/order_product_inventory.dart';
import '../../../domain/entity/order/support_order_product.dart';
import '../../../misc/constant.dart';
import '../modifiedcachednetworkimage/product_modified_cached_network_image.dart';

class OrderProductInventoryItem extends StatelessWidget {
  final OrderProductInventory orderProductInventory;

  const OrderProductInventoryItem({
    super.key,
    required this.orderProductInventory
  });

  @override
  Widget build(BuildContext context) {
    SupportOrderProduct supportOrderProduct = orderProductInventory.productEntry;
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
        const SizedBox(width: 20),
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
              const SizedBox(height: 3),
              Text(
                supportOrderProduct.orderPrice.toRupiah()
              ),
              const SizedBox(height: 3),
              Text(
                "${orderProductInventory.status}${orderProductInventory.quantity} ${"Item".tr}",
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: orderProductInventory.status == "+" ? Constant.colorSuccessGreen : Constant.colorRedDanger
                )
              )
            ]
          ),
        ),
      ]
    );
  }
}