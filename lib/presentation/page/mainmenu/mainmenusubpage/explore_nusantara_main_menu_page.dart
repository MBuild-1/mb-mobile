import 'package:flutter/material.dart';

import '../../../../controller/mainmenucontroller/mainmenusubpagecontroller/explore_nusantara_main_menu_sub_controller.dart';
import '../../../../misc/injector.dart';
import '../../../../misc/manager/controller_manager.dart';
import '../../getx_page.dart';

class ExploreNusantaraMainMenuSubPage extends DefaultGetxPage {
  late final ControllerMember<ExploreNusantaraMainMenuSubController> _exploreNusantaraMainMenuSubController = ControllerMember<ExploreNusantaraMainMenuSubController>().addToControllerManager(controllerManager);
  final String ancestorPageName;

  ExploreNusantaraMainMenuSubPage({Key? key, required this.ancestorPageName}) : super(key: key);

  @override
  void onSetController() {
    _exploreNusantaraMainMenuSubController.controller = Injector.locator<ExploreNusantaraMainMenuSubControllerInjectionFactory>().inject(controllerManager, ancestorPageName);
  }

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulExploreNusantaraMainMenuSubControllerMediatorWidget(
      exploreNusantaraMainMenuSubController: _exploreNusantaraMainMenuSubController.controller
    );
  }
}

class _StatefulExploreNusantaraMainMenuSubControllerMediatorWidget extends StatefulWidget {
  final ExploreNusantaraMainMenuSubController exploreNusantaraMainMenuSubController;

  const _StatefulExploreNusantaraMainMenuSubControllerMediatorWidget({
    required this.exploreNusantaraMainMenuSubController
  });

  @override
  State<_StatefulExploreNusantaraMainMenuSubControllerMediatorWidget> createState() => _StatefulExploreNusantaraMainMenuSubControllerMediatorWidgetState();
}

class _StatefulExploreNusantaraMainMenuSubControllerMediatorWidgetState extends State<_StatefulExploreNusantaraMainMenuSubControllerMediatorWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Explore Nusantara Main Menu Subpage")
    );
  }
}