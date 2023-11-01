import '../../domain/entity/notification/notification.dart';
import '../../domain/entity/notification/notification_by_user_list_parameter.dart';
import '../../domain/entity/notification/notification_by_user_paging_parameter.dart';
import '../../domain/entity/notification/notification_order_status_parameter.dart';
import '../../domain/entity/notification/notification_order_status_response.dart';
import '../../domain/entity/notification/read_all_notification_parameter.dart';
import '../../domain/entity/notification/read_all_notification_response.dart';
import '../../domain/entity/notification/short_notification.dart';
import '../../domain/entity/notification/transaction_notification_detail_parameter.dart';
import '../../domain/repository/notification_repository.dart';
import '../../misc/load_data_result.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../datasource/notificationdatasource/notification_data_source.dart';

class DefaultNotificationRepository implements NotificationRepository {
  final NotificationDataSource notificationDataSource;

  const DefaultNotificationRepository({
    required this.notificationDataSource
  });

  @override
  FutureProcessing<LoadDataResult<PagingDataResult<ShortNotification>>> notificationByUserPaging(NotificationByUserPagingParameter notificationByUserPagingParameter) {
    return notificationDataSource.notificationByUserPaging(notificationByUserPagingParameter).mapToLoadDataResult<PagingDataResult<ShortNotification>>();
  }

  @override
  FutureProcessing<LoadDataResult<List<ShortNotification>>> notificationByUserList(NotificationByUserListParameter notificationByUserListParameter) {
    return notificationDataSource.notificationByUserList(notificationByUserListParameter).mapToLoadDataResult<List<ShortNotification>>();
  }

  @override
  FutureProcessing<LoadDataResult<Notification>> transactionNotificationDetail(TransactionNotificationDetailParameter transactionNotificationDetailParameter) {
    return notificationDataSource.transactionNotificationDetail(transactionNotificationDetailParameter).mapToLoadDataResult<Notification>();
  }

  @override
  FutureProcessing<LoadDataResult<NotificationOrderStatusResponse>> notificationOrderStatus(NotificationOrderStatusParameter notificationOrderStatusParameter) {
    return notificationDataSource.notificationOrderStatus(notificationOrderStatusParameter).mapToLoadDataResult<NotificationOrderStatusResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<ReadAllNotificationResponse>> readAllNotification(ReadAllNotificationParameter readAllNotificationParameter) {
    return notificationDataSource.readAllNotification(readAllNotificationParameter).mapToLoadDataResult<ReadAllNotificationResponse>();
  }
}