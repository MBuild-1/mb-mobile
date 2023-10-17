import '../../domain/entity/product/productdiscussion/create_product_discussion_parameter.dart';
import '../../domain/entity/product/productdiscussion/create_product_discussion_response.dart';
import '../../domain/entity/product/productdiscussion/product_discussion.dart';
import '../../domain/entity/product/productdiscussion/product_discussion_based_user_parameter.dart';
import '../../domain/entity/product/productdiscussion/product_discussion_list_parameter.dart';
import '../../domain/entity/product/productdiscussion/reply_product_discussion_parameter.dart';
import '../../domain/entity/product/productdiscussion/reply_product_discussion_response.dart';
import '../../domain/repository/product_discussion_repository.dart';
import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../datasource/productdiscussiondatasource/product_discussion_data_source.dart';

class DefaultProductDiscussionRepository implements ProductDiscussionRepository {
  final ProductDiscussionDataSource productDiscussionDataSource;

  const DefaultProductDiscussionRepository({
    required this.productDiscussionDataSource
  });

  @override
  FutureProcessing<LoadDataResult<ProductDiscussion>> productDiscussionBasedUser(ProductDiscussionBasedUserParameter productDiscussionBasedUserParameter) {
    return productDiscussionDataSource.productDiscussionBasedUser(productDiscussionBasedUserParameter).mapToLoadDataResult<ProductDiscussion>();
  }

  @override
  FutureProcessing<LoadDataResult<ProductDiscussion>> productDiscussion(ProductDiscussionParameter productDiscussionParameter) {
    return productDiscussionDataSource.productDiscussion(productDiscussionParameter).mapToLoadDataResult<ProductDiscussion>();
  }

  @override
  FutureProcessing<LoadDataResult<CreateProductDiscussionResponse>> createProductDiscussion(CreateProductDiscussionParameter createProductDiscussionParameter) {
    return productDiscussionDataSource.createProductDiscussion(createProductDiscussionParameter).mapToLoadDataResult<CreateProductDiscussionResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<ReplyProductDiscussionResponse>> replyProductDiscussion(ReplyProductDiscussionParameter replyProductDiscussionParameter) {
    return productDiscussionDataSource.replyProductDiscussion(replyProductDiscussionParameter).mapToLoadDataResult<ReplyProductDiscussionResponse>();
  }
}