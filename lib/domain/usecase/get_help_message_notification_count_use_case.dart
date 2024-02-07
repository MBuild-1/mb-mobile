import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/chat/help/get_help_message_notification_count_parameter.dart';
import '../entity/chat/help/get_help_message_notification_count_response.dart';
import '../repository/chat_repository.dart';

class GetHelpMessageNotificationCountUseCase {
  final ChatRepository chatRepository;

  const GetHelpMessageNotificationCountUseCase({
    required this.chatRepository
  });

  FutureProcessing<LoadDataResult<GetHelpMessageNotificationCountResponse>> execute(GetHelpMessageNotificationCountParameter getHelpMessageNotificationCountParameter) {
    return chatRepository.getHelpMessageNotificationCount(getHelpMessageNotificationCountParameter);
  }
}