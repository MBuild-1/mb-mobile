import '../../../../domain/entity/order/combined_order.dart';
import '../list_item_controller_state.dart';

class OrderDetailContainerListItemControllerState extends ListItemControllerState {
  CombinedOrder order;
  void Function() onUpdateState;

  OrderDetailContainerListItemControllerState({
    required this.order,
    required this.onUpdateState
  });
}