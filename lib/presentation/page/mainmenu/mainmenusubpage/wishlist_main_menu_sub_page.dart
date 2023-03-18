import 'package:flutter/material.dart';

import '../../../../controller/mainmenucontroller/mainmenusubpagecontroller/wishlist_main_menu_sub_controller.dart';
import '../../../../misc/injector.dart';
import '../../../../misc/manager/controller_manager.dart';
import '../../getx_page.dart';

class WishlistMainMenuSubPage extends DefaultGetxPage {
  late final ControllerMember<WishlistMainMenuSubController> _wishlistMainMenuSubController = ControllerMember<WishlistMainMenuSubController>().addToControllerManager(controllerManager);
  final String ancestorPageName;

  WishlistMainMenuSubPage({Key? key, required this.ancestorPageName}) : super(key: key);

  @override
  void onSetController() {
    _wishlistMainMenuSubController.controller = Injector.locator<WishlistMainMenuSubControllerInjectionFactory>().inject(controllerManager, ancestorPageName);
  }

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulWishlistMainMenuSubControllerMediatorWidget(
      wishlistMainMenuSubController: _wishlistMainMenuSubController.controller
    );
  }
}

class _StatefulWishlistMainMenuSubControllerMediatorWidget extends StatefulWidget {
  final WishlistMainMenuSubController wishlistMainMenuSubController;

  const _StatefulWishlistMainMenuSubControllerMediatorWidget({
    required this.wishlistMainMenuSubController
  });

  @override
  State<_StatefulWishlistMainMenuSubControllerMediatorWidget> createState() => _StatefulWishlistMainMenuSubControllerMediatorWidgetState();
}

class _StatefulWishlistMainMenuSubControllerMediatorWidgetState extends State<_StatefulWishlistMainMenuSubControllerMediatorWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Wishlist Main Menu Subpage")
    );
  }
}