import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/number_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../../../domain/entity/payment/payment_method.dart';
import '../../../../misc/constant.dart';
import '../../modifiedcachednetworkimage/payment_method_modified_cached_network_image.dart';

abstract class PaymentMethodItem extends StatelessWidget {
  final PaymentMethod paymentMethod;
  final void Function(PaymentMethod)? onSelectPaymentMethod;
  final bool isSelected;

  const PaymentMethodItem({
    super.key,
    required this.paymentMethod,
    required this.onSelectPaymentMethod,
    required this.isSelected
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? Constant.colorLightOrange : null,
      child: InkWell(
        onTap: onSelectPaymentMethod != null ? () => onSelectPaymentMethod!(paymentMethod) : null,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem, vertical: 10.0),
          child: Row(
            children: [
              SizedBox(
                height: 50,
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: ClipRRect(
                    child: PaymentMethodModifiedCachedNetworkImage(
                      imageUrl: paymentMethod.paymentImage,
                    )
                  ),
                ),
              ),
              const SizedBox(width: 22.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      paymentMethod.paymentName.toStringNonNull,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0
                      )
                    ),
                    Text(
                      () {
                        String administrationFee = "${"Administration Fee".tr}: ${paymentMethod.serviceFee.toRupiah()}";
                        if (paymentMethod.taxRate != null) {
                          administrationFee += " + ${paymentMethod.taxRate}%";
                        }
                        return administrationFee;
                      }(),
                      style: const TextStyle(
                        fontSize: 13.0
                      )
                    ),
                  ],
                ),
              )
            ]
          )
        )
      )
    );
  }
}