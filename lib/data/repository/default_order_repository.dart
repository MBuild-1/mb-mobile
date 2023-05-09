import '../../domain/entity/order/create_order_parameter.dart';
import '../../domain/entity/order/order.dart';
import '../../domain/repository/order_repository.dart';
import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../datasource/orderdatasource/order_data_source.dart';

class DefaultOrderRepository implements OrderRepository {
  final OrderDataSource orderDataSource;

  const DefaultOrderRepository({
    required this.orderDataSource
  });

  @override
  FutureProcessing<LoadDataResult<Order>> createOrder(CreateOrderParameter createOrderParameter) {
    return orderDataSource.createOrder(createOrderParameter).mapToLoadDataResult<Order>();
  }
}