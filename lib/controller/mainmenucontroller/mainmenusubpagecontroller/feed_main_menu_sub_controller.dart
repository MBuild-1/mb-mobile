import '../../../misc/getextended/get_extended.dart';
import '../../../misc/manager/controller_manager.dart';
import '../../base_getx_controller.dart';

class FeedMainMenuSubController extends BaseGetxController {
  FeedMainMenuSubController(super.controllerManager);
}

class FeedMainMenuSubControllerInjectionFactory {
  FeedMainMenuSubControllerInjectionFactory();

  FeedMainMenuSubController inject(ControllerManager controllerManager, String pageName) {
    return GetExtended.put<FeedMainMenuSubController>(
      FeedMainMenuSubController(controllerManager),
      tag: pageName
    );
  }
}