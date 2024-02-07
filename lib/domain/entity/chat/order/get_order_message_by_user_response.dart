import '../user_chat_wrapper.dart';
import 'combined_order_from_message.dart';
import 'order_message.dart';

class GetOrderMessageByUserResponse {
  List<GetOrderMessageByUserResponseMember> getOrderMessageByUserResponseMemberList;

  GetOrderMessageByUserResponse({
    required this.getOrderMessageByUserResponseMemberList,
  });
}

class GetOrderMessageByUserResponseMember {
  String id;
  UserChatWrapper? userOne;
  UserChatWrapper? userTwo;
  int unreadMessagesCount;
  CombinedOrderFromMessage order;
  List<OrderMessage> orderMessageList;

  GetOrderMessageByUserResponseMember({
    required this.id,
    required this.userOne,
    required this.userTwo,
    required this.unreadMessagesCount,
    required this.order,
    required this.orderMessageList
  });
}