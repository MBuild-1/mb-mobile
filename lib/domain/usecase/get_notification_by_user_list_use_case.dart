import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/notification/notification_by_user_list_parameter.dart';
import '../entity/notification/short_notification.dart';
import '../repository/notification_repository.dart';

class GetNotificationByUserListUseCase {
  final NotificationRepository notificationRepository;

  const GetNotificationByUserListUseCase({
    required this.notificationRepository
  });

  FutureProcessing<LoadDataResult<List<ShortNotification>>> execute(NotificationByUserListParameter notificationByUserListParameter) {
    return notificationRepository.notificationByUserList(notificationByUserListParameter);
  }
}