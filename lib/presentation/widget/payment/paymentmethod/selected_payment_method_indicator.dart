import 'package:flutter/material.dart';

import '../../../../domain/entity/payment/payment_method.dart';
import '../../../../misc/constant.dart';
import '../../modified_svg_picture.dart';
import '../../modifiedcachednetworkimage/payment_method_modified_cached_network_image.dart';
import '../../tap_area.dart';

class SelectedPaymentMethodIndicator extends StatelessWidget {
  final VoidCallback? onTap;
  final VoidCallback? onRemove;
  final PaymentMethod selectedPaymentMethod;

  const SelectedPaymentMethodIndicator({
    super.key,
    this.onTap,
    this.onRemove,
    required this.selectedPaymentMethod
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem, vertical: 5.0),
          child: Row(
            children: [
              SizedBox(
                height: 30,
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: ClipRRect(
                    child: PaymentMethodModifiedCachedNetworkImage(
                      imageUrl: selectedPaymentMethod.paymentImage,
                    )
                  ),
                ),
              ),
              const SizedBox(width: 20.0),
              Expanded(
                child: Text(selectedPaymentMethod.paymentType)
              ),
              const SizedBox(width: 20.0),
              TapArea(
                onTap: onRemove,
                child: const Icon(Icons.close)
              ),
            ]
          )
        )
      )
    );
  }
}