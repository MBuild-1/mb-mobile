import 'package:masterbagasi/data/entitymappingext/user_entity_mapping_ext.dart';
import 'package:masterbagasi/domain/entity/chat/help/get_help_message_by_user_response.dart';
import 'package:masterbagasi/misc/ext/response_wrapper_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../domain/entity/chat/help/answer_help_conversation_response.dart';
import '../../domain/entity/chat/help/create_help_conversation_response.dart';
import '../../domain/entity/chat/help/get_help_message_by_conversation_response.dart';
import '../../domain/entity/chat/help/get_help_message_notification_count_response.dart';
import '../../domain/entity/chat/help/help_message.dart';
import '../../domain/entity/chat/help/update_read_status_help_conversation_response.dart';
import '../../domain/entity/chat/order/answer_order_conversation_response.dart';
import '../../domain/entity/chat/order/answer_order_conversation_version_1_point_1_response.dart';
import '../../domain/entity/chat/order/combined_order_from_message.dart';
import '../../domain/entity/chat/order/create_order_conversation_response.dart';
import '../../domain/entity/chat/order/get_order_message_by_combined_order_response.dart';
import '../../domain/entity/chat/order/get_order_message_by_conversation_response.dart';
import '../../domain/entity/chat/order/get_order_message_by_user_response.dart';
import '../../domain/entity/chat/order/order_message.dart';
import '../../domain/entity/chat/order/update_read_status_order_conversation_response.dart';
import '../../domain/entity/chat/product/answer_product_conversation_response.dart';
import '../../domain/entity/chat/product/create_product_conversation_response.dart';
import '../../domain/entity/chat/product/get_product_message_by_conversation_response.dart';
import '../../domain/entity/chat/product/get_product_message_by_product_response.dart';
import '../../domain/entity/chat/product/get_product_message_by_user_response.dart';
import '../../domain/entity/chat/product/product_from_message.dart';
import '../../domain/entity/chat/product/product_message.dart';
import '../../domain/entity/chat/product/update_read_status_product_conversation_response.dart';
import '../../domain/entity/chat/user_chat.dart';
import '../../domain/entity/chat/user_chat_status.dart';
import '../../domain/entity/chat/user_chat_wrapper.dart';
import '../../misc/constant.dart';
import '../../misc/date_util.dart';
import '../../misc/error/empty_chat_error.dart';
import '../../misc/error/message_error.dart';
import '../../misc/error_helper.dart';
import '../../misc/multi_language_string.dart';
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
      email: (response["email"] as String?).toEmptyStringNonNull,
      role: response["role"],
      createdAt: ResponseWrapper(response["created_at"]).mapFromResponseToDateTime()!
    );
  }

  GetHelpMessageByConversationResponse mapFromResponseToGetHelpMessageByConversationResponse() {
    dynamic userOne = response["user_one"];
    dynamic userTwo = response["user_two"];
    List<HelpMessage> helpMessageList = response["help_messages"].map<HelpMessage>((helpMessageResponse) {
      return ResponseWrapper(helpMessageResponse).mapFromResponseToHelpMessage();
    }).toList();
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
      helpMessageList: helpMessageList.reversed.toList()
    );
  }

  GetHelpMessageByUserResponse mapFromResponseToGetHelpMessageByUserResponse() {
    dynamic helpResponse = response;
    if (helpResponse.isEmpty) {
      throw EmptyChatError();
    }
    dynamic userOne = helpResponse["user_one"];
    dynamic userTwo = helpResponse["user_two"];
    List<HelpMessage> helpMessageList = helpResponse["help_messages"].map<HelpMessage>((helpMessageResponse) {
      return ResponseWrapper(helpMessageResponse).mapFromResponseToHelpMessage();
    }).toList();
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
      unreadMessagesCount: helpResponse["unread_messages_count"] ?? 0,
      helpMessageList: helpMessageList.reversed.toList(),
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

  GetHelpMessageNotificationCountResponse mapFromResponseToGetHelpMessageNotificationCountResponse() {
    return GetHelpMessageNotificationCountResponse(
      unreadMessagesUserTwo: response["unread_messages_user_two"]
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

  AnswerOrderConversationVersion1Point1Response mapFromResponseToAnswerOrderConversationVersion1Point1Response() {
    return AnswerOrderConversationVersion1Point1Response(
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
    List<OrderMessage> orderMessageList = response["order_messages"].map<OrderMessage>((orderMessageResponse) {
      return ResponseWrapper(orderMessageResponse).mapFromResponseToOrderMessage();
    }).toList();
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
      orderMessageList: orderMessageList.reversed.toList(),
    );
  }

  GetOrderMessageByUserResponse mapFromResponseToGetOrderMessageByUserResponse() {
    GetOrderMessageByUserResponse getOrderMessageByUserResponse = GetOrderMessageByUserResponse(
      getOrderMessageByUserResponseMemberList: response.map<GetOrderMessageByUserResponseMember>(
        (getOrderMessageByUserResponseMemberValue) => ResponseWrapper(getOrderMessageByUserResponseMemberValue).mapFromResponseToGetOrderMessageByUserResponseMember()
      ).toList()
    );
    if (getOrderMessageByUserResponse.getOrderMessageByUserResponseMemberList.isEmpty) {
      throw ErrorHelper.generateMultiLanguageDioError(
        MultiLanguageMessageError(
          title: MultiLanguageString({
            Constant.textEnUsLanguageKey: "Order Chat Is Empty",
            Constant.textInIdLanguageKey: "Chat Order Kosong",
          }),
          message: MultiLanguageString({
            Constant.textEnUsLanguageKey: "For now, order chat is empty.",
            Constant.textInIdLanguageKey: "Untuk sekarang, chat order kosong.",
          }),
        )
      );
    }
    return getOrderMessageByUserResponse;
  }

  GetOrderMessageByCombinedOrderResponse mapFromResponseToGetOrderMessageByCombinedOrderResponse() {
    if (response == null) {
      throw EmptyChatError();
    }
    return GetOrderMessageByCombinedOrderResponse(
      getOrderMessageByCombinedOrderResponseMember: ResponseWrapper(response).mapFromResponseToGetOrderMessageByCombinedOrderResponseMember()
    );
  }

  GetOrderMessageByUserResponseMember mapFromResponseToGetOrderMessageByUserResponseMember() {
    dynamic userOne = response["user_one"];
    dynamic userTwo = response["user_two"];
    List<OrderMessage> orderMessageList = response["order_messages"].map<OrderMessage>((orderMessageResponse) {
      return ResponseWrapper(orderMessageResponse).mapFromResponseToOrderMessage();
    }).toList();
    return GetOrderMessageByUserResponseMember(
      id: response["id"],
      userOne: userOne != null ? UserChatWrapper(
        user: ResponseWrapper(userOne).mapFromResponseToUser(),
        userChatStatus: ResponseWrapper(userOne).mapFromResponseToUserChatStatus()
      ) : null,
      userTwo: userTwo != null ? UserChatWrapper(
        user: ResponseWrapper(userTwo).mapFromResponseToUser(),
        userChatStatus: ResponseWrapper(userTwo).mapFromResponseToUserChatStatus()
      ) : null,
      unreadMessagesCount: 0,
      order: ResponseWrapper(response["combined_order"]).mapFromResponseToCombinedOrderFromMessage(),
      orderMessageList: orderMessageList.reversed.toList(),
    );
  }

  GetOrderMessageByCombinedOrderResponseMember mapFromResponseToGetOrderMessageByCombinedOrderResponseMember() {
    GetOrderMessageByUserResponseMember getOrderMessageByUserResponseMember = ResponseWrapper(response).mapFromResponseToGetOrderMessageByUserResponseMember();
    return GetOrderMessageByCombinedOrderResponseMember(
      id: getOrderMessageByUserResponseMember.id,
      userOne: getOrderMessageByUserResponseMember.userOne,
      userTwo: getOrderMessageByUserResponseMember.userTwo,
      unreadMessagesCount: getOrderMessageByUserResponseMember.unreadMessagesCount,
      order: getOrderMessageByUserResponseMember.order,
      orderMessageList: getOrderMessageByUserResponseMember.orderMessageList
    );
  }

  CombinedOrderFromMessage mapFromResponseToCombinedOrderFromMessage() {
    return CombinedOrderFromMessage(
      id: response["id"],
      orderCode: response["order_code"]
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
      userChat: ResponseWrapper(response["user"]).mapFromResponseToUserChat()
    );
  }

  CreateProductConversationResponse mapFromResponseToCreateProductConversationResponse() {
    return CreateProductConversationResponse(
      id: response["id"],
      productConversationId: response["product_conversation_id"],
      message: response["message"],
      userId: response["user_id"],
    );
  }

  AnswerProductConversationResponse mapFromResponseToAnswerProductConversationResponse() {
    return AnswerProductConversationResponse(
      id: response["id"],
      userOneId: response["user_one"],
      userTwoId: response["user_two"],
    );
  }

  UpdateReadStatusProductConversationResponse mapFromResponseToUpdateReadStatusProductConversationResponse() {
    dynamic userOne = response["user_one"];
    dynamic userTwo = response["user_two"];
    return UpdateReadStatusProductConversationResponse(
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

  GetProductMessageByConversationResponse mapFromResponseToGetProductMessageByConversationResponse() {
    dynamic userOne = response["user_one"];
    dynamic userTwo = response["user_two"];
    List<ProductMessage> productMessageList = response["product_messages"].map<ProductMessage>((productMessageResponse) {
      return ResponseWrapper(productMessageResponse).mapFromResponseToProductMessage();
    }).toList();
    return GetProductMessageByConversationResponse(
      id: response["id"],
      productId: response["product_id"],
      userOne: userOne != null ? UserChatWrapper(
        user: ResponseWrapper(userOne).mapFromResponseToUser(),
        userChatStatus: ResponseWrapper(userOne).mapFromResponseToUserChatStatus()
      ) : null,
      userTwo: userTwo != null ? UserChatWrapper(
        user: ResponseWrapper(userTwo).mapFromResponseToUser(),
        userChatStatus: ResponseWrapper(userTwo).mapFromResponseToUserChatStatus()
      ) : null,
      productMessageList: productMessageList.reversed.toList(),
    );
  }

  GetProductMessageByUserResponse mapFromResponseToGetProductMessageByUserResponse() {
    GetProductMessageByUserResponse getProductMessageByUserResponse = GetProductMessageByUserResponse(
      getProductMessageByUserResponseMemberList: response.map<GetProductMessageByUserResponseMember>(
        (getProductMessageByUserResponseMemberValue) => ResponseWrapper(getProductMessageByUserResponseMemberValue).mapFromResponseToGetProductMessageByUserResponseMember()
      ).toList()
    );
    if (getProductMessageByUserResponse.getProductMessageByUserResponseMemberList.isEmpty) {
      throw ErrorHelper.generateMultiLanguageDioError(
        MultiLanguageMessageError(
          title: MultiLanguageString({
            Constant.textEnUsLanguageKey: "Product Chat Is Empty",
            Constant.textInIdLanguageKey: "Chat Produk Kosong",
          }),
          message: MultiLanguageString({
            Constant.textEnUsLanguageKey: "For now, product chat is empty.",
            Constant.textInIdLanguageKey: "Untuk sekarang, chat produk kosong.",
          }),
        )
      );
    }
    return getProductMessageByUserResponse;
  }

  GetProductMessageByUserResponseMember mapFromResponseToGetProductMessageByUserResponseMember() {
    dynamic userOne = response["user_one"];
    dynamic userTwo = response["user_two"];
    List<ProductMessage> productMessageList = response["product_messages"].map<ProductMessage>((productMessageResponse) {
      return ResponseWrapper(productMessageResponse).mapFromResponseToProductMessage();
    }).toList();
    return GetProductMessageByUserResponseMember(
      id: response["id"],
      productId: response["product_id"],
      userOne: userOne != null ? UserChatWrapper(
        user: ResponseWrapper(userOne).mapFromResponseToUser(),
        userChatStatus: ResponseWrapper(userOne).mapFromResponseToUserChatStatus()
      ) : null,
      userTwo: userTwo != null ? UserChatWrapper(
        user: ResponseWrapper(userTwo).mapFromResponseToUser(),
        userChatStatus: ResponseWrapper(userTwo).mapFromResponseToUserChatStatus()
      ) : null,
      unreadMessagesCount: response["unread_messages_count"],
      productFromMessage: ResponseWrapper(response["product"]).mapFromResponseToProductFromMessage(),
      productMessageList: productMessageList.reversed.toList(),
    );
  }

  ProductFromMessage mapFromResponseToProductFromMessage() {
    return ProductFromMessage(
      id: response["id"],
      userId: response["user_id"],
      productBrandId: response["product_brand_id"],
      name: response["name"],
      slug: response["slug"],
      description: response["description"],
      productCategoryId: response["product_category_id"],
      provinceId: response["province_id"]
    );
  }

  GetProductMessageByProductResponse mapFromResponseToGetProductMessageByProductResponse() {
    if (response == null) {
      throw EmptyChatError();
    }
    dynamic userOne = response["user_one"];
    dynamic userTwo = response["user_two"];
    List<ProductMessage> productMessageList = response["product_messages"].map<ProductMessage>((productMessageResponse) {
      return ResponseWrapper(productMessageResponse).mapFromResponseToProductMessage();
    }).toList();
    return GetProductMessageByProductResponse(
      id: response["id"],
      userOne: userOne != null ? UserChatWrapper(
        user: ResponseWrapper(userOne).mapFromResponseToUser(),
        userChatStatus: ResponseWrapper(userOne).mapFromResponseToUserChatStatus()
      ) : null,
      userTwo: userTwo != null ? UserChatWrapper(
        user: ResponseWrapper(userTwo).mapFromResponseToUser(),
        userChatStatus: ResponseWrapper(userTwo).mapFromResponseToUserChatStatus()
      ) : null,
      unreadMessagesCount: response["unread_messages_count"] ?? 0,
      productMessageList: productMessageList.reversed.toList(),
    );
  }

  ProductMessage mapFromResponseToProductMessage() {
    dynamic createdAt = response["created_at"];
    dynamic updatedAt = response["updated_at"];
    dynamic deletedAt = response["deleted_at"];
    return ProductMessage(
      id: response["id"],
      productConversationId: response["product_conversation_id"],
      userId: response["user_id"],
      message: response["message"],
      createdAt: createdAt != null ? ResponseWrapper(createdAt).mapFromResponseToDateTime() : null,
      updatedAt: updatedAt != null ? ResponseWrapper(updatedAt).mapFromResponseToDateTime() : null,
      deletedAt: deletedAt != null ? ResponseWrapper(deletedAt).mapFromResponseToDateTime() : null,
      readStatus: response["read_status"],
      userChat: ResponseWrapper(response["user"]).mapFromResponseToUserChat()
    );
  }
}