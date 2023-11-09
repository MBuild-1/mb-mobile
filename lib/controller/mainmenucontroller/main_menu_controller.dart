import 'package:get/get.dart';

import '../../domain/entity/chat/help/get_help_message_by_user_parameter.dart';
import '../../domain/entity/chat/help/get_help_message_by_user_response.dart';
import '../../domain/entity/chat/help/get_help_message_notification_count_parameter.dart';
import '../../domain/entity/chat/help/get_help_message_notification_count_response.dart';
import '../../domain/usecase/get_help_message_by_user_use_case.dart';
import '../../domain/usecase/get_help_message_notification_count_use_case.dart';
import '../../misc/load_data_result.dart';
import '../../misc/manager/controller_manager.dart';
import '../base_getx_controller.dart';

typedef _OnGetLoginStatus = bool Function();

class MainMenuController extends BaseGetxController {
  final GetHelpMessageByUserUseCase getHelpMessageByUserUseCase;

  late Rx<bool> isLoginRx;

  MainMenuDelegate? _mainMenuDelegate;
  bool _hasCheckLoginStatus = false;

  MainMenuController(
    ControllerManager? controllerManager,
    this.getHelpMessageByUserUseCase
  ) : super(controllerManager) {
    isLoginRx = true.obs;
  }

  Future<LoadDataResult<GetHelpMessageByUserResponse>> getHelpMessageByUser(GetHelpMessageByUserParameter getHelpMessageByUserParameter) {
    return getHelpMessageByUserUseCase.execute(getHelpMessageByUserParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("help-message-by-user", duplicate: true).value
    );
  }

  void checkLoginStatus({bool reset = false}) async {
    if (_mainMenuDelegate != null) {
      if (reset) {
        _hasCheckLoginStatus = false;
      }
      if (!_hasCheckLoginStatus) {
        _hasCheckLoginStatus = true;
        isLoginRx.value = _mainMenuDelegate!.onGetLoginStatus();
        updateMainMenuState();
      }
    }
  }

  MainMenuController setMainMenuDelegate(MainMenuDelegate mainMenuDelegate) {
    _mainMenuDelegate = mainMenuDelegate;
    return this;
  }

  void updateMainMenuState() {
    update();
  }
}

class MainMenuDelegate {
  _OnGetLoginStatus onGetLoginStatus;

  MainMenuDelegate({
    required this.onGetLoginStatus,
  });
}