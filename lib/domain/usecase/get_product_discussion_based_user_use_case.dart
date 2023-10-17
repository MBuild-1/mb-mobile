import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/product/productdiscussion/product_discussion.dart';
import '../entity/product/productdiscussion/product_discussion_based_user_parameter.dart';
import '../entity/product/productdiscussion/product_discussion_list_parameter.dart';
import '../repository/product_discussion_repository.dart';

class GetProductDiscussionBasedUserUseCase {
  final ProductDiscussionRepository productDiscussionRepository;

  const GetProductDiscussionBasedUserUseCase({
    required this.productDiscussionRepository
  });

  FutureProcessing<LoadDataResult<ProductDiscussion>> execute(ProductDiscussionBasedUserParameter productDiscussionBasedUserParameter) {
    return productDiscussionRepository.productDiscussionBasedUser(productDiscussionBasedUserParameter);
  }
}