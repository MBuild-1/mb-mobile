import 'package:flutter/material.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../../domain/entity/cart/cart_list_parameter.dart';
import '../../domain/entity/chat/help/get_help_message_notification_count_parameter.dart';
import '../../domain/entity/notification/notification_by_user_list_parameter.dart';
import '../../domain/entity/notification/short_notification.dart';
import '../../domain/usecase/get_cart_list_use_case.dart';
import '../../domain/usecase/get_help_message_notification_count_use_case.dart';
import '../../domain/usecase/get_notification_by_user_list_use_case.dart';
import '../../misc/load_data_result.dart';
import '../../misc/manager/api_request_manager.dart';

class NotificationNotifier extends ChangeNotifier {
  late ApiRequestManager apiRequestManager;

  final GetNotificationByUserListUseCase getNotificationByUserListUseCase;
  final GetCartListUseCase getCartListUseCase;
  final GetHelpMessageNotificationCountUseCase getHelpMessageNotificationCountUseCase;

  LoadDataResult<int> _notificationLoadDataResult = NoLoadDataResult<int>();
  LoadDataResult<int> get notificationLoadDataResult => _notificationLoadDataResult;
  LoadDataResult<int> _transactionNotificationLoadDataResult = NoLoadDataResult<int>();
  LoadDataResult<int> get transactionNotificationLoadDataResult => _transactionNotificationLoadDataResult;
  LoadDataResult<int> _infoNotificationLoadDataResult = NoLoadDataResult<int>();
  LoadDataResult<int> get infoNotificationLoadDataResult => _infoNotificationLoadDataResult;
  LoadDataResult<int> _promoNotificationLoadDataResult = NoLoadDataResult<int>();
  LoadDataResult<int> get promoNotificationLoadDataResult => _promoNotificationLoadDataResult;

  LoadDataResult<int> _inboxLoadDataResult = NoLoadDataResult<int>();
  LoadDataResult<int> get inboxLoadDataResult => _inboxLoadDataResult;

  LoadDataResult<int> _cartLoadDataResult = NoLoadDataResult<int>();
  LoadDataResult<int> get cartLoadDataResult => _cartLoadDataResult;

  NotificationNotifier({
    required this.getNotificationByUserListUseCase,
    required this.getCartListUseCase,
    required this.getHelpMessageNotificationCountUseCase
  }) {
    apiRequestManager = ApiRequestManager();
    notifyListeners();
    loadAllNotification();
  }

  void loadAllNotification() {
    loadNotificationLoadDataResult();
    loadInboxLoadDataResult();
    loadCartLoadDataResult();
  }

  Future<void> startLoadingNotificationLoadDataResult() async {
    _notificationLoadDataResult = IsLoadingLoadDataResult<int>();
    _transactionNotificationLoadDataResult = IsLoadingLoadDataResult<int>();
    _infoNotificationLoadDataResult = IsLoadingLoadDataResult<int>();
    _promoNotificationLoadDataResult = IsLoadingLoadDataResult<int>();
    notifyListeners();
  }

  Future<void> beginProcessLoadNotificationLoadDataResult() async {
    LoadDataResult<List<ShortNotification>> shortNotificationLoadDataResult = await getNotificationByUserListUseCase.execute(
      NotificationByUserListParameter()
    ).future(
      parameter: apiRequestManager.addRequestToCancellationPart("notification").value
    ).map<List<ShortNotification>>(
      (value) => value.where((shortNotification) => shortNotification.isRead == 0).toList()
    );
    _notificationLoadDataResult = shortNotificationLoadDataResult.map<int>(
      (getUserResponse) => getUserResponse.length
    );
    _transactionNotificationLoadDataResult = shortNotificationLoadDataResult.map<List<ShortNotification>>(
      (value) => value.where(
        (shortNotification) => shortNotification.type.toLowerCase() == "transaction"
      ).toList()
    ).map<int>(
      (getUserResponse) => getUserResponse.length
    );
    _infoNotificationLoadDataResult = shortNotificationLoadDataResult.map<List<ShortNotification>>(
      (value) => value.where(
        (shortNotification) => shortNotification.type.toLowerCase() == "info"
      ).toList()
    ).map<int>(
      (getUserResponse) => getUserResponse.length
    );
    _promoNotificationLoadDataResult = shortNotificationLoadDataResult.map<List<ShortNotification>>(
      (value) => value.where(
        (shortNotification) => shortNotification.type.toLowerCase() == "promo"
      ).toList()
    ).map<int>(
      (getUserResponse) => getUserResponse.length
    );
    notifyListeners();
  }

  void loadNotificationLoadDataResult() async {
    await startLoadingNotificationLoadDataResult();
    await beginProcessLoadNotificationLoadDataResult();
  }

  void loadInboxLoadDataResult() async {
    _inboxLoadDataResult = IsLoadingLoadDataResult<int>();
    notifyListeners();
    _inboxLoadDataResult = await getHelpMessageNotificationCountUseCase.execute(
      GetHelpMessageNotificationCountParameter()
    ).future(
      parameter: apiRequestManager.addRequestToCancellationPart("inbox").value
    ).map<int>(
      (value) => value.unreadMessagesUserTwo
    );
    notifyListeners();
  }

  void loadCartLoadDataResult() async {
    _cartLoadDataResult = IsLoadingLoadDataResult<int>();
    notifyListeners();
    _cartLoadDataResult = await getCartListUseCase.execute(
      CartListParameter()
    ).future(
      parameter: apiRequestManager.addRequestToCancellationPart("cart").value
    ).map<int>(
      (cartList) => cartList.length
    );
    notifyListeners();
  }

  void resetNotification() {
    _inboxLoadDataResult = SuccessLoadDataResult<int>(
      value: 0
    );
    _cartLoadDataResult = SuccessLoadDataResult<int>(
      value: 0
    );
    _notificationLoadDataResult = SuccessLoadDataResult<int>(
      value: 0
    );
    notifyListeners();
  }
}