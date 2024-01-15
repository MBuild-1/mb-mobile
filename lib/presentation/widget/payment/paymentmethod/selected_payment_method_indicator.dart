import 'package:flutter/material.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../../../domain/entity/payment/payment_method.dart';
import '../../../../misc/constant.dart';
import '../../../../misc/multi_language_string.dart';
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
    return TapArea(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem, vertical: 5.0),
        child: Row(
          children: [
            SizedBox(
              width: 50,
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
              child: Column(
                children: [
                  Text(
                    MultiLanguageString({
                      Constant.textInIdLanguageKey: "(Tekan untuk memilih kembali metode pembayaran.)",
                      Constant.textEnUsLanguageKey: "(Tap for select again payment method.)"
                    }).toStringNonNull
                  )
                ],
              )
            ),
            const SizedBox(width: 20.0),
            TapArea(
              onTap: onRemove,
              child: const Icon(Icons.close)
            ),
          ]
        )
      )
    );
  }
}