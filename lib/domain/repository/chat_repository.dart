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

abstract class ChatRepository {
  FutureProcessing<LoadDataResult<CreateHelpConversationResponse>> createHelpConversation(CreateHelpConversationParameter createHelpConversationParameter);
  FutureProcessing<LoadDataResult<UpdateReadStatusHelpConversationResponse>> updateReadStatusHelpConversation(UpdateReadStatusHelpConversationParameter updateReadStatusHelpConversationParameter);
  FutureProcessing<LoadDataResult<AnswerHelpConversationResponse>> answerHelpConversation(AnswerHelpConversationParameter answerHelpConversationParameter);
  FutureProcessing<LoadDataResult<GetHelpMessageByConversationResponse>> getHelpMessageByConversation(GetHelpMessageByConversationParameter getHelpMessageByConversationParameter);
  FutureProcessing<LoadDataResult<GetHelpMessageByUserResponse>> getHelpMessageByUser(GetHelpMessageByUserParameter getHelpMessageByUserParameter);
}