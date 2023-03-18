import '../../../misc/getextended/get_extended.dart';
import '../../../misc/manager/controller_manager.dart';
import '../../base_getx_controller.dart';

class ExploreNusantaraMainMenuSubController extends BaseGetxController {
  ExploreNusantaraMainMenuSubController(super.controllerManager);
}

class ExploreNusantaraMainMenuSubControllerInjectionFactory {
  ExploreNusantaraMainMenuSubControllerInjectionFactory();

  ExploreNusantaraMainMenuSubController inject(ControllerManager controllerManager, String pageName) {
    return GetExtended.put<ExploreNusantaraMainMenuSubController>(
      ExploreNusantaraMainMenuSubController(controllerManager),
      tag: pageName
    );
  }
}