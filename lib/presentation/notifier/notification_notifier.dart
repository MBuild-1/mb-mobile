import 'package:flutter/material.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';

import '../../domain/entity/cart/cart_list_parameter.dart';
import '../../domain/entity/notification/notification_by_user_list_parameter.dart';
import '../../domain/entity/notification/notification_by_user_paging_parameter.dart';
import '../../domain/usecase/get_cart_list_use_case.dart';
import '../../domain/usecase/get_notification_by_user_list_use_case.dart';
import '../../misc/load_data_result.dart';
import '../../misc/manager/api_request_manager.dart';

class NotificationNotifier extends ChangeNotifier {
  late ApiRequestManager apiRequestManager;

  final GetNotificationByUserListUseCase getNotificationByUserListUseCase;
  final GetCartListUseCase getCartListUseCase;

  LoadDataResult<int> _notificationLoadDataResult = NoLoadDataResult<int>();
  LoadDataResult<int> get notificationLoadDataResult => _notificationLoadDataResult;

  LoadDataResult<int> _inboxLoadDataResult = NoLoadDataResult<int>();
  LoadDataResult<int> get inboxLoadDataResult => _inboxLoadDataResult;

  LoadDataResult<int> _cartLoadDataResult = NoLoadDataResult<int>();
  LoadDataResult<int> get cartLoadDataResult => _cartLoadDataResult;

  NotificationNotifier({
    required this.getNotificationByUserListUseCase,
    required this.getCartListUseCase
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

  void loadNotificationLoadDataResult() async {
    _notificationLoadDataResult = IsLoadingLoadDataResult<int>();
    notifyListeners();
    _notificationLoadDataResult = await getNotificationByUserListUseCase.execute(
      NotificationByUserListParameter()
    ).future(
      parameter: apiRequestManager.addRequestToCancellationPart("notification").value
    ).map<int>(
      (getUserResponse) => getUserResponse.length
    );
    notifyListeners();
  }

  void loadInboxLoadDataResult() async {
    _inboxLoadDataResult = SuccessLoadDataResult<int>(
      value: 0
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