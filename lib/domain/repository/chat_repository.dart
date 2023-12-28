import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/chat/chattemplate/chat_template_parameter.dart';
import '../entity/chat/chattemplate/chat_template_response.dart';
import '../entity/chat/help/answer_help_conversation_parameter.dart';
import '../entity/chat/help/answer_help_conversation_response.dart';
import '../entity/chat/help/create_help_conversation_parameter.dart';
import '../entity/chat/help/create_help_conversation_response.dart';
import '../entity/chat/help/get_help_message_by_conversation_parameter.dart';
import '../entity/chat/help/get_help_message_by_conversation_response.dart';
import '../entity/chat/help/get_help_message_by_user_parameter.dart';
import '../entity/chat/help/get_help_message_by_user_response.dart';
import '../entity/chat/help/get_help_message_notification_count_parameter.dart';
import '../entity/chat/help/get_help_message_notification_count_response.dart';
import '../entity/chat/help/update_read_status_help_conversation_parameter.dart';
import '../entity/chat/help/update_read_status_help_conversation_response.dart';
import '../entity/chat/order/answer_order_conversation_parameter.dart';
import '../entity/chat/order/answer_order_conversation_response.dart';
import '../entity/chat/order/answer_order_conversation_version_1_point_1_parameter.dart';
import '../entity/chat/order/answer_order_conversation_version_1_point_1_response.dart';
import '../entity/chat/order/create_order_conversation_parameter.dart';
import '../entity/chat/order/create_order_conversation_response.dart';
import '../entity/chat/order/get_order_message_by_combined_order_parameter.dart';
import '../entity/chat/order/get_order_message_by_combined_order_response.dart';
import '../entity/chat/order/get_order_message_by_conversation_parameter.dart';
import '../entity/chat/order/get_order_message_by_conversation_response.dart';
import '../entity/chat/order/get_order_message_by_user_parameter.dart';
import '../entity/chat/order/get_order_message_by_user_response.dart';
import '../entity/chat/order/update_read_status_order_conversation_parameter.dart';
import '../entity/chat/order/update_read_status_order_conversation_response.dart';
import '../entity/chat/product/answer_product_conversation_parameter.dart';
import '../entity/chat/product/answer_product_conversation_response.dart';
import '../entity/chat/product/create_product_conversation_parameter.dart';
import '../entity/chat/product/create_product_conversation_response.dart';
import '../entity/chat/product/get_product_message_by_conversation_parameter.dart';
import '../entity/chat/product/get_product_message_by_conversation_response.dart';
import '../entity/chat/product/get_product_message_by_product_parameter.dart';
import '../entity/chat/product/get_product_message_by_product_response.dart';
import '../entity/chat/product/get_product_message_by_user_parameter.dart';
import '../entity/chat/product/get_product_message_by_user_response.dart';
import '../entity/chat/product/update_read_status_product_conversation_parameter.dart';
import '../entity/chat/product/update_read_status_product_conversation_response.dart';

abstract class ChatRepository {
  FutureProcessing<LoadDataResult<CreateHelpConversationResponse>> createHelpConversation(CreateHelpConversationParameter createHelpConversationParameter);
  FutureProcessing<LoadDataResult<UpdateReadStatusHelpConversationResponse>> updateReadStatusHelpConversation(UpdateReadStatusHelpConversationParameter updateReadStatusHelpConversationParameter);
  FutureProcessing<LoadDataResult<AnswerHelpConversationResponse>> answerHelpConversation(AnswerHelpConversationParameter answerHelpConversationParameter);
  FutureProcessing<LoadDataResult<AnswerHelpConversationResponse>> answerHelpConversationVersion1Point1(AnswerHelpConversationParameter answerHelpConversationParameter);
  FutureProcessing<LoadDataResult<GetHelpMessageByConversationResponse>> getHelpMessageByConversation(GetHelpMessageByConversationParameter getHelpMessageByConversationParameter);
  FutureProcessing<LoadDataResult<GetHelpMessageByUserResponse>> getHelpMessageByUser(GetHelpMessageByUserParameter getHelpMessageByUserParameter);
  FutureProcessing<LoadDataResult<GetHelpMessageNotificationCountResponse>> getHelpMessageNotificationCount(GetHelpMessageNotificationCountParameter getHelpMessageNotificationCountParameter);
  FutureProcessing<LoadDataResult<CreateOrderConversationResponse>> createOrderConversation(CreateOrderConversationParameter createOrderConversationParameter);
  FutureProcessing<LoadDataResult<UpdateReadStatusOrderConversationResponse>> updateReadStatusOrderConversation(UpdateReadStatusOrderConversationParameter updateReadStatusOrderConversationParameter);
  FutureProcessing<LoadDataResult<AnswerOrderConversationResponse>> answerOrderConversation(AnswerOrderConversationParameter answerOrderConversationParameter);
  FutureProcessing<LoadDataResult<AnswerOrderConversationVersion1Point1Response>> answerOrderConversationVersion1Point1(AnswerOrderConversationVersion1Point1Parameter answerOrderConversationVersion1Point1Parameter);
  FutureProcessing<LoadDataResult<GetOrderMessageByConversationResponse>> getOrderMessageByConversation(GetOrderMessageByConversationParameter getOrderMessageByConversationParameter);
  FutureProcessing<LoadDataResult<GetOrderMessageByUserResponse>> getOrderMessageByUser(GetOrderMessageByUserParameter getOrderMessageByUserParameter);
  FutureProcessing<LoadDataResult<GetOrderMessageByCombinedOrderResponse>> getOrderMessageByCombinedOrder(GetOrderMessageByCombinedOrderParameter getOrderMessageByCombinedOrderParameter);
  FutureProcessing<LoadDataResult<CreateProductConversationResponse>> createProductConversation(CreateProductConversationParameter createProductConversationParameter);
  FutureProcessing<LoadDataResult<UpdateReadStatusProductConversationResponse>> updateReadStatusProductConversation(UpdateReadStatusProductConversationParameter updateReadStatusProductConversationParameter);
  FutureProcessing<LoadDataResult<AnswerProductConversationResponse>> answerProductConversation(AnswerProductConversationParameter answerProductConversationParameter);
  FutureProcessing<LoadDataResult<GetProductMessageByConversationResponse>> getProductMessageByConversation(GetProductMessageByConversationParameter getProductMessageByConversationParameter);
  FutureProcessing<LoadDataResult<GetProductMessageByUserResponse>> getProductMessageByUser(GetProductMessageByUserParameter getProductMessageByUserParameter);
  FutureProcessing<LoadDataResult<GetProductMessageByProductResponse>> getProductMessageByProduct(GetProductMessageByProductParameter getProductMessageByUserParameter);
  FutureProcessing<LoadDataResult<HelpChatTemplateResponse>> helpChatTemplate(HelpChatTemplateParameter helpChatTemplateParameter);
}