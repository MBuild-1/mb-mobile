import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/base_getx_controller.dart';
import '../../../controller/mainmenucontroller/main_menu_controller.dart';
import '../../../controller/mainmenucontroller/mainmenusubpagecontroller/home_main_menu_sub_controller.dart';
import '../../../misc/constant.dart';
import '../../../misc/dialog_helper.dart';
import '../../../misc/getextended/get_extended.dart';
import '../../../misc/getextended/get_restorable_route_future.dart';
import '../../../misc/injector.dart';
import '../../../misc/manager/controller_manager.dart';
import '../../../misc/routeargument/main_menu_route_argument.dart';
import '../../../misc/typedef.dart';
import '../../widget/custom_bottom_navigation_bar.dart';
import '../../widget/modified_svg_picture.dart';
import '../login_page.dart';
import '../getx_page.dart';
import 'mainmenusubpage/home_main_menu_sub_page.dart';

class MainMenuPage extends RestorableGetxPage<_MainMenuPageRestoration> {
  late final ControllerMember<MainMenuController> _mainMenuController = ControllerMember<MainMenuController>().addToControllerManager(controllerManager);
  late final List<List<dynamic>> _mainMenuSubControllerList;

  MainMenuPage({Key? key}) : super(key: key, pageRestorationId: () => "main-menu-page") {
    _mainMenuSubControllerList = [
      [ControllerMember<HomeMainMenuSubController>().addToControllerManager(controllerManager), () => Injector.locator<HomeMainMenuSubControllerInjectionFactory>().inject(controllerManager, pageName), (BaseGetxController controller) {}]
    ];
  }

  @override
  void onSetController() {
    _mainMenuController.controller = GetExtended.put<MainMenuController>(MainMenuController(controllerManager), tag: pageName);
    for (var mainMenuSubController in _mainMenuSubControllerList) {
      (mainMenuSubController[0] as ControllerMember).controller = (mainMenuSubController[1] as GetControllerFromGetPut)();
    }
  }

  @override
  _MainMenuPageRestoration createPageRestoration() => _MainMenuPageRestoration();

  @override
  void onLoginChange() {
    for (var mainMenuSubController in _mainMenuSubControllerList) {
      mainMenuSubController[2]((mainMenuSubController[0] as ControllerMember).controller);
    }
  }

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulMainMenuControllerMediatorWidget(
      mainMenuController: _mainMenuController,
      mainMenuSubControllerList: _mainMenuSubControllerList,
      pageName: pageName,
    );
  }
}

class _MainMenuPageRestoration extends MixableGetxPageRestoration with LoginPageRestorationMixin {
  @override
  // ignore: unnecessary_overrides
  void initState() {
    super.initState();
  }

  @override
  // ignore: unnecessary_overrides
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  // ignore: unnecessary_overrides
  void dispose() {
    super.dispose();
  }
}

mixin MainMenuPageRestorationMixin on MixableGetxPageRestoration {
  late MainMenuPageRestorableRouteFuture mainMenuPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    mainMenuPageRestorableRouteFuture = MainMenuPageRestorableRouteFuture(restorationId: restorationIdWithPageName('main-menu-page-route'));
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    mainMenuPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    mainMenuPageRestorableRouteFuture.dispose();
  }
}

class MainMenuPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  @override
  GetPageBuilder get pageBuilder => (() => MainMenuPage());

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(MainMenuPage()));
}

class MainMenuPageRestorableRouteFuture extends GetRestorableRouteFuture {
  late RestorableRouteFuture<void> _pageRoute;

  MainMenuPageRestorableRouteFuture({required String restorationId}) : super(restorationId: restorationId) {
    _pageRoute = RestorableRouteFuture<void>(
      onPresent: (NavigatorState navigator, Object? arguments) {
        if (arguments is String) {
          if (arguments == Constant.restorableRouteFuturePushAndRemoveUntil) {
            return navigator.restorablePushAndRemoveUntil(_pageRouteBuilder, (route) => false, arguments: arguments);
          } else {
            return navigator.restorablePush(_pageRouteBuilder, arguments: arguments);
          }
        } else {
          return navigator.restorablePush(_pageRouteBuilder, arguments: arguments);
        }
      },
    );
  }

  static Route<void>? _getRoute([Object? arguments]) {
    return GetExtended.toWithGetPageRouteReturnValue<void>(
      GetxPageBuilder.buildRestorableGetxPageBuilder(MainMenuPageGetPageBuilderAssistant()),
      arguments: MainMenuRouteArgument(),
    );
  }

  @pragma('vm:entry-point')
  static Route<void> _pageRouteBuilder(BuildContext context, Object? arguments) {
    return _getRoute(arguments)!;
  }

  @override
  bool checkBeforePresent([Object? arguments]) => _getRoute(arguments) != null;

