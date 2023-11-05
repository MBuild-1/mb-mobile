import '../modifywarehouseinorderitem/optional_fields_warehouse_in_order_item.dart';
import 'modify_warehouse_in_order_parameter.dart';
import 'support_order_product_id_mixin.dart';

class ChangeWarehouseInOrderParameter extends ModifyWarehouseInOrderParameter with SupportOrderProductIdMixin {
  OptionalFieldsWarehouseInOrderItem optionalFieldsWarehouseInOrderItem;
  String id;

  ChangeWarehouseInOrderParameter({
    required String orderProductId,
    required this.id,
    required this.optionalFieldsWarehouseInOrderItem
  }) {
    this.orderProductId = orderProductId;
  }
}