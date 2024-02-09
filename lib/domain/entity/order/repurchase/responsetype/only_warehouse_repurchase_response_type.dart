import 'repurchase_response_type.dart';
import 'with_combined_order_id_repurchase_response_type.dart';

class OnlyWarehouseRepurchaseResponseType extends RepurchaseResponseType implements WithCombinedOrderIdRepurchaseResponseType {
  @override
  String combinedOrderId;

  OnlyWarehouseRepurchaseResponseType({
    required this.combinedOrderId
  });
}