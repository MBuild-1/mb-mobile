import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/order/create_order_parameter.dart';
import '../entity/order/order.dart';

abstract class OrderRepository {
  FutureProcessing<LoadDataResult<Order>> createOrder(CreateOrderParameter createOrderParameter);
}