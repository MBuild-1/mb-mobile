import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/cart/update_cart_quantity_parameter.dart';
import '../entity/cart/update_cart_quantity_response.dart';
import '../repository/cart_repository.dart';

class UpdateCartQuantityUseCase {
  final CartRepository cartRepository;

  const UpdateCartQuantityUseCase({
    required this.cartRepository
  });

  FutureProcessing<LoadDataResult<UpdateCartQuantityResponse>> execute(UpdateCartQuantityParameter updateCartQuantityParameter) {
    return cartRepository.updateCartQuantity(updateCartQuantityParameter);
  }
}