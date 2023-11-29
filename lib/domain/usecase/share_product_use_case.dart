import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/product/shareproduct/share_product_parameter.dart';
import '../entity/product/shareproduct/share_product_response.dart';
import '../repository/product_repository.dart';

class ShareProductUseCase {
  final ProductRepository productRepository;

  const ShareProductUseCase({
    required this.productRepository
  });

  FutureProcessing<LoadDataResult<ShareProductResponse>> execute(ShareProductParameter shareProductParameter) {
    return productRepository.shareProduct(shareProductParameter);
  }
}