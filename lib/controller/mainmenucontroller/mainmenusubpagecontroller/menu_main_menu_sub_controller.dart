import '../../../misc/getextended/get_extended.dart';
import '../../../misc/manager/controller_manager.dart';
import '../../base_getx_controller.dart';

typedef _OnShowLogoutRequestProcessLoadingCallback = Future<void> Function();
typedef _OnLogoutRequestProcessSuccessCallback = Future<void> Function();
typedef _OnShowLogoutRequestProcessFailedCallback = Future<void> Function(dynamic e);
typedef _OnDeleteToken = Future<void> Function();

class MenuMainMenuSubController extends BaseGetxController {
  MenuMainMenuSubController(super.controllerManager);
}

class MenuMainMenuSubControllerInjectionFactory {
  MenuMainMenuSubControllerInjectionFactory();

  MenuMainMenuSubController inject(ControllerManager controllerManager, String pageName) {
    return GetExtended.put<MenuMainMenuSubController>(
      MenuMainMenuSubController(controllerManager),
      tag: pageName
    );
  }
}