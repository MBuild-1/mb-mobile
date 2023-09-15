import '../../../domain/entity/product/productdiscussion/create_product_discussion_parameter.dart';
import '../../../domain/entity/product/productdiscussion/create_product_discussion_response.dart';
import '../../../domain/entity/product/productdiscussion/product_discussion.dart';
import '../../../domain/entity/product/productdiscussion/product_discussion_list_parameter.dart';
import '../../../domain/entity/product/productdiscussion/reply_product_discussion_parameter.dart';
import '../../../domain/entity/product/productdiscussion/reply_product_discussion_response.dart';
import '../../../misc/processing/future_processing.dart';

abstract class ProductDiscussionDataSource {
  FutureProcessing<ProductDiscussion> productDiscussion(ProductDiscussionParameter productDiscussionParameter);
  FutureProcessing<CreateProductDiscussionResponse> createProductDiscussion(CreateProductDiscussionParameter createProductDiscussionParameter);
  FutureProcessing<ReplyProductDiscussionResponse> replyProductDiscussion(ReplyProductDiscussionParameter replyProductDiscussionParameter);
}