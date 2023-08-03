import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/chat/help/answer_help_conversation_parameter.dart';
import '../entity/chat/help/answer_help_conversation_response.dart';
import '../entity/chat/help/create_help_conversation_parameter.dart';
import '../entity/chat/help/create_help_conversation_response.dart';
import '../entity/chat/help/get_help_message_by_conversation_parameter.dart';
import '../entity/chat/help/get_help_message_by_conversation_response.dart';
import '../entity/chat/help/get_help_message_by_user_parameter.dart';
import '../entity/chat/help/get_help_message_by_user_response.dart';
import '../entity/chat/help/update_read_status_help_conversation_parameter.dart';
import '../entity/chat/help/update_read_status_help_conversation_response.dart';
import '../entity/chat/order/answer_order_conversation_parameter.dart';
import '../entity/chat/order/answer_order_conversation_response.dart';
import '../entity/chat/order/create_order_conversation_parameter.dart';
import '../entity/chat/order/create_order_conversation_response.dart';
import '../entity/chat/order/get_order_message_by_conversation_parameter.dart';
import '../entity/chat/order/get_order_message_by_conversation_response.dart';
import '../entity/chat/order/get_order_message_by_user_parameter.dart';
import '../entity/chat/order/get_order_message_by_user_response.dart';
import '../entity/chat/order/update_read_status_order_conversation_parameter.dart';
import '../entity/chat/order/update_read_status_order_conversation_response.dart';

abstract class ChatRepository {
  FutureProcessing<LoadDataResult<CreateHelpConversationResponse>> createHelpConversation(CreateHelpConversationParameter createHelpConversationParameter);
  FutureProcessing<LoadDataResult<UpdateReadStatusHelpConversationResponse>> updateReadStatusHelpConversation(UpdateReadStatusHelpConversationParameter updateReadStatusHelpConversationParameter);
  FutureProcessing<LoadDataResult<AnswerHelpConversationResponse>> answerHelpConversation(AnswerHelpConversationParameter answerHelpConversationParameter);
  FutureProcessing<LoadDataResult<GetHelpMessageByConversationResponse>> getHelpMessageByConversation(GetHelpMessageByConversationParameter getHelpMessageByConversationParameter);
  FutureProcessing<LoadDataResult<GetHelpMessageByUserResponse>> getHelpMessageByUser(GetHelpMessageByUserParameter getHelpMessageByUserParameter);
  FutureProcessing<LoadDataResult<CreateOrderConversationResponse>> createOrderConversation(CreateOrderConversationParameter createOrderConversationParameter);
  FutureProcessing<LoadDataResult<UpdateReadStatusOrderConversationResponse>> updateReadStatusOrderConversation(UpdateReadStatusOrderConversationParameter updateReadStatusOrderConversationParameter);
  FutureProcessing<LoadDataResult<AnswerOrderConversationResponse>> answerOrderConversation(AnswerOrderConversationParameter answerOrderConversationParameter);
  FutureProcessing<LoadDataResult<GetOrderMessageByConversationResponse>> getOrderMessageByConversation(GetOrderMessageByConversationParameter getOrderMessageByConversationParameter);
  FutureProcessing<LoadDataResult<GetOrderMessageByUserResponse>> getOrderMessageByUser(GetOrderMessageByUserParameter getOrderMessageByUserParameter);
}