import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/product/productbundle/product_bundle_detail.dart';
import '../entity/product/productbundle/product_bundle_detail_by_slug_parameter.dart';
import '../repository/product_repository.dart';

class GetProductBundleDetailBySlugUseCase {
  final ProductRepository productRepository;

  const GetProductBundleDetailBySlugUseCase({
    required this.productRepository
  });

  FutureProcessing<LoadDataResult<ProductBundleDetail>> execute(ProductBundleDetailBySlugParameter productBundleDetailBySlugParameter) {
    return productRepository.productBundleDetailBySlug(productBundleDetailBySlugParameter);
  }
}