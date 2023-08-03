import '../domain/entity/chat/order/get_order_message_by_user_parameter.dart';
import '../domain/entity/chat/order/get_order_message_by_user_response.dart';
import '../domain/usecase/get_order_message_by_user_use_case.dart';
import '../misc/load_data_result.dart';
import 'base_getx_controller.dart';

class OrderChatController extends BaseGetxController {
  final GetOrderMessageByUserUseCase getOrderMessageByUserUseCase;

  OrderChatController(
    super.controllerManager,
    this.getOrderMessageByUserUseCase
  );

  Future<LoadDataResult<GetOrderMessageByUserResponse>> getOrderMessageByUser(GetOrderMessageByUserParameter getOrderMessageByUserParameter) {
    return getOrderMessageByUserUseCase.execute(getOrderMessageByUserParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("order-message-by-user").value
    );
  }
}