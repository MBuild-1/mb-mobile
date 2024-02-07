import '../../../domain/entity/order/combined_order.dart';
import '../../../domain/entity/order/shipping_review_order_list_parameter.dart';
import '../../../domain/usecase/get_shipping_review_order_list_use_case.dart';
import '../../../domain/usecase/get_user_use_case.dart';
import '../../../domain/usecase/get_waiting_to_be_reviewed_delivery_review_paging_use_case.dart';
import '../../../misc/getextended/get_extended.dart';
import '../../../misc/load_data_result.dart';
import '../../../misc/manager/controller_manager.dart';
import '../../base_getx_controller.dart';

class WaitingToBeReviewedDeliveryReviewSubController extends BaseGetxController {
  final GetWaitingToBeReviewedDeliveryReviewPagingUseCase getWaitingToBeReviewedDeliveryReviewPagingUseCase;
  final GetUserUseCase getUserUseCase;
  final GetShippingReviewOrderListUseCase getShippingReviewOrderListUseCase;
  WaitingToBeReviewedDeliveryReviewSubDelegate? _waitingToBeReviewedDeliveryReviewSubDelegate;

  WaitingToBeReviewedDeliveryReviewSubController(
    super.controllerManager,
    this.getWaitingToBeReviewedDeliveryReviewPagingUseCase,
    this.getUserUseCase,
    this.getShippingReviewOrderListUseCase,
  );

  Future<LoadDataResult<List<CombinedOrder>>> getShippingReviewOrderList(ShippingReviewOrderListParameter shippingReviewOrderListParameter) {
    return getShippingReviewOrderListUseCase.execute(shippingReviewOrderListParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("shipping-review-order").value
    );
  }

  WaitingToBeReviewedDeliveryReviewSubController setWaitingToBeReviewedDeliveryReviewSubDelegate(WaitingToBeReviewedDeliveryReviewSubDelegate? waitingToBeReviewedDeliveryReviewSubDelegate) {
    _waitingToBeReviewedDeliveryReviewSubDelegate = waitingToBeReviewedDeliveryReviewSubDelegate;
    return this;
  }
}

class WaitingToBeReviewedDeliveryReviewSubControllerInjectionFactory {
  final GetWaitingToBeReviewedDeliveryReviewPagingUseCase getWaitingToBeReviewedDeliveryReviewPagingUseCase;
  final GetUserUseCase getUserUseCase;
  final GetShippingReviewOrderListUseCase getShippingReviewOrderListUseCase;

  WaitingToBeReviewedDeliveryReviewSubControllerInjectionFactory({
    required this.getWaitingToBeReviewedDeliveryReviewPagingUseCase,
    required this.getUserUseCase,
    required this.getShippingReviewOrderListUseCase,
  });

  WaitingToBeReviewedDeliveryReviewSubController inject(ControllerManager controllerManager, String pageName) {
    return GetExtended.put<WaitingToBeReviewedDeliveryReviewSubController>(
      WaitingToBeReviewedDeliveryReviewSubController(
        controllerManager,
        getWaitingToBeReviewedDeliveryReviewPagingUseCase,
        getUserUseCase,
        getShippingReviewOrderListUseCase
      ),
      tag: pageName
    );
  }
}

class WaitingToBeReviewedDeliveryReviewSubDelegate {}