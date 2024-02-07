import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/order/combined_order.dart';
import '../entity/order/order.dart';
import '../entity/order/order_based_id_parameter.dart';
import '../entity/order/ordertransaction/order_transaction_parameter.dart';
import '../entity/order/ordertransaction/ordertransactionresponse/order_transaction_response.dart';
import '../repository/order_repository.dart';

class OrderTransactionUseCase {
  final OrderRepository orderRepository;

  const OrderTransactionUseCase({
    required this.orderRepository
  });

  FutureProcessing<LoadDataResult<OrderTransactionResponse>> execute(OrderTransactionParameter orderTransactionParameter) {
    return orderRepository.orderTransaction(orderTransactionParameter);
  }
}