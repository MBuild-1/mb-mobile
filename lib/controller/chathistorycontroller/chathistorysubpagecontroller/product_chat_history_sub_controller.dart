import '../../../domain/entity/chat/product/get_product_message_by_user_parameter.dart';
import '../../../domain/entity/chat/product/get_product_message_by_user_response.dart';
import '../../../domain/usecase/get_product_message_by_user_use_case.dart';
import '../../../misc/getextended/get_extended.dart';
import '../../../misc/load_data_result.dart';
import '../../../misc/manager/controller_manager.dart';
import '../../base_getx_controller.dart';

class ProductChatHistorySubController extends BaseGetxController {
  final GetProductMessageByUserUseCase getProductMessageByUserUseCase;

  ProductChatHistorySubController(
    super.controllerManager,
    this.getProductMessageByUserUseCase
  );

  Future<LoadDataResult<GetProductMessageByUserResponse>> getProductMessageByUserResponse(GetProductMessageByUserParameter getProductMessageByUserParameter) {
    return getProductMessageByUserUseCase.execute(getProductMessageByUserParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("product-chat-history").value
    );
  }
}

class ProductChatHistorySubControllerInjectionFactory {
  final GetProductMessageByUserUseCase getProductMessageByUserUseCase;

  ProductChatHistorySubControllerInjectionFactory({
    required this.getProductMessageByUserUseCase
  });

  ProductChatHistorySubController inject(ControllerManager controllerManager, String pageName) {
    return GetExtended.put<ProductChatHistorySubController>(
      ProductChatHistorySubController(
        controllerManager,
        getProductMessageByUserUseCase
      ),
      tag: pageName
    );
  }
}