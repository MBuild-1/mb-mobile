import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../misc/constant.dart';
import '../../../misc/multi_language_string.dart';
import '../../../misc/page_restoration_helper.dart';
import '../colorful_chip.dart';
import '../modified_shimmer.dart';
import '../modified_svg_picture.dart';
import '../order/order_status_indicator.dart';
import '../tap_area.dart';
import 'purchase_section_notification_step.dart';

class PurchaseSectionNotificationItem extends StatefulWidget {
  final int step;
  final bool isLoadingStep;

  const PurchaseSectionNotificationItem({
    super.key,
    required this.step,
    required this.isLoadingStep
  });

  @override
  State<PurchaseSectionNotificationItem> createState() => _PurchaseSectionNotificationItem();
}

class _PurchaseSectionNotificationItem extends State<PurchaseSectionNotificationItem> with AutomaticKeepAliveClientMixin<PurchaseSectionNotificationItem> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "Purchase".tr,
                style: const TextStyle(
                  fontWeight: FontWeight.bold
                ),
              )
            ),
            TapArea(
              onTap: () => PageRestorationHelper.toOrderPage(context),
              child: Text(
                "Look All".tr,
                style: TextStyle(
                  color: Constant.colorMain,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ]
        ),
        const SizedBox(height: 12),
        OrderStatusIndicator(
          step: widget.step,
          isLoadingStep: widget.isLoadingStep
        )
      ]
    );
  }

  @override
  bool get wantKeepAlive => true;
}