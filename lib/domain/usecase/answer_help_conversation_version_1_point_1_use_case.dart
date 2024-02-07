import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/chat/help/answer_help_conversation_parameter.dart';
import '../entity/chat/help/answer_help_conversation_response.dart';
import '../repository/chat_repository.dart';

class AnswerHelpConversationVersion1Point1UseCase {
  final ChatRepository chatRepository;

  const AnswerHelpConversationVersion1Point1UseCase({
    required this.chatRepository
  });

  FutureProcessing<LoadDataResult<AnswerHelpConversationResponse>> execute(AnswerHelpConversationParameter answerHelpConversationParameter) {
    return chatRepository.answerHelpConversationVersion1Point1(answerHelpConversationParameter);
  }
}