import '../domain/entity/discussion/support_discussion.dart';
import '../domain/entity/discussion/support_discussion_parameter.dart';
import '../domain/entity/product/productdiscussion/create_product_discussion_parameter.dart';
import '../domain/entity/product/productdiscussion/create_product_discussion_response.dart';
import '../domain/entity/product/productdiscussion/product_discussion.dart';
import '../domain/entity/product/productdiscussion/product_discussion_list_parameter.dart';
import '../domain/entity/product/productdiscussion/reply_product_discussion_parameter.dart';
import '../domain/entity/product/productdiscussion/reply_product_discussion_response.dart';
import '../domain/entity/user/getuser/get_user_parameter.dart';
import '../domain/entity/user/getuser/get_user_response.dart';
import '../domain/usecase/create_product_discussion_use_case.dart';
import '../domain/usecase/get_product_discussion_use_case.dart';
import '../domain/usecase/get_support_discussion_use_case.dart';
import '../domain/usecase/get_user_use_case.dart';
import '../domain/usecase/reply_product_discussion_use_case.dart';
import '../misc/load_data_result.dart';
import 'base_getx_controller.dart';

class ProductDiscussionController extends BaseGetxController {
  final GetProductDiscussionUseCase getProductDiscussionUseCase;
  final GetSupportDiscussionUseCase getSupportDiscussionUseCase;
  final CreateProductDiscussionUseCase createProductDiscussionUseCase;
  final ReplyProductDiscussionUseCase replyProductDiscussionUseCase;
  final GetUserUseCase getUserUseCase;

  ProductDiscussionController(
    super.controllerManager,
    this.getProductDiscussionUseCase,
    this.getSupportDiscussionUseCase,
    this.createProductDiscussionUseCase,
    this.replyProductDiscussionUseCase,
    this.getUserUseCase
  );

  Future<LoadDataResult<ProductDiscussion>> getProductDiscussion(ProductDiscussionParameter productDiscussionParameter) {
    return getProductDiscussionUseCase.execute(productDiscussionParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("product-discussion", duplicate: true).value
    );
  }

  Future<LoadDataResult<SupportDiscussion>> getSupportDiscussion(SupportDiscussionParameter supportDiscussionParameter) {
    return getSupportDiscussionUseCase.execute(supportDiscussionParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("support-discussion").value
    );
  }

  Future<LoadDataResult<CreateProductDiscussionResponse>> createProductDiscussion(CreateProductDiscussionParameter createProductDiscussionParameter) {
    return createProductDiscussionUseCase.execute(createProductDiscussionParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("create-product-discussion", duplicate: true).value
    );
  }

  Future<LoadDataResult<ReplyProductDiscussionResponse>> replyProductDiscussion(ReplyProductDiscussionParameter replyProductDiscussionParameter) {
    return replyProductDiscussionUseCase.execute(replyProductDiscussionParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("reply-product-discussion", duplicate: true).value
    );
  }

  Future<LoadDataResult<GetUserResponse>> getUser(GetUserParameter getUserParameter) {
    return getUserUseCase.execute(getUserParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("get-user", duplicate: true).value
    );
  }
}