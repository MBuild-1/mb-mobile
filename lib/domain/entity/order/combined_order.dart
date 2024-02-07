import '../coupon/coupon.dart';
import '../user/user.dart';
import 'order_product.dart';
import 'order_purchasing.dart';
import 'order_shipping.dart';

class CombinedOrder {
  String id;
  String? invoiceId;
  String userId;
  String orderProductId;
  String? orderShippingId;
  String orderCode;
  String? couponId;
  String? picId;
  String? picTakeoverId;
  String status;
  String? inStatus;
  DateTime? takeoverAt;
  int review;
  int isRemoteArea;
  int isBucket;
  Coupon? coupon;
  User user;
  OrderProduct orderProduct;
  OrderShipping? orderShipping;
  List<OrderPurchasing> orderPurchasingList;
  DateTime createdAt;

  CombinedOrder({
    required this.id,
    required this.invoiceId,
    required this.userId,
    required this.orderProductId,
    required this.orderShippingId,
    required this.orderCode,
    required this.couponId,
    this.picId,
    this.picTakeoverId,
    required this.status,
    required this.inStatus,
    this.takeoverAt,
    required this.review,
    required this.isRemoteArea,
    required this.isBucket,
    this.coupon,
    required this.user,
    required this.orderProduct,
    required this.orderShipping,
    required this.orderPurchasingList,
    required this.createdAt
  });
}