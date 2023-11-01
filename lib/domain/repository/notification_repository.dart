import '../../misc/load_data_result.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/notification/notification.dart';
import '../entity/notification/notification_by_user_list_parameter.dart';
import '../entity/notification/notification_by_user_paging_parameter.dart';
import '../entity/notification/notification_order_status_parameter.dart';
import '../entity/notification/notification_order_status_response.dart';
import '../entity/notification/read_all_notification_parameter.dart';
import '../entity/notification/read_all_notification_response.dart';
import '../entity/notification/short_notification.dart';
import '../entity/notification/transaction_notification_detail_parameter.dart';

abstract class NotificationRepository {
  FutureProcessing<LoadDataResult<PagingDataResult<ShortNotification>>> notificationByUserPaging(NotificationByUserPagingParameter notificationByUserPagingParameter);
  FutureProcessing<LoadDataResult<List<ShortNotification>>> notificationByUserList(NotificationByUserListParameter notificationByUserListParameter);
  FutureProcessing<LoadDataResult<Notification>> transactionNotificationDetail(TransactionNotificationDetailParameter transactionNotificationDetailParameter);
  FutureProcessing<LoadDataResult<NotificationOrderStatusResponse>> notificationOrderStatus(NotificationOrderStatusParameter notificationOrderStatusParameter);
  FutureProcessing<LoadDataResult<ReadAllNotificationResponse>> readAllNotification(ReadAllNotificationParameter readAllNotificationParameter);
}