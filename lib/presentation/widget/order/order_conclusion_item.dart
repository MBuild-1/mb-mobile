import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../domain/entity/delivery/delivery_review.dart';
import '../../../domain/entity/order/combined_order.dart';
import '../../../domain/entity/order/order_shipping.dart';
import '../../../misc/constant.dart';
import '../../../misc/dialog_helper.dart';
import '../../../misc/main_route_observer.dart';
import '../../../misc/multi_language_string.dart';
import '../../../misc/web_helper.dart';
import '../../page/modaldialogpage/give_review_delivery_review_detail_modal_dialog_page.dart';
import '../button/custombutton/sized_outline_gradient_button.dart';

class OrderConclusionItem extends StatelessWidget {
  final CombinedOrder order;
  final bool inOrderDetail;
  final void Function(CombinedOrder) onBuyAgainTap;
  final void Function() onPayOrderShipping;
  final void Function(CombinedOrder) onConfirmArrived;

  const OrderConclusionItem({
    super.key,
    required this.order,
    this.inOrderDetail = false,
    required this.onBuyAgainTap,
    required this.onPayOrderShipping,
    required this.onConfirmArrived
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // if (inOrderDetail) ...[
        //   Builder(
        //     builder: (context) {
        //       bool showPayButton = false;
        //       if (order.orderProduct.orderDetail.status == "pending") {
        //         showPayButton = true;
        //       }
        //       if (showPayButton) {
        //         return Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             const SizedBox(height: 15),
        //             SizedOutlineGradientButton(
        //               onPressed: () async {
        //                 DialogHelper.showLoadingDialog(context);
        //                 await WebHelper.launchUrl(
        //                   Uri.parse("${Constant.envValueMidtransSnapUrl}${order.orderProduct.orderDetail.snapToken}")
        //                 );
        //                 Get.back();
        //               },
        //               text: "Pay".tr,
        //               customPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        //               outlineGradientButtonType: OutlineGradientButtonType.solid,
        //               outlineGradientButtonVariation: OutlineGradientButtonVariation.variation2,
        //             )
        //           ]
        //         );
        //       } else {
        //         return Container();
        //       }
        //     }
        //   ),
        // ],
        Builder(
          builder: (context) {
            bool showOrderShippingPayment = false;
            if (order.orderShipping != null) {
              OrderShipping orderShipping = order.orderShipping!;
              if (orderShipping.orderDetail.status == "pending") {
                if (!orderShipping.isPaymentTriggered) {
                  showOrderShippingPayment = true;
                }
              }
            }
            if (showOrderShippingPayment) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Builder(
                    builder: (context) {
                      return Container(
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            MultiLanguageString({
                              Constant.textEnUsLanguageKey: "Attention! Please pay the shipping costs so that the order can be processed immediately.",
                              Constant.textInIdLanguageKey: "Perhatian! Silahkan lakukan pembayaran biaya pengiriman agar pesanan dapat segera di proses.",
                            }).toEmptyStringNonNull
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: Colors.amberAccent.withOpacity(0.5)
                        ),
                      );
                    }
                  ),
                  const SizedBox(height: 12),
                  SizedOutlineGradientButton(
                    onPressed: onPayOrderShipping,
                    text: "Pay".tr,
                    customPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    outlineGradientButtonType: OutlineGradientButtonType.solid,
                    outlineGradientButtonVariation: OutlineGradientButtonVariation.variation2,
                  )
                ],
              );
            } else {
              return Container();
            }
          }
        ),
        Builder(
          builder: (context) {
            if (order.status.toLowerCase() == "sampai tujuan") {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: SizedOutlineGradientButton(
                          onPressed: () => onBuyAgainTap(order),
                          text: "Buy Again".tr,
                          customPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                          outlineGradientButtonType: OutlineGradientButtonType.outline,
                          outlineGradientButtonVariation: OutlineGradientButtonVariation.variation2,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedOutlineGradientButton(
                          onPressed: order.review == 1 ? null : () async {
                            dynamic result = await DialogHelper.showModalBottomDialogPage<bool, GiveReviewDeliveryReviewDetailModalDialogPageParameter>(
                              context: context,
                              modalDialogPageBuilder: (context, parameter) => GiveReviewDeliveryReviewDetailModalDialogPage(
                                giveReviewDeliveryReviewDetailModalDialogPageParameter: parameter!,
                              ),
                              parameter: GiveReviewDeliveryReviewDetailModalDialogPageParameter(
                                selectedRating: 5,
                                combinedOrderId: order.id,
                                countryId: () {
                                  String orderAddressCountryId = (order.orderAddress?.countryId).toEmptyStringNonNull;
                                  if (orderAddressCountryId.isNotEmptyString) {
                                    return orderAddressCountryId;
                                  }
                                  String userAddressCountryId = (order.orderProduct.userAddress?.countryId).toEmptyStringNonNull;
                                  return userAddressCountryId;
                                }(),
                                orderCode: order.orderCode
                              )
                            );
                            if (result is bool) {
                              MainRouteObserver.onRefreshDeliveryReview?.refresh();
                              if (MainRouteObserver.onRefreshOrderList != null) {
                                MainRouteObserver.onRefreshOrderList!();
                              }
                              if (MainRouteObserver.onRefreshOrderDetailAfterDeliveryReview != null) {
                                MainRouteObserver.onRefreshOrderDetailAfterDeliveryReview!();
                              }
                            }
                          },
                          text: "Give Shipping Review".tr,
                          customPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                          outlineGradientButtonType: OutlineGradientButtonType.solid,
                          outlineGradientButtonVariation: OutlineGradientButtonVariation.variation2,
                        ),
                      ),
                    ],
                  )
                ],
              );
            } else {
              return Container();
            }
          }
        ),
        Builder(
          builder: (BuildContext context) {
            if (order.status.toLowerCase() == "sedang dikirim") {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  SizedOutlineGradientButton(
                    onPressed:() => onConfirmArrived(order),
                    text: "Confirm Arrived".tr,
                    customPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    outlineGradientButtonType: OutlineGradientButtonType.solid,
                    outlineGradientButtonVariation: OutlineGradientButtonVariation.variation2,
                  )
                ]
              );
            } else {
              return Container();
            }
          },
        )
      ],
    );
  }
}