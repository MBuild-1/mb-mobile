import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/number_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../domain/entity/additionalitem/additional_item.dart';
import '../../../domain/entity/order/combined_order.dart';
import '../../../domain/entity/order/order_product_detail.dart';
import '../../../misc/constant.dart';
import '../../../misc/date_util.dart';
import '../../../misc/dialog_helper.dart';
import '../../../misc/multi_language_string.dart';
import '../../../misc/page_restoration_helper.dart';
import '../../../misc/web_helper.dart';
import '../../page/order_detail_page.dart';
import '../additional_item_widget.dart';
import '../button/custombutton/sized_outline_gradient_button.dart';
import '../colorful_chip.dart';
import '../modified_divider.dart';
import '../modified_svg_picture.dart';
import 'order_conclusion_item.dart';
import 'order_product_detail_item.dart';

abstract class OrderItem extends StatelessWidget {
  final CombinedOrder order;
  final void Function(CombinedOrder) onBuyAgainTap;
  final void Function(CombinedOrder) onConfirmArrived;

  @protected
  double? get itemWidth;

  const OrderItem({
    super.key,
    required this.order,
    required this.onBuyAgainTap,
    required this.onConfirmArrived
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: itemWidth,
      child: Material(
        borderRadius: BorderRadius.circular(8.0),
        child: InkWell(
          onTap: () => PageRestorationHelper.toOrderDetailPage(context, order.id),
          borderRadius: BorderRadius.circular(8.0),
          child: Builder(
            builder: (context) {
              List<OrderProductDetail> orderProductDetailList = order.orderProduct.orderProductDetailList;
              List<AdditionalItem> additionalItemList = order.orderProduct.additionalItemList;
              Widget result = Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ModifiedSvgPicture.asset(Constant.vectorOrderBag, overrideDefaultColorWithSingleColor: false),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(orderProductDetailList.isEmpty ? "Warehouse".tr : "Shopping".tr, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Text(DateUtil.standardDateFormat7.format(order.createdAt))
                                ]
                              ),
                            ),
                            ColorfulChip(
                              text: order.status,
                              color: Colors.grey.shade300
                            ),
                          ]
                        ),
                        ...() {
                          double titleAndContentHeight = 8;
                          List<Widget> result = [];
                          bool allIsNotEmpty = orderProductDetailList.isNotEmpty && additionalItemList.isNotEmpty;
                          bool allIsEmpty = orderProductDetailList.isEmpty && additionalItemList.isEmpty;
                          if (allIsEmpty) {
                            return [const SizedBox()];
                          }
                          if (orderProductDetailList.isNotEmpty) {
                            result.add(const SizedBox(height: 12));
                            if (allIsNotEmpty) {
                              result.addAll([
                                Text("Product".tr),
                                SizedBox(height: titleAndContentHeight)
                              ]);
                            }
                            result.addAll(_allOrderProductDetailWidget(orderProductDetailList));
                          }
                          if (additionalItemList.isNotEmpty) {
                            result.add(const SizedBox(height: 12));
                            if (allIsNotEmpty) {
                              result.addAll([
                                Text("Warehouse".tr),
                                SizedBox(height: titleAndContentHeight)
                              ]);
                            }
                            result.addAll(_allOrderAdditionalItemWidget(additionalItemList));
                          }
                          return <Widget>[
                            const SizedBox(height: 12),
                            const ModifiedDivider(),
                            ...result
                          ];
                        }(),
                        Builder(
                          builder: (context) {
                            List<Widget> rowWidget = [];
                            void addRowWidget(Widget newWidget) {
                              rowWidget.addAll([
                                if (rowWidget.isNotEmpty) ...[
                                  const SizedBox(width: 10),
                                ],
                                newWidget
                              ]);
                            }
                            bool showPayButton = false;
                            if (order.orderProduct.orderDetail.status == "pending") {
                              showPayButton = true;
                            }
                            if (showPayButton) {
                              addRowWidget(
                                Expanded(
                                  child: SizedOutlineGradientButton(
                                    onPressed: () => PageRestorationHelper.toOrderDetailPage(context, order.id),
                                    text: "Pay".tr,
                                    customPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                    outlineGradientButtonType: OutlineGradientButtonType.solid,
                                    outlineGradientButtonVariation: OutlineGradientButtonVariation.variation2,
                                  ),
                                )
                              );
                            }
                            if (order.status.toLowerCase() == "sedang dikirim") {
                              addRowWidget(
                                Expanded(
                                  child: SizedOutlineGradientButton(
                                    onPressed:() => onConfirmArrived(order),
                                    text: "Confirm Arrived".tr,
                                    customPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                    outlineGradientButtonType: OutlineGradientButtonType.solid,
                                    outlineGradientButtonVariation: OutlineGradientButtonVariation.variation2,
                                  )
                                )
                              );
                            }
                            if (rowWidget.isEmpty) {
                              return const SizedBox();
                            }
                            return Column(
                              children: [
                                const SizedBox(height: 15),
                                Row(
                                  children: rowWidget
                                ),
                              ],
                            );
                          }
                        ),
                        OrderConclusionItem(
                          order: order,
                          onBuyAgainTap: onBuyAgainTap,
                          onPayOrderShipping: () => PageRestorationHelper.toOrderDetailPageWithParameter(
                            context, RedirectToShippingPaymentOrderDetailPageParameter(
                              combinedOrderId: order.id
                            )
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (order.isBucket == 1) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Shared Cart".tr,
                            style: const TextStyle(color: Colors.white)
                          ),
                        ],
                      ),
                    )
                  ]
                ],
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

  List<Widget> _allOrderProductDetailWidget(List<OrderProductDetail> orderProductDetailList) {
    if (orderProductDetailList.isEmpty) {
      return [
        Text(
          MultiLanguageString({
            Constant.textEnUsLanguageKey: "No product.",
            Constant.textInIdLanguageKey: "Tidak ada produk.",
          }).toEmptyStringNonNull
        )
      ];
    }
    return [
      OrderProductDetailItem(
        orderProductDetail: orderProductDetailList.first
      ),
      if (orderProductDetailList.length > 1)
        ...[
          const SizedBox(height: 12),
          Text(
            MultiLanguageString({
              Constant.textEnUsLanguageKey: "+${orderProductDetailList.length - 1} other product",
              Constant.textInIdLanguageKey: "+${orderProductDetailList.length - 1} produk lainnya",
            }).toEmptyStringNonNull
          )
        ]
    ];
  }

  List<Widget> _allOrderAdditionalItemWidget(List<AdditionalItem> additionalItemList) {
    if (additionalItemList.isEmpty) {
      return [
        Text(
          MultiLanguageString({
            Constant.textEnUsLanguageKey: "No additional item.",
            Constant.textInIdLanguageKey: "Tidak ada tambahan item.",
          }).toEmptyStringNonNull
        )
      ];
    }
    return [
      AdditionalItemWidget(
        additionalItem: additionalItemList.first,
        onLoadAdditionalItem: () {},
        showEditAndRemoveIcon: false,
      ),
      if (additionalItemList.length > 1)...[
        const SizedBox(height: 12),
        Text(
          MultiLanguageString({
            Constant.textEnUsLanguageKey: "+${additionalItemList.length - 1} other product",
            Constant.textInIdLanguageKey: "+${additionalItemList.length - 1} produk lainnya",
          }).toEmptyStringNonNull
        )
      ]
    ];
  }
}