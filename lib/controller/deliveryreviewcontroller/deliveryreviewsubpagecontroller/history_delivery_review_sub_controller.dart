import '../../../domain/entity/delivery/delivery_review.dart';
import '../../../domain/entity/delivery/delivery_review_list_parameter.dart';
import '../../../domain/entity/delivery/delivery_review_paging_parameter.dart';
import '../../../domain/usecase/get_history_delivery_review_list_use_case.dart';
import '../../../misc/getextended/get_extended.dart';
import '../../../misc/load_data_result.dart';
import '../../../misc/manager/controller_manager.dart';
import '../../../misc/paging/pagingresult/paging_data_result.dart';
import '../../base_getx_controller.dart';

class HistoryDeliveryReviewSubController extends BaseGetxController {
  final GetHistoryDeliveryReviewListUseCase getHistoryDeliveryReviewListUseCase;

  HistoryDeliveryReviewSubController(
    super.controllerManager,
    this.getHistoryDeliveryReviewListUseCase
  );

  Future<LoadDataResult<List<DeliveryReview>>> getHistoryDeliveryReviewList(DeliveryReviewListParameter deliveryReviewListParameter) {
    return getHistoryDeliveryReviewListUseCase.execute(deliveryReviewListParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("history-delivery-review").value
    );
  }
}

class HistoryDeliveryReviewSubControllerInjectionFactory {
  final GetHistoryDeliveryReviewListUseCase getHistoryDeliveryReviewListUseCase;

  HistoryDeliveryReviewSubControllerInjectionFactory({
    required this.getHistoryDeliveryReviewListUseCase
  });

  HistoryDeliveryReviewSubController inject(ControllerManager controllerManager, String pageName) {
    return GetExtended.put<HistoryDeliveryReviewSubController>(
      HistoryDeliveryReviewSubController(
        controllerManager,
        getHistoryDeliveryReviewListUseCase
      ),
      tag: pageName
    );
  }
}