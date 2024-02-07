import 'package:flutter/material.dart';

import '../../../domain/entity/additionalitem/additional_item.dart';

class OrderSendToWarehouseItem extends StatelessWidget {
  final AdditionalItem additionalItem;

  const OrderSendToWarehouseItem({
    super.key,
    required this.additionalItem
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                additionalItem.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis
                )
              ),
              const SizedBox(height: 3),
              Text(
                "Quantity: ${additionalItem.quantity}",
                style: const TextStyle(
                  overflow: TextOverflow.ellipsis
                )
              ),
              const SizedBox(height: 3),
              Text(
                "Price: ${additionalItem.estimationPrice}",
                style: const TextStyle(
                  overflow: TextOverflow.ellipsis
                )
              ),
            ]
          ),
        ),
      ]
    );
  }
}