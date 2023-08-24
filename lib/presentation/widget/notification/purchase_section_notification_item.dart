import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../misc/constant.dart';
import '../../../misc/multi_language_string.dart';
import '../../../misc/page_restoration_helper.dart';
import '../modified_svg_picture.dart';
import '../tap_area.dart';
import 'purchase_section_notification_step.dart';

class PurchaseSectionNotificationItem extends StatelessWidget {
  const PurchaseSectionNotificationItem({super.key});

  @override
  Widget build(BuildContext context) {
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
                  color: Constant.colorMain
                ),
              ),
            ),
          ]
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: PurchaseSectionNotificationStep(
                icon: ModifiedSvgPicture.asset(
                  Constant.vectorStep1WaitingConfirmation,
                  overrideDefaultColorWithSingleColor: false
                ),
                text: Text(
                  MultiLanguageString({
                    Constant.textEnUsLanguageKey: "Waiting Confirmation",
                    Constant.textInIdLanguageKey: "Menunggu Konfirmasi"
                  }).toString(),
                  textAlign: TextAlign.center,
                )
              ),
            ),
            Expanded(
              child: PurchaseSectionNotificationStep(
                icon: ModifiedSvgPicture.asset(
                  Constant.vectorStep2IsBeingProcessed,
                  overrideDefaultColorWithSingleColor: false
                ),
                text: Text(
                  MultiLanguageString({
                    Constant.textEnUsLanguageKey: "Is Being Processed",
                    Constant.textInIdLanguageKey: "Pesanan Diproses"
                  }).toString(),
                  textAlign: TextAlign.center,
                )
              ),
            ),
            Expanded(
              child: PurchaseSectionNotificationStep(
                icon: ModifiedSvgPicture.asset(
                  Constant.vectorStep3ReadyToSend,
                  overrideDefaultColorWithSingleColor: false
                ),
                text: Text(
                  MultiLanguageString({
                    Constant.textEnUsLanguageKey: "Ready To Send",
                    Constant.textInIdLanguageKey: "Siap Dikirim"
                  }).toString(),
                  textAlign: TextAlign.center,
                )
              ),
            ),
            Expanded(
              child: PurchaseSectionNotificationStep(
                icon: ModifiedSvgPicture.asset(
                  Constant.vectorStep4IsSending,
                  overrideDefaultColorWithSingleColor: false
                ),
                text: Text(
                  MultiLanguageString({
                    Constant.textEnUsLanguageKey: "Is Sending",
                    Constant.textInIdLanguageKey: "Sedang Dikirim"
                  }).toString(),
                  textAlign: TextAlign.center,
                )
              ),
            ),
            Expanded(
              child: PurchaseSectionNotificationStep(
                icon: ModifiedSvgPicture.asset(
                  Constant.vectorStep5IsArrived,
                  overrideDefaultColorWithSingleColor: false
                ),
                text: Text(
                  MultiLanguageString({
                    Constant.textEnUsLanguageKey: "Is Arrived",
                    Constant.textInIdLanguageKey: "Sampai Tujuan"
                  }).toString(),
                  textAlign: TextAlign.center,
                )
              ),
            ),
          ]
        )
      ]
    );
  }
}