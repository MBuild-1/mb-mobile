import 'create_order_response_type.dart';
import 'with_combined_order_id_create_order_response_type.dart';

class PaypalCreateOrderResponseType extends CreateOrderResponseType implements WithCombinedOrderIdCreateOrderResponseType {
  String approveLink;
  @override
  String combinedOrderId;

  PaypalCreateOrderResponseType({
    required this.approveLink,
    required this.combinedOrderId
  });
}