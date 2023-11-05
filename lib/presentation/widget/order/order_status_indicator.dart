import 'package:flutter/material.dart';

import '../../../misc/constant.dart';
import '../../../misc/multi_language_string.dart';
import '../modified_svg_picture.dart';
import '../notification/purchase_section_notification_step.dart';

class OrderStatusIndicator extends StatefulWidget {
  final int step;
  final bool isLoadingStep;

  const OrderStatusIndicator({
    super.key,
    required this.step,
    required this.isLoadingStep
  });

  @override
  State<OrderStatusIndicator> createState() => _OrderStatusIndicatorState();
}

class _OrderStatusIndicatorState extends State<OrderStatusIndicator> with AutomaticKeepAliveClientMixin<OrderStatusIndicator> {
  final GlobalKey _waitingConfirmationGlobalKey = GlobalKey();
  final GlobalKey _isBeingProcessedGlobalKey = GlobalKey();
  final GlobalKey _readyToSendGlobalKey = GlobalKey();
  final GlobalKey _isSendingGlobalKey = GlobalKey();
  final GlobalKey _isArrivedGlobalKey = GlobalKey();
  double? _height;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Size? waitingConfirmationSize = (_waitingConfirmationGlobalKey.currentContext?.findRenderObject() as RenderBox?)?.size;
      Size? isBeingProcessedSize = (_isBeingProcessedGlobalKey.currentContext?.findRenderObject() as RenderBox?)?.size;
      Size? readyToSendSize = (_readyToSendGlobalKey.currentContext?.findRenderObject() as RenderBox?)?.size;
      Size? isSendingSize = (_isSendingGlobalKey.currentContext?.findRenderObject() as RenderBox?)?.size;
      Size? isArrivedSize = (_isArrivedGlobalKey.currentContext?.findRenderObject() as RenderBox?)?.size;
      double? newHeight;
      void checkNewHeight(double newHeightValue) {
        if (newHeight == null) {
          newHeight = newHeightValue;
        } else {
          if (newHeightValue > newHeight!) {
            newHeight = newHeightValue;
          }
        }
      }
      if (waitingConfirmationSize != null) {
        checkNewHeight(waitingConfirmationSize.height);
      }
      if (isBeingProcessedSize != null) {
        checkNewHeight(isBeingProcessedSize.height);
      }
      if (readyToSendSize != null) {
        checkNewHeight(readyToSendSize.height);
      }
      if (isSendingSize != null) {
        checkNewHeight(isSendingSize.height);
      }
      if (isArrivedSize != null) {
        checkNewHeight(isArrivedSize.height);
      }
      if (_height != newHeight) {
        setState(() {
          _height = newHeight;
        });
      }
    });
    double iconSize = 40.0;
    return Visibility(
      visible: _height != null,
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: PurchaseSectionNotificationStep(
                  height: _height,
                  key: _waitingConfirmationGlobalKey,
                  icon: (active) => ModifiedSvgPicture.asset(
                    active ? Constant.vectorStep1WaitingConfirmation : Constant.vectorStep1WaitingConfirmationGreyscale,
                    overrideDefaultColorWithSingleColor: false,
                    width: iconSize,
                    height: iconSize,
                  ),
                  activeValue: widget.step >= 1,
                  lineRemovalValue: -1,
                  isLineLeftActive: widget.step >= 1,
                  isLineRightActive: widget.step >= 1,
                  text: Text(
                    MultiLanguageString({
                      Constant.textEnUsLanguageKey: "Waiting Confirmation",
                      Constant.textInIdLanguageKey: "Menunggu Konfirmasi"
                    }).toString(),
                    style: const TextStyle(
                      fontSize: 12.0
                    ),
                    textAlign: TextAlign.center,
                  ),
                  isLoadingStep: widget.isLoadingStep,
                ),
              ),
              Expanded(
                child: PurchaseSectionNotificationStep(
                  height: _height,
                  key: _isBeingProcessedGlobalKey,
                  icon: (active) => ModifiedSvgPicture.asset(
                    active ? Constant.vectorStep2IsBeingProcessed : Constant.vectorStep2IsBeingProcessedGreyscale,
                    overrideDefaultColorWithSingleColor: false,
                    width: iconSize,
                    height: iconSize,
                  ),
                  activeValue: widget.step >= 2,
                  lineRemovalValue: 0,
                  isLineLeftActive: widget.step >= 1,
                  isLineRightActive: widget.step >= 2,
                  text: Text(
                    MultiLanguageString({
                      Constant.textEnUsLanguageKey: "Is Being Processed",
                      Constant.textInIdLanguageKey: "Pesanan Diproses"
                    }).toString(),
                    style: const TextStyle(
                      fontSize: 12.0
                    ),
                    textAlign: TextAlign.center,
                  ),
                  isLoadingStep: widget.isLoadingStep,
                ),
              ),
              Expanded(
                child: PurchaseSectionNotificationStep(
                  height: _height,
                  key: _readyToSendGlobalKey,
                  icon: (active) => ModifiedSvgPicture.asset(
                    active ? Constant.vectorStep3ReadyToSend : Constant.vectorStep3ReadyToSendGreyscale,
                    overrideDefaultColorWithSingleColor: false,
                    width: iconSize,
                    height: iconSize,
                  ),
                  activeValue: widget.step >= 3,
                  lineRemovalValue: 0,
                  isLineLeftActive: widget.step >= 2,
                  isLineRightActive: widget.step >= 3,
                  text: Text(
                    MultiLanguageString({
                      Constant.textEnUsLanguageKey: "Ready To Send",
                      Constant.textInIdLanguageKey: "Siap Dikirim"
                    }).toString(),
                    style: const TextStyle(
                      fontSize: 12.0
                    ),
                    textAlign: TextAlign.center,
                  ),
                  isLoadingStep: widget.isLoadingStep,
                ),
              ),
              Expanded(
                child: PurchaseSectionNotificationStep(
                  height: _height,
                  key: _isSendingGlobalKey,
                  icon: (active) => ModifiedSvgPicture.asset(
                    active ? Constant.vectorStep4IsSending : Constant.vectorStep4IsSendingGreyscale,
                    overrideDefaultColorWithSingleColor: false,
                    width: iconSize,
                    height: iconSize,
                  ),
                  activeValue: widget.step >= 4,
                  lineRemovalValue: 0,
                  isLineLeftActive: widget.step >= 3,
                  isLineRightActive: widget.step >= 4,
                  text: Text(
                    MultiLanguageString({
                      Constant.textEnUsLanguageKey: "Is Sending",
                      Constant.textInIdLanguageKey: "Sedang Dikirim"
                    }).toString(),
                    style: const TextStyle(
                      fontSize: 12.0
                    ),
                    textAlign: TextAlign.center,
                  ),
                  isLoadingStep: widget.isLoadingStep,
                ),
              ),
              Expanded(
                child: PurchaseSectionNotificationStep(
                  height: _height,
                  key: _isArrivedGlobalKey,
                  icon: (active) => ModifiedSvgPicture.asset(
                    active ? Constant.vectorStep5IsArrived : Constant.vectorStep5IsArrivedGreyscale,
                    overrideDefaultColorWithSingleColor: false,
                    width: iconSize,
                    height: iconSize,
                  ),
                  activeValue: widget.step >= 5,
                  lineRemovalValue: 1,
                  isLineLeftActive: widget.step >= 4,
                  isLineRightActive: widget.step >= 5,
                  text: Text(
                    MultiLanguageString({
                      Constant.textEnUsLanguageKey: "Is Arrived",
                      Constant.textInIdLanguageKey: "Sampai Tujuan"
                    }).toString(),
                    style: const TextStyle(
                      fontSize: 12.0
                    ),
                    textAlign: TextAlign.center,
                  ),
                  isLoadingStep: widget.isLoadingStep,
                ),
              ),
            ]
          ),
          // const SizedBox(height: 12),
          // Builder(
          //   builder: (context) {
          //     bool determineFinishStatus() {
          //       if (widget.step > 1) {
          //         if (widget.step == 5) {
          //           return true;
          //         }
          //         return false;
          //       } else {
          //         return false;
          //       }
          //     }
          //     Widget result = Row(
          //       children: [
          //         Expanded(
          //           child: Text(
          //             () {
          //               if (widget.step > 1) {
          //                 return "Product Delivery".tr;
          //               } else {
          //                 return "Product Payment".tr;
          //               }
          //             }(),
          //             style: TextStyle(
          //               fontWeight: FontWeight.bold,
          //               backgroundColor: widget.isLoadingStep ? Colors.grey : null
          //             ),
          //           )
          //         ),
          //         Container(
          //           padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(8.0),
          //             color: determineFinishStatus() ? Constant.colorSuccessLightGreen : Constant.colorRedDanger,
          //           ),
          //           child: Text(
          //             determineFinishStatus() ? "Finish".tr : "Not Finish".tr,
          //             style: TextStyle(
          //               fontSize: 12,
          //               fontWeight: FontWeight.bold,
          //               color: determineFinishStatus() ? null : Colors.white,
          //             ),
          //           ),
          //         )
          //       ]
          //     );
          //     return widget.isLoadingStep ? ModifiedShimmer.fromColors(child: result) : result;
          //   }
          // ),
        ]
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}