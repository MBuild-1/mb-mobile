import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/order/combined_order.dart';
import '../entity/order/shipping_review_order_list_parameter.dart';
import '../repository/order_repository.dart';

class GetShippingReviewOrderListUseCase {
  final OrderRepository orderRepository;

  const GetShippingReviewOrderListUseCase({
    required this.orderRepository
  });

  FutureProcessing<LoadDataResult<List<CombinedOrder>>> execute(ShippingReviewOrderListParameter shippingReviewOrderListParameter) {
    return orderRepository.shippingReviewOrderList(shippingReviewOrderListParameter);
  }
}