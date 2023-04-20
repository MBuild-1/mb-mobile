import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../controller/mainmenucontroller/mainmenusubpagecontroller/explore_nusantara_main_menu_sub_controller.dart';
import '../../../../misc/constant.dart';
import '../../../../misc/injector.dart';
import '../../../../misc/main_route_observer.dart';
import '../../../../misc/manager/controller_manager.dart';
import '../../../widget/background_app_bar_scaffold.dart';
import '../../../widget/modifiedappbar/main_menu_search_app_bar.dart';
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
  late AssetImage _exploreNusantaraAppBarBackgroundAssetImage;

  @override
  void initState() {
    super.initState();
    _exploreNusantaraAppBarBackgroundAssetImage = AssetImage(Constant.imagePatternExploreNusantaraMainMenuAppBar);
    MainRouteObserver.controllerMediatorMap[Constant.subPageKeyExploreNusantaraMainMenu] = refreshExploreNusantaraMainMenu;
  }

  @override
  void didChangeDependencies() {
    precacheImage(_exploreNusantaraAppBarBackgroundAssetImage, context);
    super.didChangeDependencies();
  }

  void refreshExploreNusantaraMainMenu() {

  }

  @override
  Widget build(BuildContext context) {
    return BackgroundAppBarScaffold(
      backgroundAppBarImage: _exploreNusantaraAppBarBackgroundAssetImage,
      appBar: MainMenuSearchAppBar(value: 0.0),
      body: const Expanded(
        child: WebView(

          initialUrl: "https://masterbagasi.com/explore-nusantara",
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}