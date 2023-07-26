import '../domain/entity/chat/help/get_help_message_by_user_parameter.dart';
import '../domain/entity/chat/help/get_help_message_by_user_response.dart';
import '../domain/usecase/get_help_message_by_user_use_case.dart';
import '../misc/load_data_result.dart';
import 'base_getx_controller.dart';

class HelpChatController extends BaseGetxController {
  final GetHelpMessageByUserUseCase getHelpMessageByUserUseCase;

  HelpChatController(
    super.controllerManager,
    this.getHelpMessageByUserUseCase
  );

  Future<LoadDataResult<GetHelpMessageByUserResponse>> getHelpMessageByUser(GetHelpMessageByUserParameter getHelpMessageByUserParameter) {
    return getHelpMessageByUserUseCase.execute(getHelpMessageByUserParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("help-message-by-user").value
    );
  }
}