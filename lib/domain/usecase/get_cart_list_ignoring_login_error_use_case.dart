import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/cart/cart.dart';
import '../entity/cart/cart_list_parameter.dart';
import '../repository/cart_repository.dart';

class GetCartListIgnoringLoginErrorUseCase {
  final CartRepository cartRepository;

  const GetCartListIgnoringLoginErrorUseCase({
    required this.cartRepository
  });

  FutureProcessing<LoadDataResult<List<Cart>>> execute(CartListParameter cartListParameter) {
    return cartRepository.cartListIgnoringLoginError(cartListParameter);
  }
}