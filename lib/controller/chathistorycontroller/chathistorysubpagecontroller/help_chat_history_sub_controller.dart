import '../../../misc/getextended/get_extended.dart';
import '../../../misc/manager/controller_manager.dart';
import '../../base_getx_controller.dart';

class HelpChatHistorySubController extends BaseGetxController {
  HelpChatHistorySubController(
    super.controllerManager,
  );
}

class HelpChatHistorySubControllerInjectionFactory {
  HelpChatHistorySubController inject(ControllerManager controllerManager, String pageName) {
    return GetExtended.put<HelpChatHistorySubController>(
      HelpChatHistorySubController(
        controllerManager
      ),
      tag: pageName
    );
  }
}