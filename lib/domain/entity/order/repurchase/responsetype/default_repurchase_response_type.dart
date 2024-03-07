import 'repurchase_response_type.dart';
import 'with_combined_order_id_repurchase_response_type.dart';

class DefaultRepurchaseResponseType extends RepurchaseResponseType implements WithCombinedOrderIdRepurchaseResponseType {
  String transactionId;
  String orderId;
  @override
  String combinedOrderId;

  DefaultRepurchaseResponseType({
    required this.transactionId,
    required this.orderId,
    required this.combinedOrderId
  });
}