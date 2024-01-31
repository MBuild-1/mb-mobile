import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/order/order.dart';
import '../entity/order/purchase_direct_parameter.dart';
import '../entity/order/purchase_direct_response.dart';
import '../repository/order_repository.dart';

class PurchaseDirectUseCase {
  final OrderRepository orderRepository;

  const PurchaseDirectUseCase({
    required this.orderRepository
  });

  FutureProcessing<LoadDataResult<PurchaseDirectResponse>> execute(PurchaseDirectParameter purchaseDirectParameter) {
    return orderRepository.purchaseDirect(purchaseDirectParameter);
  }
}