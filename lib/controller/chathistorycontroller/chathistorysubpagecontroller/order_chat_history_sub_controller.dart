import '../../../domain/entity/chat/order/get_order_message_by_user_parameter.dart';
import '../../../domain/entity/chat/order/get_order_message_by_user_response.dart';
import '../../../domain/usecase/get_order_message_by_user_use_case.dart';
import '../../../misc/getextended/get_extended.dart';
import '../../../misc/load_data_result.dart';
import '../../../misc/manager/controller_manager.dart';
import '../../base_getx_controller.dart';

class OrderChatHistorySubController extends BaseGetxController {
  final GetOrderMessageByUserUseCase getOrderMessageByUserUseCase;

  OrderChatHistorySubController(
    super.controllerManager,
    this.getOrderMessageByUserUseCase
  );

  Future<LoadDataResult<GetOrderMessageByUserResponse>> getOrderMessageByUserResponse(GetOrderMessageByUserParameter getOrderMessageByUserParameter) {
    return getOrderMessageByUserUseCase.execute(getOrderMessageByUserParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("order-chat-history").value
    );
  }
}

class OrderChatHistorySubControllerInjectionFactory {
  final GetOrderMessageByUserUseCase getOrderMessageByUserUseCase;

  OrderChatHistorySubControllerInjectionFactory({
    required this.getOrderMessageByUserUseCase
  });

  OrderChatHistorySubController inject(ControllerManager controllerManager, String pageName) {
    return GetExtended.put<OrderChatHistorySubController>(
      OrderChatHistorySubController(
        controllerManager,
        getOrderMessageByUserUseCase
      ),
      tag: pageName
    );
  }
}