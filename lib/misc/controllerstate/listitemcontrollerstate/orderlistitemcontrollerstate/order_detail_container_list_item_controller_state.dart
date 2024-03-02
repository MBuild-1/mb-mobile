import '../../../../domain/entity/order/combined_order.dart';
import '../../../../domain/entity/order/modifywarehouseinorder/modifywarehouseinorderparameter/modify_warehouse_in_order_parameter.dart';
import '../../../../domain/entity/order/order.dart';
import '../../../../domain/entity/order/order_detail.dart';
import '../../../errorprovider/error_provider.dart';
import '../list_item_controller_state.dart';

class OrderDetailContainerListItemControllerState extends ListItemControllerState {
  Order Function() order;
  void Function() onUpdateState;
  void Function(ModifyWarehouseInOrderParameter) onModifyWarehouseInOrder;
  void Function(CombinedOrder) onBuyAgainTap;
  void Function() onShowOrderListIsClosedDialog;
  void Function(CombinedOrder) onOpenOrderInvoice;
  void Function() onPayOrderShipping;
  void Function(CombinedOrder) onConfirmArrived;
  ListItemControllerState Function() orderTransactionListItemControllerState;
  ListItemControllerState Function() shipperAddressListItemControllerState;
  ErrorProvider Function() errorProvider;

  OrderDetailContainerListItemControllerState({
    required this.order,
    required this.onUpdateState,
    required this.onModifyWarehouseInOrder,
    required this.onBuyAgainTap,
    required this.onShowOrderListIsClosedDialog,
    required this.onOpenOrderInvoice,
    required this.onPayOrderShipping,
    required this.onConfirmArrived,
    required this.orderTransactionListItemControllerState,
    required this.shipperAddressListItemControllerState,
    required this.errorProvider
  });
}