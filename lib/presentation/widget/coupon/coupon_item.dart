import 'package:flutter/material.dart';

import '../../../domain/entity/coupon/coupon.dart';
import '../../../misc/constant.dart';
import '../modified_divider.dart';

typedef OnSelectCoupon = void Function(Coupon);

abstract class CouponItem extends StatelessWidget {
  final Coupon coupon;
  final OnSelectCoupon? onSelectCoupon;

  const CouponItem({
    super.key,
    required this.coupon,
    required this.onSelectCoupon
  });

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius = const BorderRadius.only(
      topRight: Radius.circular(16.0),
      bottomLeft: Radius.circular(16.0),
      bottomRight: Radius.circular(16.0)
    );
    return SizedBox(
      child: Padding(
        // Use padding widget for avoiding shadow elevation overlap.
        padding: const EdgeInsets.only(top: 1.0, bottom: 5.0),
        child: Material(
          color: Colors.white,
          borderRadius: borderRadius,
          elevation: 3,
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
                  ModifiedDivider(
                    lineHeight: 3.5,
                    lineColor: Constant.colorGrey5
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Tooltip(
                          message: coupon.title,
                          child: Text(
                            coupon.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(coupon.notes, style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)),
                      ],
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