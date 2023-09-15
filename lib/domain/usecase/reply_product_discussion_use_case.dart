import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/product/productdiscussion/reply_product_discussion_parameter.dart';
import '../entity/product/productdiscussion/reply_product_discussion_response.dart';
import '../repository/product_discussion_repository.dart';

class ReplyProductDiscussionUseCase {
  final ProductDiscussionRepository productDiscussionRepository;

  const ReplyProductDiscussionUseCase({
    required this.productDiscussionRepository
  });

  FutureProcessing<LoadDataResult<ReplyProductDiscussionResponse>> execute(ReplyProductDiscussionParameter replyProductDiscussionParameter) {
    return productDiscussionRepository.replyProductDiscussion(replyProductDiscussionParameter);
  }
}