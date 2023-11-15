import '../../../../domain/entity/order/combined_order.dart';
import '../../../../domain/entity/order/modifywarehouseinorder/modifywarehouseinorderparameter/modify_warehouse_in_order_parameter.dart';
import '../../../../domain/entity/order/order.dart';
import '../list_item_controller_state.dart';

class OrderDetailContainerListItemControllerState extends ListItemControllerState {
  Order order;
  void Function() onUpdateState;
  void Function(ModifyWarehouseInOrderParameter) onModifyWarehouseInOrder;
  void Function(CombinedOrder) onBuyAgainTap;
  void Function() onShowOrderListIsClosedDialog;

  OrderDetailContainerListItemControllerState({
    required this.order,
    required this.onUpdateState,
    required this.onModifyWarehouseInOrder,
    required this.onBuyAgainTap,
    required this.onShowOrderListIsClosedDialog
  });
}