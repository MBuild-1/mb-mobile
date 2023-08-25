import '../../../../domain/entity/chat/order/get_order_message_by_user_response.dart';
import '../list_item_controller_state.dart';

class OrderChatHistoryListItemControllerState extends ListItemControllerState {
  GetOrderMessageByUserResponseMember getOrderMessageByUserResponseMember;
  void Function(GetOrderMessageByUserResponseMember)? onTap;

  OrderChatHistoryListItemControllerState({
    required this.getOrderMessageByUserResponseMember,
    this.onTap
  });
}