import 'coupon.dart';
import 'coupon_detail_value.dart';

class CouponDetail extends Coupon {
  CouponDetailValue couponDetailValue;

  CouponDetail({
    required super.id,
    required super.userProfessionId,
    required super.active,
    required super.needVerify,
    required super.title,
    required super.code,
    required super.startPeriod,
    required super.endPeriod,
    required super.quota,
    required super.imageMobile,
    required super.imageDesktop,
    required super.bannerDesktop,
    required super.bannerMobile,
    required this.couponDetailValue
  });
}