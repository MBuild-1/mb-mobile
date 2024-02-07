import '../../misc/load_data_result.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/product/productbrand/product_brand.dart';
import '../entity/product/productbrand/product_brand_paging_parameter.dart';
import '../repository/product_repository.dart';

class GetSelectedBeautyBrandsPagingUseCase {
  final ProductRepository productRepository;

  const GetSelectedBeautyBrandsPagingUseCase({
    required this.productRepository
  });

  FutureProcessing<LoadDataResult<PagingDataResult<ProductBrand>>> execute(ProductBrandPagingParameter productBrandPagingParameter) {
    return productRepository.selectedBeautyProductBrandPaging(productBrandPagingParameter);
  }
}