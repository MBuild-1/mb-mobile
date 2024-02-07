import 'combined_order.dart';
import 'order_summary.dart';
import 'ordertracking/order_tracking.dart';

class Order {
  OrderSummary orderSummary;
  CombinedOrder combinedOrder;
  List<OrderTracking> orderTrackingList;

  Order({
    required this.orderSummary,
    required this.combinedOrder,
    required this.orderTrackingList
  });
}