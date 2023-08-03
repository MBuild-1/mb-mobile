import 'package:masterbagasi/data/entitymappingext/user_entity_mapping_ext.dart';
import 'package:masterbagasi/domain/entity/chat/help/get_help_message_by_user_response.dart';
import 'package:masterbagasi/misc/ext/response_wrapper_ext.dart';

import '../../domain/entity/chat/help/answer_help_conversation_response.dart';
import '../../domain/entity/chat/help/create_help_conversation_response.dart';
import '../../domain/entity/chat/help/get_help_message_by_conversation_response.dart';
import '../../domain/entity/chat/help/help_message.dart';
import '../../domain/entity/chat/help/update_read_status_help_conversation_response.dart';
import '../../domain/entity/chat/order/answer_order_conversation_response.dart';
import '../../domain/entity/chat/order/create_order_conversation_response.dart';
import '../../domain/entity/chat/order/get_order_message_by_conversation_response.dart';
import '../../domain/entity/chat/order/get_order_message_by_user_response.dart';
import '../../domain/entity/chat/order/order_message.dart';
import '../../domain/entity/chat/order/update_read_status_order_conversation_response.dart';
import '../../domain/entity/chat/user_chat.dart';
import '../../domain/entity/chat/user_chat_status.dart';
import '../../domain/entity/chat/user_chat_wrapper.dart';
import '../../misc/date_util.dart';
import '../../misc/response_wrapper.dart';

extension HelpChatEntityMappingExt on ResponseWrapper {

}

extension HelpChatDetailEntityMappingExt on ResponseWrapper {
  CreateHelpConversationResponse mapFromResponseToCreateHelpConversationResponse() {
    return CreateHelpConversationResponse(
      id: response["id"],
      helpConversationId: response["help_conversation_id"],
      message: response["message"],
      userId: response["user_id"],
    );
  }

  AnswerHelpConversationResponse mapFromResponseToAnswerHelpConversationResponse() {
    return AnswerHelpConversationResponse(
      id: response["id"],
      userOneId: response["user_one"],
      userTwoId: response["user_two"],
    );
  }

  UpdateReadStatusHelpConversationResponse mapFromResponseToUpdateReadStatusHelpConversationResponse() {
    dynamic userOne = response["user_one"];
    dynamic userTwo = response["user_two"];
    return UpdateReadStatusHelpConversationResponse(
      id: response["id"],
      userOne: userOne != null ? UserChatWrapper(
        user: ResponseWrapper(userOne).mapFromResponseToUser(),
        userChatStatus: ResponseWrapper(userOne).mapFromResponseToUserChatStatus()
      ) : null,
      userTwo: userTwo != null ? UserChatWrapper(
        user: ResponseWrapper(userTwo).mapFromResponseToUser(),
        userChatStatus: ResponseWrapper(userTwo).mapFromResponseToUserChatStatus()
      ) : null,
    );
  }

  UserChatStatus mapFromResponseToUserChatStatus() {
    dynamic userChatStatusResponse = response["user_status"];
    return UserChatStatus(
      id: userChatStatusResponse["id"],
      userId: userChatStatusResponse["user_id"],
      lastSeen: ResponseWrapper(userChatStatusResponse["last_seen"]).mapFromResponseToDateTime(
        dateFormat: DateUtil.standardDateFormat
      )!,
      isTyping: userChatStatusResponse["is_typing"]
    );
  }

  UserChat mapFromResponseToUserChat() {
    return UserChat(
      id: response["id"],
      name: response["name"],
      email: response["email"],
      role: response["role"],
      createdAt: ResponseWrapper(response["created_at"]).mapFromResponseToDateTime()!
    );
  }

  GetHelpMessageByConversationResponse mapFromResponseToGetHelpMessageByConversationResponse() {
    dynamic userOne = response["user_one"];
    dynamic userTwo = response["user_two"];
    return GetHelpMessageByConversationResponse(
      id: response["id"],
      userOne: userOne != null ? UserChatWrapper(
        user: ResponseWrapper(userOne).mapFromResponseToUser(),
        userChatStatus: ResponseWrapper(userOne).mapFromResponseToUserChatStatus()
      ) : null,
      userTwo: userTwo != null ? UserChatWrapper(
        user: ResponseWrapper(userTwo).mapFromResponseToUser(),
        userChatStatus: ResponseWrapper(userTwo).mapFromResponseToUserChatStatus()
      ) : null,
      helpMessageList: response["help_message"].map<HelpMessage>((helpMessageResponse) {
        return ResponseWrapper(helpMessageResponse).mapFromResponseToHelpMessage();
      }).toList(),
    );
  }

  GetHelpMessageByUserResponse mapFromResponseToGetHelpMessageByUserResponse() {
    List<dynamic> helpResponseList = response;
    dynamic helpResponse = helpResponseList.first;
    dynamic userOne = helpResponse["user_one"];
    dynamic userTwo = helpResponse["user_two"];
    return GetHelpMessageByUserResponse(
      id: helpResponse["id"],
      userOne: userOne != null ? UserChatWrapper(
        user: ResponseWrapper(userOne).mapFromResponseToUser(),
        userChatStatus: ResponseWrapper(userOne).mapFromResponseToUserChatStatus()
      ) : null,
      userTwo: userTwo != null ? UserChatWrapper(
        user: ResponseWrapper(userTwo).mapFromResponseToUser(),
        userChatStatus: ResponseWrapper(userTwo).mapFromResponseToUserChatStatus()
      ) : null,
      unreadMessagesCount: helpResponse["unread_messages_count"],
      helpMessageList: helpResponse["help_messages"].map<HelpMessage>((helpMessageResponse) {
        return ResponseWrapper(helpMessageResponse).mapFromResponseToHelpMessage();
      }).toList(),
    );
  }

