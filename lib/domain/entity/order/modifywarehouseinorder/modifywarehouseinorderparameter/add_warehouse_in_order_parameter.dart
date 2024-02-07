import '../modifywarehouseinorderitem/all_required_fields_warehouse_in_order_item.dart';
import 'modify_warehouse_in_order_parameter.dart';
import 'support_order_product_id_mixin.dart';

class AddWarehouseInOrderParameter extends ModifyWarehouseInOrderParameter with SupportOrderProductIdMixin {
  List<AllRequiredFieldsWarehouseInOrderItem> allRequiredFieldsWarehouseInOrderItemList;

  AddWarehouseInOrderParameter({
    required String orderProductId,
    required this.allRequiredFieldsWarehouseInOrderItemList
  }) {
    this.orderProductId = orderProductId;
  }
}