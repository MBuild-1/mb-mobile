import '../../../domain/entity/notification/notification.dart';
import '../../../domain/entity/notification/notification_by_user_list_parameter.dart';
import '../../../domain/entity/notification/notification_by_user_paging_parameter.dart';
import '../../../domain/entity/notification/notification_order_status_parameter.dart';
import '../../../domain/entity/notification/notification_order_status_response.dart';
import '../../../domain/entity/notification/read_all_notification_parameter.dart';
import '../../../domain/entity/notification/read_all_notification_response.dart';
import '../../../domain/entity/notification/short_notification.dart';
import '../../../domain/entity/notification/transaction_notification_detail_parameter.dart';
import '../../../misc/paging/pagingresult/paging_data_result.dart';
import '../../../misc/processing/future_processing.dart';

abstract class NotificationDataSource {
  FutureProcessing<PagingDataResult<ShortNotification>> notificationByUserPaging(NotificationByUserPagingParameter notificationByUserPagingParameter);
  FutureProcessing<List<ShortNotification>> notificationByUserList(NotificationByUserListParameter notificationByUserListParameter);
  FutureProcessing<Notification> transactionNotificationDetail(TransactionNotificationDetailParameter transactionNotificationDetailParameter);
  FutureProcessing<NotificationOrderStatusResponse> notificationOrderStatus(NotificationOrderStatusParameter notificationOrderStatusParameter);
  FutureProcessing<ReadAllNotificationResponse> readAllNotification(ReadAllNotificationParameter readAllNotificationParameter);
}