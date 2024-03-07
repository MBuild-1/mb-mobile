import 'order_tracking_detail.dart';

class OrderTracking {
  String id;
  String orderShippingId;
  String trackingNumber;
  int arrived;
  double weight;
  List<OrderTrackingDetail> orderTrackingDetailList;

  OrderTracking({
    required this.id,
    required this.orderShippingId,
    required this.trackingNumber,
    required this.arrived,
    required this.weight,
    required this.orderTrackingDetailList
  });
}