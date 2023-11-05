import 'modify_warehouse_in_order_parameter.dart';
import 'support_order_product_id_mixin.dart';

class RemoveWarehouseInOrderParameter extends ModifyWarehouseInOrderParameter {
  String warehouseInOrderItemId;

  RemoveWarehouseInOrderParameter({
    required this.warehouseInOrderItemId
  });
}