import '../user_chat_wrapper.dart';
import 'combined_order_from_message.dart';
import 'order_message.dart';

class GetOrderMessageByCombinedOrderResponse {
  GetOrderMessageByCombinedOrderResponseMember getOrderMessageByCombinedOrderResponseMember;

  GetOrderMessageByCombinedOrderResponse({
    required this.getOrderMessageByCombinedOrderResponseMember,
  });
}

class GetOrderMessageByCombinedOrderResponseMember {
  String id;
  UserChatWrapper? userOne;
  UserChatWrapper? userTwo;
  int unreadMessagesCount;
  CombinedOrderFromMessage order;
  List<OrderMessage> orderMessageList;

  GetOrderMessageByCombinedOrderResponseMember({
    required this.id,
    required this.userOne,
    required this.userTwo,
    required this.unreadMessagesCount,
    required this.order,
    required this.orderMessageList
  });
}