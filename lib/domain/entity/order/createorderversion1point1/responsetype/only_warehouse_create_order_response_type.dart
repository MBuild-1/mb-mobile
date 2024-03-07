import 'create_order_response_type.dart';
import 'with_combined_order_id_create_order_response_type.dart';

class OnlyWarehouseCreateOrderResponseType extends CreateOrderResponseType implements WithCombinedOrderIdCreateOrderResponseType {
  @override
  String combinedOrderId;

  OnlyWarehouseCreateOrderResponseType({
    required this.combinedOrderId
  });
}