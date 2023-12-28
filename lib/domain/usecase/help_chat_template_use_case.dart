import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/chat/chattemplate/chat_template_parameter.dart';
import '../entity/chat/chattemplate/chat_template_response.dart';
import '../repository/chat_repository.dart';

class HelpChatTemplateUseCase {
  final ChatRepository chatRepository;

  const HelpChatTemplateUseCase({
    required this.chatRepository
  });

  FutureProcessing<LoadDataResult<HelpChatTemplateResponse>> execute(HelpChatTemplateParameter helpChatTemplateParameter) {
    return chatRepository.helpChatTemplate(helpChatTemplateParameter);
  }
}