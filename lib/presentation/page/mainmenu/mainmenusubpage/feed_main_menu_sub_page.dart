import 'package:flutter/material.dart';

import '../../../../controller/mainmenucontroller/mainmenusubpagecontroller/feed_main_menu_sub_controller.dart';
import '../../../../misc/injector.dart';
import '../../../../misc/manager/controller_manager.dart';
import '../../getx_page.dart';

class FeedMainMenuSubPage extends DefaultGetxPage {
  late final ControllerMember<FeedMainMenuSubController> _feedMainMenuSubController = ControllerMember<FeedMainMenuSubController>().addToControllerManager(controllerManager);
  final String ancestorPageName;

  FeedMainMenuSubPage({Key? key, required this.ancestorPageName}) : super(key: key);

  @override
  void onSetController() {
    _feedMainMenuSubController.controller = Injector.locator<FeedMainMenuSubControllerInjectionFactory>().inject(controllerManager, ancestorPageName);
  }

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulFeedMainMenuSubControllerMediatorWidget(
      feedMainMenuSubController: _feedMainMenuSubController.controller
    );
  }
}

class _StatefulFeedMainMenuSubControllerMediatorWidget extends StatefulWidget {
  final FeedMainMenuSubController feedMainMenuSubController;

  const _StatefulFeedMainMenuSubControllerMediatorWidget({
    required this.feedMainMenuSubController
  });

  @override
  State<_StatefulFeedMainMenuSubControllerMediatorWidget> createState() => _StatefulHomeMainMenuSubControllerMediatorWidgetState();
}

class _StatefulHomeMainMenuSubControllerMediatorWidgetState extends State<_StatefulFeedMainMenuSubControllerMediatorWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Feed Main Menu Subpage")
    );
  }
}