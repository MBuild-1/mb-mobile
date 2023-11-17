import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/wishlist/wishlist.dart';
import '../entity/wishlist/wishlist_list_parameter.dart';
import '../repository/product_repository.dart';

class GetWishlistListUseCase {
  final ProductRepository productRepository;

  const GetWishlistListUseCase({
    required this.productRepository
  });

  FutureProcessing<LoadDataResult<List<Wishlist>>> execute(WishlistListParameter wishlistListParameter) {
    return productRepository.wishlistList(wishlistListParameter);
  }
}