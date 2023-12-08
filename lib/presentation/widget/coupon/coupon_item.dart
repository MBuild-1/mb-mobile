import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:sizer/sizer.dart';

import '../../../domain/entity/coupon/coupon.dart';
import '../../../misc/constant.dart';
import '../../../misc/date_util.dart';
import '../../../misc/dialog_helper.dart';
import '../../../misc/page_restoration_helper.dart';
import '../../page/modaldialogpage/coupon_tac_modal_dialog_page.dart';
import '../button/custombutton/sized_outline_gradient_button.dart';
import '../horizontal_justified_title_and_description.dart';
import '../modified_svg_picture.dart';
import '../modifiedcachednetworkimage/product_modified_cached_network_image.dart';
import '../tap_area.dart';

typedef OnSelectCoupon = void Function(Coupon);

abstract class CouponItem extends StatelessWidget {
  final Coupon coupon;
  final OnSelectCoupon? onSelectCoupon;
  final bool isSelected;

  const CouponItem({
    super.key,
    required this.coupon,
    required this.onSelectCoupon,
    required this.isSelected
  });

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius = BorderRadius.circular(8.0);
    return SizedBox(
      child: Padding(
        // Use padding widget for avoiding shadow elevation overlap.
        padding: const EdgeInsets.only(top: 1.0, bottom: 5.0),
        child: Material(
          borderRadius: borderRadius,
          elevation: 3,
          color: isSelected ? Constant.colorLightOrange2 : null,
          child: InkWell(
            onTap: onSelectCoupon != null ? () => onSelectCoupon!(coupon) : null,
            borderRadius: borderRadius,
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: borderRadius
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: Constant.aspectRatioValueCouponBanner.toDouble(),
                    child: ClipRRect(
                      child: ProductModifiedCachedNetworkImage(
                        imageUrl: coupon.bannerMobile.isNotEmptyString ? coupon.bannerMobile! : coupon.bannerDesktop.toEmptyStringNonNull,
                      )
                    )
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: isSelected ? Border.all(color: Constant.colorMain) : null,
                            color: isSelected ? null : Constant.colorLightBlue,
                          ),
                          child: Text(
                            coupon.code,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Constant.colorMain : Constant.colorDarkBlue2
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          coupon.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10.0),
                        HorizontalJustifiedTitleAndDescription(
                          title: "Expired Date".tr,
                          description: "${DateUtil.standardDateFormat7.format(coupon.startPeriod)} - ${DateUtil.standardDateFormat7.format(coupon.endPeriod)}",
                          titleWidgetInterceptor: (title, widget) => Text(
                            title.toStringNonNull,
                          ),
                          descriptionWidgetInterceptor: (description, widget) => Text(
                            description.toStringNonNull,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        HorizontalJustifiedTitleAndDescription(
                          title: "Transaction Maximal".tr,
                          description: "${coupon.quota}x",
                          titleWidgetInterceptor: (title, widget) => Text(
                            title.toStringNonNull,
                          ),
                          descriptionWidgetInterceptor: (description, widget) => Text(
                            description.toStringNonNull,
                          ),
                        ),
                        const SizedBox(height: 14.0),
                        SizedOutlineGradientButton(
                          onPressed: () async {
                            await DialogHelper.showModalDialogPage<void, Coupon>(
                              context: context,
                              modalDialogPageBuilder: (context, parameter) => CouponTacModalDialogPage(coupon: coupon),
                              parameter: coupon,
                            );
                          },
                          text: "Terms & Conditions".tr,
                          outlineGradientButtonType: OutlineGradientButtonType.solid,
                          outlineGradientButtonVariation: OutlineGradientButtonVariation.variation2,
                        )
                      ]
                    ),
                  ),
                ],
              )
            )
          )
        ),
      )
    );
  }
}