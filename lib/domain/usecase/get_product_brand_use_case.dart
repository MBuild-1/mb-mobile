import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/product/productbrand/product_brand.dart';
import '../entity/product/productbrand/product_brand_list_parameter.dart';
import '../repository/product_repository.dart';

class GetProductBrandListUseCase {
  final ProductRepository productRepository;

  const GetProductBrandListUseCase({
    required this.productRepository
  });

  FutureProcessing<LoadDataResult<List<ProductBrand>>> execute(ProductBrandListParameter productBrandListParameter) {
    return productRepository.productBrandList(productBrandListParameter);
  }
}