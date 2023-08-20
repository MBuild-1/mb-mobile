import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/product/productbrand/favorite_product_brand.dart';
import '../entity/product/productbrand/favorite_product_brand_list_parameter.dart';
import '../repository/product_repository.dart';

class GetFavoriteProductBrandListUseCase {
  final ProductRepository productRepository;

  const GetFavoriteProductBrandListUseCase({
    required this.productRepository
  });

  FutureProcessing<LoadDataResult<List<FavoriteProductBrand>>> execute(FavoriteProductBrandListParameter favoriteProductBrandListParameter) {
    return productRepository.favoriteProductBrandList(favoriteProductBrandListParameter);
  }
}