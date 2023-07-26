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
import '../../../misc/processing/future_processing.dart';

abstract class ChatDataSource {
  FutureProcessing<CreateHelpConversationResponse> createHelpConversation(CreateHelpConversationParameter createHelpConversationParameter);
  FutureProcessing<UpdateReadStatusHelpConversationResponse> updateReadStatusHelpConversation(UpdateReadStatusHelpConversationParameter updateReadStatusHelpConversationParameter);
  FutureProcessing<AnswerHelpConversationResponse> answerHelpConversation(AnswerHelpConversationParameter answerHelpConversationParameter);
  FutureProcessing<GetHelpMessageByConversationResponse> getHelpMessageByConversationResponse(GetHelpMessageByConversationParameter getHelpMessageByConversationParameter);
  FutureProcessing<GetHelpMessageByUserResponse> getHelpMessageByUserResponse(GetHelpMessageByUserParameter getHelpMessageByUserParameter);
}