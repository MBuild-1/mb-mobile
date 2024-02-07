import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/order/modifywarehouseinorder/modifywarehouseinorderparameter/modify_warehouse_in_order_parameter.dart';
import '../entity/order/modifywarehouseinorder/modifywarehouseinorderresponse/modify_warehouse_in_order_response.dart';
import '../repository/order_repository.dart';

class ModifyWarehouseInOrderUseCase {
  final OrderRepository orderRepository;

  ModifyWarehouseInOrderUseCase({
    required this.orderRepository
  });

  FutureProcessing<LoadDataResult<ModifyWarehouseInOrderResponse>> execute(ModifyWarehouseInOrderParameter modifyWarehouseInOrderParameter) {
    return orderRepository.modifyWarehouseInOrder(modifyWarehouseInOrderParameter);
  }
}