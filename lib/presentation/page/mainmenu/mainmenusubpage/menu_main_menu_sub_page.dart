import 'package:flutter/material.dart';

import '../../../../controller/mainmenucontroller/mainmenusubpagecontroller/menu_main_menu_sub_controller.dart';
import '../../../../misc/injector.dart';
import '../../../../misc/manager/controller_manager.dart';
import '../../getx_page.dart';

class MenuMainMenuSubPage extends DefaultGetxPage {
  late final ControllerMember<MenuMainMenuSubController> _menuMainMenuSubController = ControllerMember<MenuMainMenuSubController>().addToControllerManager(controllerManager);
  final String ancestorPageName;

  MenuMainMenuSubPage({Key? key, required this.ancestorPageName}) : super(key: key);

  @override
  void onSetController() {
    _menuMainMenuSubController.controller = Injector.locator<MenuMainMenuSubControllerInjectionFactory>().inject(controllerManager, ancestorPageName);
  }

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulMenuMainMenuSubControllerMediatorWidget(
      menuMainMenuSubController: _menuMainMenuSubController.controller
    );
  }
}

class _StatefulMenuMainMenuSubControllerMediatorWidget extends StatefulWidget {
  final MenuMainMenuSubController menuMainMenuSubController;

  const _StatefulMenuMainMenuSubControllerMediatorWidget({
    required this.menuMainMenuSubController
  });

  @override
  State<_StatefulMenuMainMenuSubControllerMediatorWidget> createState() => _StatefulMenuMainMenuSubControllerMediatorWidgetState();
}

class _StatefulMenuMainMenuSubControllerMediatorWidgetState extends State<_StatefulMenuMainMenuSubControllerMediatorWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Menu (Account) Main Menu Subpage")
    );
  }
}