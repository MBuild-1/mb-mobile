import '../user_chat_wrapper.dart';
import 'product_from_message.dart';
import 'product_message.dart';

class GetProductMessageByUserResponse {
  List<GetProductMessageByUserResponseMember> getProductMessageByUserResponseMemberList;

  GetProductMessageByUserResponse({
    required this.getProductMessageByUserResponseMemberList,
  });
}

class GetProductMessageByUserResponseMember {
  String id;
  String? productId;
  UserChatWrapper? userOne;
  UserChatWrapper? userTwo;
  int unreadMessagesCount;
  ProductFromMessage productFromMessage;
  List<ProductMessage> productMessageList;

  GetProductMessageByUserResponseMember({
    required this.id,
    required this.productId,
    required this.userOne,
    required this.userTwo,
    required this.unreadMessagesCount,
    required this.productFromMessage,
    required this.productMessageList
  });
}