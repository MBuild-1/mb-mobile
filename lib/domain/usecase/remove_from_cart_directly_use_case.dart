import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/cart/remove_from_cart_directly_parameter.dart';
import '../entity/cart/remove_from_cart_directly_response.dart';
import '../repository/cart_repository.dart';

class RemoveFromCartDirectlyUseCase {
  final CartRepository cartRepository;

  const RemoveFromCartDirectlyUseCase({
    required this.cartRepository
  });

  FutureProcessing<LoadDataResult<RemoveFromCartDirectlyResponse>> execute(RemoveFromCartDirectlyParameter removeFromCartDirectlyParameter) {
    return cartRepository.removeFromCartDirectly(removeFromCartDirectlyParameter);
  }
}