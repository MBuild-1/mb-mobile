import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/chat/order/get_order_message_by_combined_order_parameter.dart';
import '../entity/chat/order/get_order_message_by_combined_order_response.dart';
import '../repository/chat_repository.dart';

class GetOrderMessageByCombinedOrderUseCase {
  final ChatRepository chatRepository;

  const GetOrderMessageByCombinedOrderUseCase({
    required this.chatRepository
  });

  FutureProcessing<LoadDataResult<GetOrderMessageByCombinedOrderResponse>> execute(GetOrderMessageByCombinedOrderParameter getOrderMessageByCombinedOrderParameter) {
    return chatRepository.getOrderMessageByCombinedOrder(getOrderMessageByCombinedOrderParameter);
  }
}