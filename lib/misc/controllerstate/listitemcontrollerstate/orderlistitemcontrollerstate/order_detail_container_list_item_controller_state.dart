import '../../../../domain/entity/order/combined_order.dart';
import '../../../../domain/entity/order/order.dart';
import '../list_item_controller_state.dart';

class OrderDetailContainerListItemControllerState extends ListItemControllerState {
  Order order;
  void Function() onUpdateState;
  void Function(CombinedOrder) onBuyAgainTap;

  OrderDetailContainerListItemControllerState({
    required this.order,
    required this.onUpdateState,
    required this.onBuyAgainTap
  });
}