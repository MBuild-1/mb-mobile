import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/notification/read_all_notification_parameter.dart';
import '../entity/notification/read_all_notification_response.dart';
import '../repository/notification_repository.dart';

class ReadAllNotificationUseCase {
  final NotificationRepository notificationRepository;

  const ReadAllNotificationUseCase({
    required this.notificationRepository
  });

  FutureProcessing<LoadDataResult<ReadAllNotificationResponse>> execute(ReadAllNotificationParameter readAllNotificationParameter) {
    return notificationRepository.readAllNotification(readAllNotificationParameter);
  }
}