import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/notification/notification_order_status_parameter.dart';
import '../entity/notification/notification_order_status_response.dart';
import '../repository/notification_repository.dart';

class NotificationOrderStatusUseCase {
  final NotificationRepository notificationRepository;

  const NotificationOrderStatusUseCase({
    required this.notificationRepository
  });

  FutureProcessing<LoadDataResult<NotificationOrderStatusResponse>> execute(NotificationOrderStatusParameter notificationOrderStatusParameter) {
    return notificationRepository.notificationOrderStatus(notificationOrderStatusParameter);
  }
}