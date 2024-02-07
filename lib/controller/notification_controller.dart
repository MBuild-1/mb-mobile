import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../domain/entity/notification/notification.dart';
import '../domain/entity/notification/notification_by_user_paging_parameter.dart';
import '../domain/entity/notification/notification_order_status_parameter.dart';
import '../domain/entity/notification/notification_order_status_response.dart';
import '../domain/entity/notification/read_all_notification_parameter.dart';
import '../domain/entity/notification/read_all_notification_response.dart';
import '../domain/entity/notification/read_transaction_notification_parameter.dart';
import '../domain/entity/notification/read_transaction_notification_response.dart';
import '../domain/entity/notification/short_notification.dart';
import '../domain/entity/notification/transaction_notification_detail_parameter.dart';
import '../domain/usecase/get_notification_by_user_paging_use_case.dart';
import '../domain/usecase/get_transaction_notification_detail_use_case.dart';
import '../domain/usecase/notification_order_status_use_case.dart';
import '../domain/usecase/read_all_notification_use_case.dart';
import '../domain/usecase/read_transaction_notification_use_case.dart';
import '../misc/load_data_result.dart';
import '../misc/paging/pagingresult/paging_data_result.dart';
import '../misc/typedef.dart';
import 'base_getx_controller.dart';

typedef _OnShowReadAllNotificationRequestProcessLoadingCallback = Future<void> Function();
typedef _OnReadAllNotificationRequestProcessSuccessCallback = Future<void> Function(ReadAllNotificationResponse);
typedef _OnShowReadAllNotificationRequestProcessFailedCallback = Future<void> Function(dynamic e);
typedef _OnShowReadTransactionNotificationRequestProcessLoadingCallback = Future<void> Function();
typedef _OnReadTransactionNotificationRequestProcessSuccessCallback = Future<void> Function(ReadTransactionNotificationResponse, String);
typedef _OnShowReadTransactionNotificationRequestProcessFailedCallback = Future<void> Function(dynamic e);

class NotificationController extends BaseGetxController {
  final GetNotificationByUserPagingUseCase getNotificationByUserPagingUseCase;
  final GetTransactionNotificationDetailUseCase getTransactionNotificationDetailUseCase;
  final NotificationOrderStatusUseCase notificationOrderStatusUseCase;
  final ReadAllNotificationUseCase readAllNotificationUseCase;
  final ReadTransactionNotificationUseCase readTransactionNotificationUseCase;
  NotificationDelegate? _notificationDelegate;

  NotificationController(
    super.controllerManager,
    this.getNotificationByUserPagingUseCase,
    this.getTransactionNotificationDetailUseCase,
    this.notificationOrderStatusUseCase,
    this.readAllNotificationUseCase,
    this.readTransactionNotificationUseCase
  );

  Future<LoadDataResult<PagingDataResult<ShortNotification>>> getNotificationByUser(NotificationByUserPagingParameter notificationByUserPagingParameter) {
    return getNotificationByUserPagingUseCase.execute(notificationByUserPagingParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("notification-by-user").value
    );
  }

  Future<LoadDataResult<Notification>> getTransactionNotificationDetail(TransactionNotificationDetailParameter transactionNotificationDetailParameter) {
    return getTransactionNotificationDetailUseCase.execute(transactionNotificationDetailParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("transaction-detail-notification").value
    );
  }

  Future<LoadDataResult<NotificationOrderStatusResponse>> notificationOrderStatus(NotificationOrderStatusParameter notificationOrderStatusParameter) {
    return notificationOrderStatusUseCase.execute(notificationOrderStatusParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("notification-order-status").value
    );
  }

  void setNotificationDelegate(NotificationDelegate notificationDelegate) {
    _notificationDelegate = notificationDelegate;
  }

  void readAllNotification(String type) async {
    if (_notificationDelegate != null) {
      _notificationDelegate!.onUnfocusAllWidget();
      _notificationDelegate!.onShowReadAllNotificationRequestProcessLoadingCallback();
      LoadDataResult<ReadAllNotificationResponse> readAllNotificationResponseLoadDataResult = await readAllNotificationUseCase.execute(
        ReadAllNotificationParameter(type: type)
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart("read-all-notification").value
      );
      _notificationDelegate!.onBack();
      if (readAllNotificationResponseLoadDataResult.isSuccess) {
        _notificationDelegate!.onReadAllNotificationRequestProcessSuccessCallback(readAllNotificationResponseLoadDataResult.resultIfSuccess!);
      } else {
        _notificationDelegate!.onShowReadAllNotificationRequestProcessFailedCallback(readAllNotificationResponseLoadDataResult.resultIfFailed);
      }
    }
  }

