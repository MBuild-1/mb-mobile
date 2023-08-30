import '../../../domain/entity/order/combined_order.dart';
import '../../../domain/entity/order/create_order_parameter.dart';
import '../../../domain/entity/order/order.dart';
import '../../../domain/entity/order/order_based_id_parameter.dart';
import '../../../domain/entity/order/order_paging_parameter.dart';
import '../../../domain/entity/order/purchase_direct_parameter.dart';
import '../../../domain/entity/order/repurchase_parameter.dart';
import '../../../domain/entity/order/shipping_review_order_list_parameter.dart';
import '../../../misc/paging/pagingresult/paging_data_result.dart';
import '../../../misc/processing/future_processing.dart';

abstract class OrderDataSource {
  FutureProcessing<Order> createOrder(CreateOrderParameter createOrderParameter);
  FutureProcessing<Order> purchaseDirect(PurchaseDirectParameter purchaseDirectParameter);
  FutureProcessing<Order> repurchase(RepurchaseParameter repurchaseParameter);
  FutureProcessing<List<CombinedOrder>> shippingReviewOrderList(ShippingReviewOrderListParameter shippingReviewOrderListParameter);
  FutureProcessing<PagingDataResult<CombinedOrder>> orderPaging(OrderPagingParameter orderPagingParameter);
  FutureProcessing<Order> orderBasedId(OrderBasedIdParameter orderBasedIdParameter);
}