  HelpMessage mapFromResponseToHelpMessage() {
    dynamic createdAt = response["created_at"];
    dynamic updatedAt = response["updated_at"];
    dynamic deletedAt = response["deleted_at"];
    return HelpMessage(
      id: response["id"],
      helpConversationId: response["help_conversation_id"],
      userId: response["user_id"],
      message: response["message"],
      createdAt: createdAt != null ? ResponseWrapper(createdAt).mapFromResponseToDateTime() : null,
      updatedAt: updatedAt != null ? ResponseWrapper(updatedAt).mapFromResponseToDateTime() : null,
      deletedAt: deletedAt != null ? ResponseWrapper(deletedAt).mapFromResponseToDateTime() : null,
      readStatus: response["read_status"],
      userChat: ResponseWrapper(response["user"]).mapFromResponseToUserChat()
    );
  }

  CreateOrderConversationResponse mapFromResponseToCreateOrderConversationResponse() {
    return CreateOrderConversationResponse(
      id: response["id"],
      orderConversationId: response["order_conversation_id"],
      message: response["message"],
      userId: response["user_id"],
    );
  }

  AnswerOrderConversationResponse mapFromResponseToAnswerOrderConversationResponse() {
    return AnswerOrderConversationResponse(
      id: response["id"],
      userOneId: response["user_one"],
      userTwoId: response["user_two"],
    );
  }

  UpdateReadStatusOrderConversationResponse mapFromResponseToUpdateReadStatusOrderConversationResponse() {
    dynamic userOne = response["user_one"];
    dynamic userTwo = response["user_two"];
    return UpdateReadStatusOrderConversationResponse(
      id: response["id"],
      userOne: userOne != null ? UserChatWrapper(
        user: ResponseWrapper(userOne).mapFromResponseToUser(),
        userChatStatus: ResponseWrapper(userOne).mapFromResponseToUserChatStatus()
      ) : null,
      userTwo: userTwo != null ? UserChatWrapper(
        user: ResponseWrapper(userTwo).mapFromResponseToUser(),
        userChatStatus: ResponseWrapper(userTwo).mapFromResponseToUserChatStatus()
      ) : null,
    );
  }

  UserChatStatus mapFromResponseToOrderChatStatus() {
    return UserChatStatus(
      id: response["id"],
      userId: response["user_id"],
      lastSeen: ResponseWrapper(response["last_seen"]).mapFromResponseToDateTime(
        dateFormat: DateUtil.standardDateFormat
      )!,
      isTyping: response["is_typing"]
    );
  }

  GetOrderMessageByConversationResponse mapFromResponseToGetOrderMessageByConversationResponse() {
    dynamic userOne = response["user_one"];
    dynamic userTwo = response["user_two"];
    return GetOrderMessageByConversationResponse(
      id: response["id"],
      userOne: userOne != null ? UserChatWrapper(
        user: ResponseWrapper(userOne).mapFromResponseToUser(),
        userChatStatus: ResponseWrapper(userOne).mapFromResponseToUserChatStatus()
      ) : null,
      userTwo: userTwo != null ? UserChatWrapper(
        user: ResponseWrapper(userTwo).mapFromResponseToUser(),
        userChatStatus: ResponseWrapper(userTwo).mapFromResponseToUserChatStatus()
      ) : null,
      orderMessageList: response["order_message"].map<HelpMessage>((helpMessageResponse) {
        return ResponseWrapper(helpMessageResponse).mapFromResponseToHelpMessage();
      }).toList(),
    );
  }

  GetOrderMessageByUserResponse mapFromResponseToGetOrderMessageByUserResponse() {
    dynamic userOne = response["user_one"];
    dynamic userTwo = response["user_two"];
    return GetOrderMessageByUserResponse(
      id: response["id"],
      userOne: userOne != null ? UserChatWrapper(
        user: ResponseWrapper(userOne).mapFromResponseToUser(),
        userChatStatus: ResponseWrapper(userOne).mapFromResponseToUserChatStatus()
      ) : null,
      userTwo: userTwo != null ? UserChatWrapper(
        user: ResponseWrapper(userTwo).mapFromResponseToUser(),
        userChatStatus: ResponseWrapper(userTwo).mapFromResponseToUserChatStatus()
      ) : null,
      unreadMessagesCount: response["unread_messages_count"],
      orderMessageList: response["order_message"].map<HelpMessage>((helpMessageResponse) {
        return ResponseWrapper(helpMessageResponse).mapFromResponseToHelpMessage();
      }).toList(),
    );
  }

  OrderMessage mapFromResponseToOrderMessage() {
    dynamic createdAt = response["created_at"];
    dynamic updatedAt = response["updated_at"];
    dynamic deletedAt = response["deleted_at"];
    return OrderMessage(
      id: response["id"],
      orderConversationId: response["order_conversation_id"],
      userId: response["user_id"],
      message: response["message"],
      createdAt: createdAt != null ? ResponseWrapper(createdAt).mapFromResponseToDateTime() : null,
      updatedAt: updatedAt != null ? ResponseWrapper(updatedAt).mapFromResponseToDateTime() : null,
      deletedAt: deletedAt != null ? ResponseWrapper(deletedAt).mapFromResponseToDateTime() : null,
      readStatus: response["read_status"],
      user: ResponseWrapper(response["user"]).mapFromResponseToUser()
    );
  }
}