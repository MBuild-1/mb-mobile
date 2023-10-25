import '../../../../domain/entity/order/combined_order.dart';
import 'order_list_item_controller_state.dart';

class VerticalOrderListItemControllerState extends OrderListItemControllerState {
  void Function(CombinedOrder) onBuyAgainTap;
  void Function(CombinedOrder) onConfirmArrived;

  VerticalOrderListItemControllerState({
    required super.order,
    required this.onBuyAgainTap,
    required this.onConfirmArrived
  });
}