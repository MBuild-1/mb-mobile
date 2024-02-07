import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/product/product.dart';
import '../entity/product/product_detail.dart';
import '../entity/product/product_detail_by_slug_parameter.dart';
import '../entity/product/product_detail_parameter.dart';
import '../repository/product_repository.dart';

class GetProductDetailBySlugUseCase {
  final ProductRepository productRepository;

  const GetProductDetailBySlugUseCase({
    required this.productRepository
  });

  FutureProcessing<LoadDataResult<ProductDetail>> execute(ProductDetailBySlugParameter productDetailBySlugParameter) {
    return productRepository.productDetailBySlug(productDetailBySlugParameter);
  }
}