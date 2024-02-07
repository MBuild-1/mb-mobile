import '../../misc/load_data_result.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/product/productcategory/product_category.dart';
import '../entity/product/productcategory/product_category_paging_parameter.dart';
import '../repository/product_repository.dart';

class GetProductCategoryPagingUseCase {
  final ProductRepository productRepository;

  const GetProductCategoryPagingUseCase({
    required this.productRepository
  });

  FutureProcessing<LoadDataResult<PagingDataResult<ProductCategory>>> execute(ProductCategoryPagingParameter productCategoryPagingParameter) {
    return productRepository.productCategoryPaging(productCategoryPagingParameter);
  }
}