import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/product/productdiscussion/create_product_discussion_parameter.dart';
import '../entity/product/productdiscussion/create_product_discussion_response.dart';
import '../entity/product/productdiscussion/product_discussion.dart';
import '../entity/product/productdiscussion/product_discussion_based_user_parameter.dart';
import '../entity/product/productdiscussion/product_discussion_list_parameter.dart';
import '../entity/product/productdiscussion/reply_product_discussion_parameter.dart';
import '../entity/product/productdiscussion/reply_product_discussion_response.dart';

abstract class ProductDiscussionRepository {
  FutureProcessing<LoadDataResult<ProductDiscussion>> productDiscussionBasedUser(ProductDiscussionBasedUserParameter productDiscussionBasedUserParameter);
  FutureProcessing<LoadDataResult<ProductDiscussion>> productDiscussion(ProductDiscussionParameter productDiscussionParameter);
  FutureProcessing<LoadDataResult<CreateProductDiscussionResponse>> createProductDiscussion(CreateProductDiscussionParameter createProductDiscussionParameter);
  FutureProcessing<LoadDataResult<ReplyProductDiscussionResponse>> replyProductDiscussion(ReplyProductDiscussionParameter replyProductDiscussionParameter);
}