import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/product/productcategory/product_category.dart';
import '../entity/product/productcategory/product_category_list_parameter.dart';
import '../repository/product_repository.dart';

class GetProductCategoryListUseCase {
  final ProductRepository productRepository;

  const GetProductCategoryListUseCase({
    required this.productRepository
  });

  FutureProcessing<LoadDataResult<List<ProductCategory>>> execute(ProductCategoryListParameter productCategoryListParameter) {
    return productRepository.productCategoryList(productCategoryListParameter);
  }
}