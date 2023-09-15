import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/product/productdiscussion/product_discussion.dart';
import '../entity/product/productdiscussion/product_discussion_list_parameter.dart';
import '../repository/product_discussion_repository.dart';

class GetProductDiscussionUseCase {
  final ProductDiscussionRepository productDiscussionRepository;

  const GetProductDiscussionUseCase({
    required this.productDiscussionRepository
  });

  FutureProcessing<LoadDataResult<ProductDiscussion>> execute(ProductDiscussionParameter productDiscussionParameter) {
    return productDiscussionRepository.productDiscussion(productDiscussionParameter);
  }
}