  @override
  void presentIfCheckIsPassed([Object? arguments]) => _pageRoute.present(arguments);

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    restorator.registerForRestoration(_pageRoute, restorationId);
  }

  @override
  void dispose() {
    _pageRoute.dispose();
  }
}

class _StatefulMainMenuControllerMediatorWidget extends StatefulWidget {
  final ControllerMember<MainMenuController> mainMenuController;
  final List<List<dynamic>> mainMenuSubControllerList;
  final String pageName;

  const _StatefulMainMenuControllerMediatorWidget({
    required this.mainMenuController,
    required this.mainMenuSubControllerList,
    required this.pageName
  });

  @override
  State<_StatefulMainMenuControllerMediatorWidget> createState() => _StatefulMainMenuControllerMediatorWidgetState();
}

class _StatefulMainMenuControllerMediatorWidgetState extends State<_StatefulMainMenuControllerMediatorWidget> {
  late CustomBottomNavigationBarSelectedIndex _customBottomNavigationBarSelectedIndex;

  @override
  void initState() {
    super.initState();
    _onItemTapped(
      CustomBottomNavigationBarSelectedIndex(
        currentSelectedViewMenuIndex: 0,
        currentSelectedMenuIndex: 0
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: _customBottomNavigationBarSelectedIndex.currentSelectedViewMenuIndex,
              children: [
                HomeMainMenuSubPage(ancestorPageName: widget.pageName),
              ],
            )
          ),
          CustomBottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _customBottomNavigationBarSelectedIndex.currentSelectedMenuIndex,
            selectedFontSize: 12.0,
            unselectedFontSize: 12.0,
            onTap: (selectedIndex) => _onItemTappedWithContext(selectedIndex, context),
            items: [
              CustomBottomNavigationBarItem(
                icon: ModifiedSvgPicture.asset(Constant.vectorHomeUnselected, overrideDefaultColorWithSingleColor: false),
                activeIcon: ModifiedSvgPicture.asset(Constant.vectorHomeSelected, overrideDefaultColorWithSingleColor: false),
                label: 'Home'.tr,
                hideLabelWhenInactive: false,
              ),
              CustomBottomNavigationBarItem(
                icon: ModifiedSvgPicture.asset(Constant.vectorFeedUnselected, overrideDefaultColorWithSingleColor: false),
                activeIcon: ModifiedSvgPicture.asset(Constant.vectorFeedSelected, overrideDefaultColorWithSingleColor: false),
                label: 'Feed'.tr,
                hideLabelWhenInactive: false
              ),
              CustomBottomNavigationBarItem(
                icon: ModifiedSvgPicture.asset(Constant.vectorExploreUnselected, overrideDefaultColorWithSingleColor: false),
                activeIcon: ModifiedSvgPicture.asset(Constant.vectorExploreSelected, overrideDefaultColorWithSingleColor: false),
                label: 'Explore'.tr,
                hideLabelWhenInactive: false
              ),
              CustomBottomNavigationBarItem(
                icon: ModifiedSvgPicture.asset(Constant.vectorWishlistUnselected, overrideDefaultColorWithSingleColor: false),
                activeIcon: ModifiedSvgPicture.asset(Constant.vectorWishlistSelected, overrideDefaultColorWithSingleColor: false),
                label: 'Wishlist'.tr,
                hideLabelWhenInactive: false
              ),
              CustomBottomNavigationBarItem(
                icon: ModifiedSvgPicture.asset(Constant.vectorMenuUnselected, overrideDefaultColorWithSingleColor: false),
                activeIcon: ModifiedSvgPicture.asset(Constant.vectorMenuSelected, overrideDefaultColorWithSingleColor: false),
                label: 'Menu'.tr,
                hideLabelWhenInactive: false
              ),
            ],
          )
        ]
      ),
    );
  }

  void _onItemTapped(CustomBottomNavigationBarSelectedIndex selectedIndex) {
    if (selectedIndex.currentSelectedMenuIndex != 3) {
      _customBottomNavigationBarSelectedIndex = selectedIndex;
      _firstInitTabChildWidget(selectedIndex);
    }
  }

  void _onItemTappedWithContext(CustomBottomNavigationBarSelectedIndex selectedIndex, BuildContext context) {
    if (selectedIndex.currentSelectedMenuIndex != 3) {
      _customBottomNavigationBarSelectedIndex = selectedIndex;
      _firstInitTabChildWidget(selectedIndex);
    } else {
      DialogHelper.showPromptUnderConstruction(context);
      //restoration.editProfilePageRestorableRouteFuture.present();
    }
  }

  void _firstInitTabChildWidget(CustomBottomNavigationBarSelectedIndex selectedIndex) {
    int selectedViewIndex = selectedIndex.currentSelectedViewMenuIndex;
    dynamic controller = (widget.mainMenuSubControllerList[selectedViewIndex][0] as ControllerMember).controller;
    if (controller is BaseGetxController) {
      if (!controller.hasInitController()) {
        controller.initController();
      }
    }
  }
}