import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/chat/order/answer_order_conversation_version_1_point_1_parameter.dart';
import '../entity/chat/order/answer_order_conversation_version_1_point_1_response.dart';
import '../repository/chat_repository.dart';

class AnswerOrderConversationVersion1Point1UseCase {
  final ChatRepository chatRepository;

  const AnswerOrderConversationVersion1Point1UseCase({
    required this.chatRepository
  });

  FutureProcessing<LoadDataResult<AnswerOrderConversationVersion1Point1Response>> execute(AnswerOrderConversationVersion1Point1Parameter answerOrderConversationVersion1Point1Parameter) {
    return chatRepository.answerOrderConversationVersion1Point1(answerOrderConversationVersion1Point1Parameter);
  }
}