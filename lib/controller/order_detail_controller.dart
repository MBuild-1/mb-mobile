import '../domain/entity/order/order.dart';
import '../domain/entity/order/order_based_id_parameter.dart';
import '../domain/usecase/get_order_based_id_use_case.dart';
import '../misc/controllercontentdelegate/repurchase_controller_content_delegate.dart';
import '../misc/load_data_result.dart';
import 'base_getx_controller.dart';

class OrderDetailController extends BaseGetxController {
  final GetOrderBasedIdUseCase getOrderBasedIdUseCase;
  final RepurchaseControllerContentDelegate repurchaseControllerContentDelegate;

  OrderDetailController(
    super.controllerManager,
    this.getOrderBasedIdUseCase,
    this.repurchaseControllerContentDelegate
  ) {
    repurchaseControllerContentDelegate.setApiRequestManager(
      () => apiRequestManager
    );
  }

  Future<LoadDataResult<Order>> getOrderBasedId(OrderBasedIdParameter orderBasedIdParameter) {
    return getOrderBasedIdUseCase.execute(orderBasedIdParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("order-detail").value
    );
  }
}