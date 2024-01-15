import 'package:flutter/material.dart';

import '../../../../misc/constant.dart';
import '../../modifiedcachednetworkimage/payment_method_modified_cached_network_image.dart';
import 'payment_method_item.dart';

class VerticalGridPaymentMethodItem extends PaymentMethodItem {
  const VerticalGridPaymentMethodItem({
    super.key,
    required super.paymentMethod,
    required super.onSelectPaymentMethod,
    required super.isSelected
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? Constant.colorLightOrange : null,
      elevation: 3,
      borderRadius: BorderRadius.circular(10.0),
      child: InkWell(
        onTap: onSelectPaymentMethod != null ? () => onSelectPaymentMethod!(paymentMethod) : null,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
          height: 50,
          child: ClipRRect(
            child: PaymentMethodModifiedCachedNetworkImage(
              imageUrl: paymentMethod.paymentImage,
              boxFit: BoxFit.scaleDown,
            )
          ),
        )
      )
    );
  }
}