  void readAllNotificationWhileNavigatingToOtherTabRequest(String type) async {
    if (_notificationDelegate != null) {
      _notificationDelegate!.onUnfocusAllWidget();
      LoadDataResult<ReadAllNotificationResponse> readAllNotificationResponseLoadDataResult = await readAllNotificationUseCase.execute(
        ReadAllNotificationParameter(type: type)
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart("read-all-notification-while-navigating-to-other-tab-request").value
      );
      if (readAllNotificationResponseLoadDataResult.isFailedBecauseCancellation) {
        return;
      }
      if (readAllNotificationResponseLoadDataResult.isSuccess) {
        _notificationDelegate!.onReadAllNotificationWhileNavigatingToOtherTabRequestProcessSuccessCallback(readAllNotificationResponseLoadDataResult.resultIfSuccess!);
      } else {
        _notificationDelegate!.onShowReadAllNotificationWhileNavigatingToOtherTabRequestProcessFailedCallback(readAllNotificationResponseLoadDataResult.resultIfFailed);
      }
    }
  }

  void readTransactionNotification(String notificationId) async {
    if (_notificationDelegate != null) {
      _notificationDelegate!.onUnfocusAllWidget();
      _notificationDelegate!.onShowReadTransactionNotificationRequestProcessLoadingCallback();
      LoadDataResult<ReadTransactionNotificationResponse> readTransactionNotificationResponseLoadDataResult = await readTransactionNotificationUseCase.execute(
        ReadTransactionNotificationParameter(notificationId: notificationId)
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart("read-transaction-notification").value
      );
      _notificationDelegate!.onBack();
      if (readTransactionNotificationResponseLoadDataResult.isSuccess) {
        _notificationDelegate!.onReadTransactionNotificationRequestProcessSuccessCallback(
          readTransactionNotificationResponseLoadDataResult.resultIfSuccess!, notificationId
        );
      } else {
        _notificationDelegate!.onShowReadTransactionNotificationRequestProcessFailedCallback(readTransactionNotificationResponseLoadDataResult.resultIfFailed);
      }
    }
  }
}

class NotificationDelegate {
  OnUnfocusAllWidget onUnfocusAllWidget;
  _OnShowReadAllNotificationRequestProcessLoadingCallback onShowReadAllNotificationRequestProcessLoadingCallback;
  _OnReadAllNotificationRequestProcessSuccessCallback onReadAllNotificationRequestProcessSuccessCallback;
  _OnShowReadAllNotificationRequestProcessFailedCallback onShowReadAllNotificationRequestProcessFailedCallback;
  _OnShowReadAllNotificationRequestProcessLoadingCallback onShowReadAllNotificationWhileNavigatingToOtherTabRequestProcessLoadingCallback;
  _OnReadAllNotificationRequestProcessSuccessCallback onReadAllNotificationWhileNavigatingToOtherTabRequestProcessSuccessCallback;
  _OnShowReadAllNotificationRequestProcessFailedCallback onShowReadAllNotificationWhileNavigatingToOtherTabRequestProcessFailedCallback;
  _OnShowReadTransactionNotificationRequestProcessLoadingCallback onShowReadTransactionNotificationRequestProcessLoadingCallback;
  _OnReadTransactionNotificationRequestProcessSuccessCallback onReadTransactionNotificationRequestProcessSuccessCallback;
  _OnShowReadTransactionNotificationRequestProcessFailedCallback onShowReadTransactionNotificationRequestProcessFailedCallback;
  void Function() onBack;

  NotificationDelegate({
    required this.onUnfocusAllWidget,
    required this.onShowReadAllNotificationRequestProcessLoadingCallback,
    required this.onReadAllNotificationRequestProcessSuccessCallback,
    required this.onShowReadAllNotificationRequestProcessFailedCallback,
    required this.onShowReadAllNotificationWhileNavigatingToOtherTabRequestProcessLoadingCallback,
    required this.onReadAllNotificationWhileNavigatingToOtherTabRequestProcessSuccessCallback,
    required this.onShowReadAllNotificationWhileNavigatingToOtherTabRequestProcessFailedCallback,
    required this.onShowReadTransactionNotificationRequestProcessLoadingCallback,
    required this.onReadTransactionNotificationRequestProcessSuccessCallback,
    required this.onShowReadTransactionNotificationRequestProcessFailedCallback,
    required this.onBack
  });
}