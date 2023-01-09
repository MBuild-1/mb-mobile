import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/product.dart';
import '../entity/product_list_parameter.dart';
import '../repository/product_repository.dart';

class GetProductList {
  final ProductRepository productRepository;

  const GetProductList({
    required this.productRepository
  });

  FutureProcessing<LoadDataResult<List<Product>>> execute(ProductListParameter productListParameter) {
    return productRepository.productList(productListParameter);
  }
}