import '../../../domain/entity/order/create_order_parameter.dart';
import '../../../domain/entity/order/order.dart';
import '../../../misc/processing/future_processing.dart';

abstract class OrderDataSource {
  FutureProcessing<Order> createOrder(CreateOrderParameter createOrderParameter);
}