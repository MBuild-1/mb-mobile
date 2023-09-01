import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/cart/cart.dart';
import '../entity/cart/cart_list_parameter.dart';
import '../repository/cart_repository.dart';

class GetCartListUseCase {
  final CartRepository cartRepository;

  const GetCartListUseCase({
    required this.cartRepository
  });

  FutureProcessing<LoadDataResult<List<Cart>>> execute(CartListParameter cartListParameter) {
    return cartRepository.cartList(cartListParameter);
  }
}