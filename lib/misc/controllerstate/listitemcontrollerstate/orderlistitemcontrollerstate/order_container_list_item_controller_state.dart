import '../../../../domain/entity/order/combined_order.dart';
import '../list_item_controller_state.dart';

class OrderContainerListItemControllerState extends ListItemControllerState {
  List<CombinedOrder> orderList;
  void Function() onUpdateState;
  void Function(CombinedOrder) onOrderTap;
  void Function(CombinedOrder) onBuyAgainTap;

  OrderContainerListItemControllerState({
    required this.orderList,
    required this.onUpdateState,
    required this.onOrderTap,
    required this.onBuyAgainTap
  });
}