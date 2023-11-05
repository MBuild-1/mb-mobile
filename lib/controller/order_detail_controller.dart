import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../domain/entity/order/modifywarehouseinorder/modifywarehouseinorderparameter/add_warehouse_in_order_parameter.dart';
import '../domain/entity/order/modifywarehouseinorder/modifywarehouseinorderparameter/modify_warehouse_in_order_parameter.dart';
import '../domain/entity/order/modifywarehouseinorder/modifywarehouseinorderresponse/add_warehouse_in_order_response.dart';
import '../domain/entity/order/modifywarehouseinorder/modifywarehouseinorderresponse/modify_warehouse_in_order_response.dart';
import '../domain/entity/order/order.dart';
import '../domain/entity/order/order_based_id_parameter.dart';
import '../domain/usecase/add_warehouse_in_order_use_case.dart';
import '../domain/usecase/get_order_based_id_use_case.dart';
import '../misc/controllercontentdelegate/repurchase_controller_content_delegate.dart';
import '../misc/load_data_result.dart';
import '../misc/typedef.dart';
import 'base_getx_controller.dart';

typedef _OnOrderDetailBack = void Function();
typedef _OnShowModifyWarehouseInOrderRequestProcessLoadingCallback = Future<void> Function();
typedef _OnModifyWarehouseInOrderRequestProcessSuccessCallback = Future<void> Function(ModifyWarehouseInOrderResponse);
typedef _OnShowModifyWarehouseInOrderRequestProcessFailedCallback = Future<void> Function(dynamic e);

class OrderDetailController extends BaseGetxController {
  final GetOrderBasedIdUseCase getOrderBasedIdUseCase;
  final ModifyWarehouseInOrderUseCase modifyWarehouseInOrderUseCase;
  final RepurchaseControllerContentDelegate repurchaseControllerContentDelegate;
  OrderDetailDelegate? _orderDetailDelegate;

  OrderDetailController(
    super.controllerManager,
    this.getOrderBasedIdUseCase,
    this.modifyWarehouseInOrderUseCase,
    this.repurchaseControllerContentDelegate
  ) {
    repurchaseControllerContentDelegate.setApiRequestManager(
      () => apiRequestManager
    );
  }

  void modifyWarehouseInOrder(ModifyWarehouseInOrderParameter modifyWarehouseInOrderParameter) async {
    if (_orderDetailDelegate != null) {
      _orderDetailDelegate!.onShowModifyWarehouseInOrderRequestProcessLoadingCallback();
      LoadDataResult<ModifyWarehouseInOrderResponse> modifyWarehouseInOrderResponseLoadDataResult = await modifyWarehouseInOrderUseCase.execute(
        modifyWarehouseInOrderParameter
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart("modify-warehouse-in-order").value
      );
      if (modifyWarehouseInOrderResponseLoadDataResult.isFailedBecauseCancellation) {
        return;
      }
      _orderDetailDelegate!.onOrderDetailBack();
      if (modifyWarehouseInOrderResponseLoadDataResult.isSuccess) {
        _orderDetailDelegate!.onModifyWarehouseInOrderRequestProcessSuccessCallback(modifyWarehouseInOrderResponseLoadDataResult.resultIfSuccess!);
      } else {
        _orderDetailDelegate!.onShowModifyWarehouseInOrderRequestProcessFailedCallback(modifyWarehouseInOrderResponseLoadDataResult.resultIfFailed);
      }
    }
  }

  Future<LoadDataResult<Order>> getOrderBasedId(OrderBasedIdParameter orderBasedIdParameter) {
    return getOrderBasedIdUseCase.execute(orderBasedIdParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("order-detail").value
    );
  }

  OrderDetailController setOrderDetailDelegate(OrderDetailDelegate orderDetailDelegate) {
    _orderDetailDelegate = orderDetailDelegate;
    return this;
  }
}

class OrderDetailDelegate {
  OnUnfocusAllWidget onUnfocusAllWidget;
  _OnOrderDetailBack onOrderDetailBack;
  _OnShowModifyWarehouseInOrderRequestProcessLoadingCallback onShowModifyWarehouseInOrderRequestProcessLoadingCallback;
  _OnModifyWarehouseInOrderRequestProcessSuccessCallback onModifyWarehouseInOrderRequestProcessSuccessCallback;
  _OnShowModifyWarehouseInOrderRequestProcessFailedCallback onShowModifyWarehouseInOrderRequestProcessFailedCallback;

  OrderDetailDelegate({
    required this.onUnfocusAllWidget,
    required this.onOrderDetailBack,
    required this.onShowModifyWarehouseInOrderRequestProcessLoadingCallback,
    required this.onModifyWarehouseInOrderRequestProcessSuccessCallback,
    required this.onShowModifyWarehouseInOrderRequestProcessFailedCallback,
  });
}