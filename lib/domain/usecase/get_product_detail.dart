import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/product.dart';
import '../entity/product_detail_parameter.dart';
import '../repository/product_repository.dart';

class GetProductDetail {
  final ProductRepository productRepository;

  const GetProductDetail({
    required this.productRepository
  });

  FutureProcessing<LoadDataResult<Product>> execute(ProductDetailParameter productDetailParameter) {
    return productRepository.productDetail(productDetailParameter);
  }
}