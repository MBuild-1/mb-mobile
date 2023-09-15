import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/product/productdiscussion/create_product_discussion_parameter.dart';
import '../entity/product/productdiscussion/create_product_discussion_response.dart';
import '../repository/product_discussion_repository.dart';

class CreateProductDiscussionUseCase {
  final ProductDiscussionRepository productDiscussionRepository;

  const CreateProductDiscussionUseCase({
    required this.productDiscussionRepository
  });

  FutureProcessing<LoadDataResult<CreateProductDiscussionResponse>> execute(CreateProductDiscussionParameter createProductDiscussionParameter) {
    return productDiscussionRepository.createProductDiscussion(createProductDiscussionParameter);
  }
}