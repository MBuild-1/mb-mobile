import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/order/order.dart';
import '../entity/order/repurchase_parameter.dart';
import '../repository/order_repository.dart';

class RepurchaseUseCase {
  final OrderRepository orderRepository;

  const RepurchaseUseCase({
    required this.orderRepository
  });

  FutureProcessing<LoadDataResult<Order>> execute(RepurchaseParameter repurchaseParameter) {
    return orderRepository.repurchase(repurchaseParameter);
  }
}