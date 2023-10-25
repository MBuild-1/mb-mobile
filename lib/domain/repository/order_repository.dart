import '../../misc/load_data_result.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/order/arrived_order_request.dart';
import '../entity/order/arrived_order_response.dart';
import '../entity/order/combined_order.dart';
import '../entity/order/create_order_parameter.dart';
import '../entity/order/order.dart';
import '../entity/order/order_based_id_parameter.dart';
import '../entity/order/order_paging_parameter.dart';
import '../entity/order/purchase_direct_parameter.dart';
import '../entity/order/repurchase_parameter.dart';
import '../entity/order/shipping_review_order_list_parameter.dart';

abstract class OrderRepository {
  FutureProcessing<LoadDataResult<Order>> createOrder(CreateOrderParameter createOrderParameter);
  FutureProcessing<LoadDataResult<Order>> purchaseDirect(PurchaseDirectParameter purchaseDirectParameter);
  FutureProcessing<LoadDataResult<Order>> repurchase(RepurchaseParameter repurchaseParameter);
  FutureProcessing<LoadDataResult<List<CombinedOrder>>> shippingReviewOrderList(ShippingReviewOrderListParameter shippingReviewOrderListParameter);
  FutureProcessing<LoadDataResult<PagingDataResult<CombinedOrder>>> orderPaging(OrderPagingParameter orderPagingParameter);
  FutureProcessing<LoadDataResult<Order>> orderBasedId(OrderBasedIdParameter orderBasedIdParameter);
  FutureProcessing<LoadDataResult<ArrivedOrderResponse>> arrivedOrder(ArrivedOrderParameter arrivedOrderParameter);
}