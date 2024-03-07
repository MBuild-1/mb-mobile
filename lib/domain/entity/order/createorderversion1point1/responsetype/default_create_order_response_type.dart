import 'create_order_response_type.dart';
import 'with_combined_order_id_create_order_response_type.dart';

class DefaultCreateOrderResponseType extends CreateOrderResponseType implements WithCombinedOrderIdCreateOrderResponseType {
  String transactionId;
  String orderId;
  @override
  String combinedOrderId;

  DefaultCreateOrderResponseType({
    required this.transactionId,
    required this.orderId,
    required this.combinedOrderId
  });
}