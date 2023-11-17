import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/notification/read_transaction_notification_parameter.dart';
import '../entity/notification/read_transaction_notification_response.dart';
import '../repository/notification_repository.dart';

class ReadTransactionNotificationUseCase {
  final NotificationRepository notificationRepository;

  const ReadTransactionNotificationUseCase({
    required this.notificationRepository
  });

  FutureProcessing<LoadDataResult<ReadTransactionNotificationResponse>> execute(ReadTransactionNotificationParameter readTransactionNotificationParameter) {
    return notificationRepository.readTransactionNotification(readTransactionNotificationParameter);
  }
}