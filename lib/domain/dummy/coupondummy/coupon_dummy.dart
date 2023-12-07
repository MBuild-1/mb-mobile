import '../../entity/coupon/coupon.dart';

class CouponDummy {
  CouponDummy();

  Coupon generateShimmerDummy() {
    return Coupon(
      id: "",
      userProfessionId: "",
      active: 1,
      needVerify: 1,
      title: "",
      code: "",
      startPeriod: DateTime.now(),
      endPeriod: DateTime.now(),
      quota: 0,
      imageMobile: "",
      imageDesktop: "",
      bannerDesktop: "",
      bannerMobile: ""
    );
  }

  Coupon generateDefaultDummy() {
    return Coupon(
      id: "",
      userProfessionId: "",
      active: 1,
      needVerify: 1,
      title: "",
      code: "",
      startPeriod: DateTime.now(),
      endPeriod: DateTime.now(),
      quota: 0,
      imageMobile: "",
      imageDesktop: "",
      bannerDesktop: "",
      bannerMobile: "",
    );
  }
}