import 'package:dio/dio.dart';
import 'package:masterbagasi/data/entitymappingext/notification_entity_mapping_ext.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/response_wrapper_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

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
import '../../../misc/processing/dio_http_client_processing.dart';
import '../../../misc/processing/future_processing.dart';
import 'notification_data_source.dart';

class DefaultNotificationDataSource implements NotificationDataSource {
  final Dio dio;

  const DefaultNotificationDataSource({
    required this.dio
  });

  @override
  FutureProcessing<PagingDataResult<ShortNotification>> notificationByUserPaging(NotificationByUserPagingParameter notificationByUserPagingParameter) {
    return DioHttpClientProcessing((cancelToken) {
      Map<String, dynamic> queryParameters = {
        "page": notificationByUserPagingParameter.page,
        "pageNumber": notificationByUserPagingParameter.itemEachPageCount,
        if (notificationByUserPagingParameter.search.isNotEmptyString) "search": notificationByUserPagingParameter.search!
      };
      return dio.get("/notification", queryParameters: queryParameters, cancelToken: cancelToken)
        .map<PagingDataResult<ShortNotification>>(onMap: (value) => value.wrapResponse().mapFromResponseToShortNotificationPagingDataResult());
    });
  }

  @override
  FutureProcessing<List<ShortNotification>> notificationByUserList(NotificationByUserListParameter notificationByListPagingParameter) {
    return DioHttpClientProcessing((cancelToken) {
      Map<String, dynamic> queryParameters = {
        if (notificationByListPagingParameter.search.isNotEmptyString) "search": notificationByListPagingParameter.search!
      };
      return dio.get("/notification", queryParameters: queryParameters, cancelToken: cancelToken)
        .map<List<ShortNotification>>(onMap: (value) => value.wrapResponse().mapFromResponseToShortNotificationList());
    });
  }

  @override
  FutureProcessing<Notification> transactionNotificationDetail(TransactionNotificationDetailParameter transactionNotificationDetailParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/notification/${transactionNotificationDetailParameter.notificationId}/transaction", cancelToken: cancelToken)
        .map<Notification>(onMap: (value) => value.wrapResponse().mapFromResponseToNotification());
    });
  }

  @override
  FutureProcessing<NotificationOrderStatusResponse> notificationOrderStatus(NotificationOrderStatusParameter notificationOrderStatusParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/notification/order/status", cancelToken: cancelToken)
        .map<NotificationOrderStatusResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToNotificationOrderStatusResponse());
    });
  }

  @override
  FutureProcessing<ReadAllNotificationResponse> readAllNotification(ReadAllNotificationParameter readAllNotificationParameter) {
    return DioHttpClientProcessing((cancelToken) {
      Map<String, dynamic> queryParameters = {
        if (readAllNotificationParameter.type.isNotEmptyString) "type": readAllNotificationParameter.type
      };
      return dio.post("/notification/read-all", queryParameters: queryParameters, cancelToken: cancelToken)
        .map<ReadAllNotificationResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToReadAllNotificationResponse());
    });
  }
}