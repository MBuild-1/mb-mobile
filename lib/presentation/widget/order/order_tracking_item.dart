import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/number_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../../domain/entity/order/ordertracking/order_tracking.dart';
import '../../../misc/constant.dart';
import '../../../misc/toast_helper.dart';
import '../colorful_chip.dart';
import '../tap_area.dart';

class OrderTrackingItem extends StatelessWidget {
  final OrderTracking orderTracking;
  final void Function()? onTap;

  const OrderTrackingItem({
    super.key,
    required this.orderTracking,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Material(
        borderRadius: BorderRadius.circular(8.0),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8.0),
          child: Builder(
            builder: (context) {
              Widget result = Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          String trackingNumber = orderTracking.trackingNumber.toStringNonNull;
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    trackingNumber,
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Text(
                                    "${"Weight".tr}: ${orderTracking.weight.toWeightStringDecimalPlaced()} Kg",
                                    style: const TextStyle(
                                      fontSize: 13.0
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 8.0),
                              TapArea(
                                onTap: () {
                                  dynamic rawClipboardData = trackingNumber;
                                  ClipboardData? clipboardData;
                                  if (rawClipboardData is String) {
                                    clipboardData = ClipboardData(text: rawClipboardData);
                                  } else if (rawClipboardData is num) {
                                    clipboardData = ClipboardData(text: rawClipboardData.toString());
                                  }
                                  if (clipboardData != null) {
                                    Clipboard.setData(clipboardData);
                                    ToastHelper.showToast("${"Success copied".tr}.");
                                  } else {
                                    ToastHelper.showToast("${"Cannot copy this content".tr}.");
                                  }
                                },
                                child: const Icon(
                                  Icons.copy,
                                  size: 18
                                )
                              ),
                            ],
                          );
                        }
                      ),
                    ),
                    ColorfulChip(
                      text: orderTracking.arrived == 1 ? "Arrived".tr : "Not Arrived".tr,
                      textStyle: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                        color: orderTracking.arrived == 1 ? null : Colors.white
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
                      color: orderTracking.arrived == 1 ? Constant.colorSuccessLightGreen : Constant.colorRedDanger
                    ),
                  ],
                ),
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
  }
}