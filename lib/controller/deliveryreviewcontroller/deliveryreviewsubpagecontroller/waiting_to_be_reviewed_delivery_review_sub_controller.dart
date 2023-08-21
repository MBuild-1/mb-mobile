import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../../../domain/entity/componententity/dynamic_item_carousel_directly_component_entity.dart';
import '../../../domain/entity/componententity/i_component_entity.dart';
import '../../../domain/entity/delivery/delivery_review.dart';
import '../../../domain/entity/delivery/delivery_review_paging_parameter.dart';
import '../../../domain/entity/order/combined_order.dart';
import '../../../domain/entity/order/order_paging_parameter.dart';
import '../../../domain/entity/user/getuser/get_user_parameter.dart';
import '../../../domain/entity/user/user.dart';
import '../../../domain/usecase/get_order_paging_use_case.dart';
import '../../../domain/usecase/get_user_use_case.dart';
import '../../../domain/usecase/get_waiting_to_be_reviewed_delivery_review_paging_use_case.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../../misc/error/message_error.dart';
import '../../../misc/getextended/get_extended.dart';
import '../../../misc/load_data_result.dart';
import '../../../misc/manager/controller_manager.dart';
import '../../../misc/multi_language_string.dart';
import '../../../misc/paging/pagingresult/paging_data_result.dart';
import '../../base_getx_controller.dart';

class WaitingToBeReviewedDeliveryReviewSubController extends BaseGetxController {
  final GetWaitingToBeReviewedDeliveryReviewPagingUseCase getWaitingToBeReviewedDeliveryReviewPagingUseCase;
  final GetUserUseCase getUserUseCase;
  final GetOrderPagingUseCase getOrderPagingUseCase;
  WaitingToBeReviewedDeliveryReviewSubDelegate? _waitingToBeReviewedDeliveryReviewSubDelegate;

  WaitingToBeReviewedDeliveryReviewSubController(
    super.controllerManager,
    this.getWaitingToBeReviewedDeliveryReviewPagingUseCase,
    this.getUserUseCase,
    this.getOrderPagingUseCase,
  );

  Future<LoadDataResult<PagingDataResult<CombinedOrder>>> getOrderPaging(OrderPagingParameter orderPagingParameter) {
    return getOrderPagingUseCase.execute(orderPagingParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("cart").value
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
  final GetOrderPagingUseCase getOrderPagingUseCase;

  WaitingToBeReviewedDeliveryReviewSubControllerInjectionFactory({
    required this.getWaitingToBeReviewedDeliveryReviewPagingUseCase,
    required this.getUserUseCase,
    required this.getOrderPagingUseCase,
  });

  WaitingToBeReviewedDeliveryReviewSubController inject(ControllerManager controllerManager, String pageName) {
    return GetExtended.put<WaitingToBeReviewedDeliveryReviewSubController>(
      WaitingToBeReviewedDeliveryReviewSubController(
        controllerManager,
        getWaitingToBeReviewedDeliveryReviewPagingUseCase,
        getUserUseCase,
        getOrderPagingUseCase
      ),
      tag: pageName
    );
  }
}

class WaitingToBeReviewedDeliveryReviewSubDelegate {}