import 'order_detail.dart';
import 'order_product_in_order_shipping.dart';
import 'ordertracking/order_tracking.dart';

class OrderShipping {
  String id;
  String orderId;
  String orderProductId;
  String trackingNumber;
  bool isPaymentTriggered;
  String status;
  String? notes;
  OrderDetail orderDetail;
  OrderProductInOrderShipping orderProductInOrderShipping;
  List<OrderTracking> orderTrackingList;

  OrderShipping({
    required this.id,
    required this.orderId,
    required this.orderProductId,
    required this.trackingNumber,
    required this.isPaymentTriggered,
    required this.status,
    this.notes,
    required this.orderDetail,
    required this.orderProductInOrderShipping,
    required this.orderTrackingList
  });
}