import '../../../misc/getextended/get_extended.dart';
import '../../../misc/manager/controller_manager.dart';
import '../../base_getx_controller.dart';

class WishlistMainMenuSubController extends BaseGetxController {
  WishlistMainMenuSubController(super.controllerManager);
}

class WishlistMainMenuSubControllerInjectionFactory {
  WishlistMainMenuSubControllerInjectionFactory();

  WishlistMainMenuSubController inject(ControllerManager controllerManager, String pageName) {
    return GetExtended.put<WishlistMainMenuSubController>(
      WishlistMainMenuSubController(controllerManager),
      tag: pageName
    );
  }
}