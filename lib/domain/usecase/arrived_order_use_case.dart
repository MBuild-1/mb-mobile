import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/order/arrived_order_request.dart';
import '../entity/order/arrived_order_response.dart';
import '../repository/order_repository.dart';

class ArrivedOrderUseCase {
  final OrderRepository orderRepository;

  ArrivedOrderUseCase({
    required this.orderRepository
  });

  FutureProcessing<LoadDataResult<ArrivedOrderResponse>> execute(ArrivedOrderParameter arrivedOrderParameter) {
    return orderRepository.arrivedOrder(arrivedOrderParameter);
  }
}