import '../../entity/coupon/coupon.dart';

class CouponDummy {
  CouponDummy();

  Coupon generateShimmerDummy() {
    return Coupon(
      id: "1",
      title: "",
      code: "",
      type: "",
      discount: 0.0,
      minOrder: 1,
      activePeriodStart: DateTime.now(),
      activePeriodEnd: DateTime.now(),
      minPerUser: 1,
      image: "",
      banner: "",
      notes: ""
    );
  }

  Coupon generateDefaultDummy() {
    return Coupon(
      id: "1",
      title: "Discount Test 1",
      code: "MBDISCOUNT2023",
      type: "shipping",
      discount: 10.0,
      minOrder: 0,
      activePeriodStart: DateTime.now(),
      activePeriodEnd: DateTime.now(),
      minPerUser: 1,
      image: "",
      banner: "",
      notes: ""
    );
  }
}