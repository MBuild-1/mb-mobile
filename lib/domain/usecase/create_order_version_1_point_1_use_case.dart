import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/order/create_order_parameter.dart';
import '../entity/order/createorderversion1point1/create_order_version_1_point_1_parameter.dart';
import '../entity/order/createorderversion1point1/create_order_version_1_point_1_response.dart';
import '../entity/order/order.dart';
import '../repository/order_repository.dart';

class CreateOrderVersion1Point1UseCase {
  final OrderRepository orderRepository;

  const CreateOrderVersion1Point1UseCase({
    required this.orderRepository
  });

  FutureProcessing<LoadDataResult<CreateOrderVersion1Point1Response>> execute(CreateOrderVersion1Point1Parameter createOrderVersion1Point1Parameter) {
    return orderRepository.createOrderVersion1Point1(createOrderVersion1Point1Parameter);
  }
}