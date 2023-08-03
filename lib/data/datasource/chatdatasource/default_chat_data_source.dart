import 'package:dio/dio.dart';
import 'package:masterbagasi/data/entitymappingext/chat_entity_mapping_ext.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/response_wrapper_ext.dart';

import '../../../domain/entity/chat/help/answer_help_conversation_parameter.dart';
import '../../../domain/entity/chat/help/answer_help_conversation_response.dart';
import '../../../domain/entity/chat/help/create_help_conversation_parameter.dart';
import '../../../domain/entity/chat/help/create_help_conversation_response.dart';
import '../../../domain/entity/chat/help/get_help_message_by_conversation_parameter.dart';
import '../../../domain/entity/chat/help/get_help_message_by_conversation_response.dart';
import '../../../domain/entity/chat/help/get_help_message_by_user_parameter.dart';
import '../../../domain/entity/chat/help/get_help_message_by_user_response.dart';
import '../../../domain/entity/chat/help/update_read_status_help_conversation_parameter.dart';
import '../../../domain/entity/chat/help/update_read_status_help_conversation_response.dart';
import '../../../domain/entity/chat/order/answer_order_conversation_parameter.dart';
import '../../../domain/entity/chat/order/answer_order_conversation_response.dart';
import '../../../domain/entity/chat/order/create_order_conversation_parameter.dart';
import '../../../domain/entity/chat/order/create_order_conversation_response.dart';
import '../../../domain/entity/chat/order/get_order_message_by_conversation_parameter.dart';
import '../../../domain/entity/chat/order/get_order_message_by_conversation_response.dart';
import '../../../domain/entity/chat/order/get_order_message_by_user_parameter.dart';
import '../../../domain/entity/chat/order/get_order_message_by_user_response.dart';
import '../../../domain/entity/chat/order/update_read_status_order_conversation_parameter.dart';
import '../../../domain/entity/chat/order/update_read_status_order_conversation_response.dart';
import '../../../misc/option_builder.dart';
import '../../../misc/processing/dio_http_client_processing.dart';
import '../../../misc/processing/future_processing.dart';
import 'chat_data_source.dart';

class DefaultChatDataSource implements ChatDataSource {
  final Dio dio;

  const DefaultChatDataSource({
    required this.dio
  });

  @override
  FutureProcessing<CreateHelpConversationResponse> createHelpConversation(CreateHelpConversationParameter createHelpConversationParameter) {
    FormData formData = FormData.fromMap(
      <String, dynamic> {
        "message": createHelpConversationParameter.message
      }
    );
    return DioHttpClientProcessing((cancelToken) {
      return dio.post("/chat-help", data: formData, cancelToken: cancelToken, options: OptionsBuilder.multipartData().build())
        .map<CreateHelpConversationResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToCreateHelpConversationResponse());
    });
  }

  @override
  FutureProcessing<AnswerHelpConversationResponse> answerHelpConversation(AnswerHelpConversationParameter answerHelpConversationParameter) {
    FormData formData = FormData.fromMap(
      <String, dynamic> {
        "message": answerHelpConversationParameter.message
      }
    );
    return DioHttpClientProcessing((cancelToken) {
      return dio.post("/chat-help/${answerHelpConversationParameter.helpConversationId}/message", data: formData, cancelToken: cancelToken, options: OptionsBuilder.multipartData().build())
        .map<AnswerHelpConversationResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToAnswerHelpConversationResponse());
    });
  }

  @override
  FutureProcessing<UpdateReadStatusHelpConversationResponse> updateReadStatusHelpConversation(UpdateReadStatusHelpConversationParameter updateReadStatusHelpConversationParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.post("/chat-help/update-status/${updateReadStatusHelpConversationParameter.helpConversationId}", cancelToken: cancelToken, options: OptionsBuilder.multipartData().build())
        .map<UpdateReadStatusHelpConversationResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToUpdateReadStatusHelpConversationResponse());
    });
  }

  @override
  FutureProcessing<GetHelpMessageByConversationResponse> getHelpMessageByConversationResponse(GetHelpMessageByConversationParameter getHelpMessageByConversationParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/chat-help/message/${getHelpMessageByConversationParameter.helpConversationId}", cancelToken: cancelToken)
        .map<GetHelpMessageByConversationResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToGetHelpMessageByConversationResponse());
    });
  }

  @override
  FutureProcessing<GetHelpMessageByUserResponse> getHelpMessageByUserResponse(GetHelpMessageByUserParameter getHelpMessageByUserParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/chat-help/user", cancelToken: cancelToken)
        .map<GetHelpMessageByUserResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToGetHelpMessageByUserResponse());
    });
  }

  @override
  FutureProcessing<CreateOrderConversationResponse> createOrderConversation(CreateOrderConversationParameter createOrderConversationParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/chat-help/user", cancelToken: cancelToken)
        .map<CreateOrderConversationResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToCreateOrderConversationResponse());
    });
  }

  @override
  FutureProcessing<UpdateReadStatusOrderConversationResponse> updateReadStatusOrderConversation(UpdateReadStatusOrderConversationParameter updateReadStatusOrderConversationParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/chat-help/user", cancelToken: cancelToken)
        .map<UpdateReadStatusOrderConversationResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToUpdateReadStatusOrderConversationResponse());
    });
  }

  @override
  FutureProcessing<AnswerOrderConversationResponse> answerOrderConversation(AnswerOrderConversationParameter answerOrderConversationParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/chat-help/user", cancelToken: cancelToken)
        .map<AnswerOrderConversationResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToAnswerOrderConversationResponse());
    });
  }

  @override
  FutureProcessing<GetOrderMessageByConversationResponse> getOrderMessageByConversation(GetOrderMessageByConversationParameter getOrderMessageByConversationParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/chat-help/user", cancelToken: cancelToken)
        .map<GetOrderMessageByConversationResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToGetOrderMessageByConversationResponse());
    });
  }

  @override
  FutureProcessing<GetOrderMessageByUserResponse> getOrderMessageByUser(GetOrderMessageByUserParameter getOrderMessageByUserParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/chat-help/user", cancelToken: cancelToken)
        .map<GetOrderMessageByUserResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToGetOrderMessageByUserResponse());
    });
  }
}