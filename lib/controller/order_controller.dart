import '../domain/entity/order/combined_order.dart';
import '../domain/entity/order/order_paging_parameter.dart';
import '../domain/usecase/get_order_paging_use_case.dart';
import '../misc/controllercontentdelegate/repurchase_controller_content_delegate.dart';
import '../misc/load_data_result.dart';
import '../misc/paging/pagingresult/paging_data_result.dart';
import 'base_getx_controller.dart';

class OrderController extends BaseGetxController {
  final GetOrderPagingUseCase getOrderPagingUseCase;
  final RepurchaseControllerContentDelegate repurchaseControllerContentDelegate;

  OrderController(
    super.controllerManager,
    this.getOrderPagingUseCase,
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
}