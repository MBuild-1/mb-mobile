import '../../../misc/getextended/get_extended.dart';
import '../../../misc/manager/controller_manager.dart';
import '../../base_getx_controller.dart';

class MBestieMainMenuSubController extends BaseGetxController {
  MBestieMainMenuSubController(
    super.controllerManager
  );
}

class MBestieMainMenuSubControllerInjectionFactory {
  MBestieMainMenuSubControllerInjectionFactory();

  MBestieMainMenuSubController inject(ControllerManager controllerManager, String pageName) {
    return GetExtended.put<MBestieMainMenuSubController>(
      MBestieMainMenuSubController(controllerManager),
      tag: pageName
    );
  }
}