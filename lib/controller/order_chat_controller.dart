import '../domain/entity/chat/order/answer_order_conversation_parameter.dart';
import '../domain/entity/chat/order/answer_order_conversation_response.dart';
import '../domain/entity/chat/order/answer_order_conversation_version_1_point_1_parameter.dart';
import '../domain/entity/chat/order/answer_order_conversation_version_1_point_1_response.dart';
import '../domain/entity/chat/order/create_order_conversation_parameter.dart';
import '../domain/entity/chat/order/create_order_conversation_response.dart';
import '../domain/entity/chat/order/get_order_message_by_combined_order_parameter.dart';
import '../domain/entity/chat/order/get_order_message_by_combined_order_response.dart';
import '../domain/entity/chat/order/get_order_message_by_user_parameter.dart';
import '../domain/entity/chat/order/get_order_message_by_user_response.dart';
import '../domain/entity/order/order.dart';
import '../domain/entity/order/order_based_id_parameter.dart';
import '../domain/entity/user/getuser/get_user_parameter.dart';
import '../domain/entity/user/getuser/get_user_response.dart';
import '../domain/usecase/answer_order_conversation_use_case.dart';
import '../domain/usecase/answer_order_conversation_version_1_point_1_use_case.dart';
import '../domain/usecase/create_order_conversation_use_case.dart';
import '../domain/usecase/get_order_based_id_use_case.dart';
import '../domain/usecase/get_order_message_by_combined_order_use_case.dart';
import '../domain/usecase/get_order_message_by_user_use_case.dart';
import '../domain/usecase/get_user_use_case.dart';
import '../misc/load_data_result.dart';
import 'base_getx_controller.dart';

class OrderChatController extends BaseGetxController {
  final GetOrderMessageByUserUseCase getOrderMessageByUserUseCase;
  final GetOrderMessageByCombinedOrderUseCase getOrderMessageByCombinedOrderUseCase;
  final CreateOrderConversationUseCase createOrderConversationUseCase;
  final AnswerOrderConversationUseCase answerOrderConversationUseCase;
  final AnswerOrderConversationVersion1Point1UseCase answerOrderConversationVersion1Point1UseCase;
  final GetUserUseCase getUserUseCase;
  final GetOrderBasedIdUseCase getOrderBasedIdUseCase;

  OrderChatController(
    super.controllerManager,
    this.getOrderMessageByUserUseCase,
    this.getOrderMessageByCombinedOrderUseCase,
    this.createOrderConversationUseCase,
    this.answerOrderConversationUseCase,
    this.answerOrderConversationVersion1Point1UseCase,
    this.getUserUseCase,
    this.getOrderBasedIdUseCase
  );

  Future<LoadDataResult<GetOrderMessageByUserResponse>> getOrderMessageByUser(GetOrderMessageByUserParameter getOrderMessageByUserParameter) {
    return getOrderMessageByUserUseCase.execute(getOrderMessageByUserParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("order-message-by-user", duplicate: true).value
    );
  }

  Future<LoadDataResult<GetOrderMessageByCombinedOrderResponse>> getOrderMessageByCombinedOrder(GetOrderMessageByCombinedOrderParameter getOrderMessageByCombinedOrderParameter) {
    return getOrderMessageByCombinedOrderUseCase.execute(getOrderMessageByCombinedOrderParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("order-message-by-combined-order", duplicate: true).value
    );
  }

  Future<LoadDataResult<CreateOrderConversationResponse>> createOrderConversation(CreateOrderConversationParameter createOrderConversationParameter) {
    return createOrderConversationUseCase.execute(createOrderConversationParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("create-order-conversation", duplicate: true).value
    );
  }

  Future<LoadDataResult<AnswerOrderConversationResponse>> answerOrderConversation(AnswerOrderConversationParameter answerOrderConversationParameter) {
    return answerOrderConversationUseCase.execute(answerOrderConversationParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("answer-order-conversation", duplicate: true).value
    );
  }

  Future<LoadDataResult<AnswerOrderConversationVersion1Point1Response>> answerOrderConversationVersion1Point1(AnswerOrderConversationVersion1Point1Parameter answerOrderConversationVersion1Point1Parameter) {
    return answerOrderConversationVersion1Point1UseCase.execute(answerOrderConversationVersion1Point1Parameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("answer-order-conversation-version-1-point-1", duplicate: true).value
    );
  }

  Future<LoadDataResult<GetUserResponse>> getUser(GetUserParameter getUserParameter) {
    return getUserUseCase.execute(getUserParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("get-user", duplicate: true).value
    );
  }

  Future<LoadDataResult<Order>> getOrderBasedId(OrderBasedIdParameter orderBasedIdParameter) {
    return getOrderBasedIdUseCase.execute(orderBasedIdParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("get-order-based-id").value
    );
  }
}