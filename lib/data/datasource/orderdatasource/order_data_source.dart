import '../../../domain/entity/order/create_order_version_1_point_1_parameter.dart';
import '../../../domain/entity/order/create_order_version_1_point_1_response.dart';
import '../../../domain/entity/order/modifywarehouseinorder/modifywarehouseinorderparameter/modify_warehouse_in_order_parameter.dart';
import '../../../domain/entity/order/arrived_order_request.dart';
import '../../../domain/entity/order/arrived_order_response.dart';
import '../../../domain/entity/order/combined_order.dart';
import '../../../domain/entity/order/create_order_parameter.dart';
import '../../../domain/entity/order/modifywarehouseinorder/modifywarehouseinorderresponse/modify_warehouse_in_order_response.dart';
import '../../../domain/entity/order/order.dart';
import '../../../domain/entity/order/order_based_id_parameter.dart';
import '../../../domain/entity/order/order_paging_parameter.dart';
import '../../../domain/entity/order/ordertransaction/order_transaction_parameter.dart';
import '../../../domain/entity/order/ordertransaction/ordertransactionresponse/order_transaction_response.dart';
import '../../../domain/entity/order/purchase_direct_parameter.dart';
import '../../../domain/entity/order/purchase_direct_response.dart';
import '../../../domain/entity/order/repurchase_parameter.dart';
import '../../../domain/entity/order/shipping_review_order_list_parameter.dart';
import '../../../misc/paging/pagingresult/paging_data_result.dart';
import '../../../misc/processing/future_processing.dart';

abstract class OrderDataSource {
  FutureProcessing<Order> createOrder(CreateOrderParameter createOrderParameter);
  FutureProcessing<CreateOrderVersion1Point1Response> createOrderVersion1Point1(CreateOrderVersion1Point1Parameter createOrderVersion1Point1Parameter);
  FutureProcessing<PurchaseDirectResponse> purchaseDirect(PurchaseDirectParameter purchaseDirectParameter);
  FutureProcessing<Order> repurchase(RepurchaseParameter repurchaseParameter);
  FutureProcessing<List<CombinedOrder>> shippingReviewOrderList(ShippingReviewOrderListParameter shippingReviewOrderListParameter);
  FutureProcessing<PagingDataResult<CombinedOrder>> orderPaging(OrderPagingParameter orderPagingParameter);
  FutureProcessing<Order> orderBasedId(OrderBasedIdParameter orderBasedIdParameter);
  FutureProcessing<OrderTransactionResponse> orderTransaction(OrderTransactionParameter orderTransactionParameter);
  FutureProcessing<ArrivedOrderResponse> arrivedOrder(ArrivedOrderParameter arrivedOrderParameter);
  FutureProcessing<ModifyWarehouseInOrderResponse> modifyWarehouseInOrder(ModifyWarehouseInOrderParameter modifyWarehouseInOrderParameter);
}