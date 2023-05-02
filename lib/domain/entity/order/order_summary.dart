import '../coupon/coupon.dart';

class OrderSummary {
  String name;
  String type;
  dynamic value;
  Coupon? coupon;

  OrderSummary({
    required this.name,
    required this.type,
    required this.value,
    this.coupon
  });
}