import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../domain/entity/order/arrived_order_request.dart';
import '../domain/entity/order/arrived_order_response.dart';
import '../domain/entity/order/combined_order.dart';
import '../domain/entity/order/order_paging_parameter.dart';
import '../domain/usecase/arrived_order_use_case.dart';
import '../domain/usecase/get_order_paging_use_case.dart';
import '../misc/controllercontentdelegate/repurchase_controller_content_delegate.dart';
import '../misc/load_data_result.dart';
import '../misc/paging/pagingresult/paging_data_result.dart';
import '../misc/typedef.dart';
import 'base_getx_controller.dart';

typedef _OnShowArrivedOrderProcessLoadingCallback = Future<void> Function();
typedef _OnArrivedOrderProcessSuccessCallback = Future<void> Function(ArrivedOrderResponse);
typedef _OnShowArrivedOrderProcessFailedCallback = Future<void> Function(dynamic e);

class OrderController extends BaseGetxController {
  final GetOrderPagingUseCase getOrderPagingUseCase;
  final ArrivedOrderUseCase arrivedOrderUseCase;
  final RepurchaseControllerContentDelegate repurchaseControllerContentDelegate;
  OrderDelegate? _orderDelegate;

  OrderController(
    super.controllerManager,
    this.getOrderPagingUseCase,
    this.arrivedOrderUseCase,
    this.repurchaseControllerContentDelegate
  ) {
    repurchaseControllerContentDelegate.setApiRequestManager(
      () => apiRequestManager
    );
  }

  Future<LoadDataResult<PagingDataResult<CombinedOrder>>> getOrderPaging(OrderPagingParameter orderPagingParameter) {
    return getOrderPagingUseCase.execute(orderPagingParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("cart").value
    );
  }

  void arrivedOrder(ArrivedOrderParameter arrivedOrderParameter) async {
    if (_orderDelegate != null) {
      _orderDelegate!.onUnfocusAllWidget();
      _orderDelegate!.onShowArrivedOrderProcessLoadingCallback();
      LoadDataResult<ArrivedOrderResponse> arrivedOrderResponseLoadDataResult = await arrivedOrderUseCase.execute(
        arrivedOrderParameter
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart("arrived-order").value
      );
      _orderDelegate!.onBack();
      if (arrivedOrderResponseLoadDataResult.isSuccess) {
        _orderDelegate!.onArrivedOrderProcessSuccessCallback(arrivedOrderResponseLoadDataResult.resultIfSuccess!);
      } else {
        _orderDelegate!.onShowArrivedOrderProcessFailedCallback(arrivedOrderResponseLoadDataResult.resultIfFailed);
      }
    }
  }

  OrderController setOrderDelegate(OrderDelegate orderDelegate) {
    _orderDelegate = orderDelegate;
    return this;
  }
}

class OrderDelegate {
  OnBack onBack;
  OnUnfocusAllWidget onUnfocusAllWidget;
  _OnShowArrivedOrderProcessLoadingCallback onShowArrivedOrderProcessLoadingCallback;
  _OnArrivedOrderProcessSuccessCallback onArrivedOrderProcessSuccessCallback;
  _OnShowArrivedOrderProcessFailedCallback onShowArrivedOrderProcessFailedCallback;

  OrderDelegate({
    required this.onBack,
    required this.onUnfocusAllWidget,
    required this.onShowArrivedOrderProcessLoadingCallback,
    required this.onArrivedOrderProcessSuccessCallback,
    required this.onShowArrivedOrderProcessFailedCallback,
  });
}