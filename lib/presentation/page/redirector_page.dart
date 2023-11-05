import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../controller/redirector_controller.dart';
import '../../misc/constant.dart';
import '../../misc/getextended/get_extended.dart';
import '../../misc/getextended/get_restorable_route_future.dart';
import '../../misc/login_helper.dart';
import '../../misc/manager/controller_manager.dart';
import '../../misc/page_restoration_helper.dart';
import 'getx_page.dart';
import 'introduction_page.dart';
import 'mainmenu/main_menu_page.dart';

class RedirectorPage extends RestorableGetxPage<_RedirectorPageRestoration> {
  late final ControllerMember<RedirectorController> _redirectorController = ControllerMember<RedirectorController>().addToControllerManager(controllerManager);

  RedirectorPage({Key? key}) : super(key: key, pageRestorationId: () => "redirector-page", systemUiOverlayStyle: SystemUiOverlayStyle.light);

  @override
  void onSetController() {
    _redirectorController.controller = GetExtended.put<RedirectorController>(RedirectorController(controllerManager), tag: pageName);
  }

  @override
  _RedirectorPageRestoration createPageRestoration() => _RedirectorPageRestoration();

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulRedirectorControllerMediatorWidget(
      redirectorController: _redirectorController.controller,
    );
  }
}

class _RedirectorPageRestoration extends MixableGetxPageRestoration with IntroductionPageRestorationMixin, MainMenuPageRestorationMixin {
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

class RedirectorPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  @override
  GetPageBuilder get pageBuilder => (() => RedirectorPage());

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(RedirectorPage()));
}

class RedirectorPageRestorableRouteFuture extends GetRestorableRouteFuture {
  late RestorableRouteFuture<void> _pageRoute;

  RedirectorPageRestorableRouteFuture({required String restorationId}) : super(restorationId: restorationId) {
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
      GetxPageBuilder.buildRestorableGetxPageBuilder(RedirectorPageGetPageBuilderAssistant())
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

class _StatefulRedirectorControllerMediatorWidget extends StatefulWidget {
  final RedirectorController redirectorController;

  const _StatefulRedirectorControllerMediatorWidget({
    required this.redirectorController
  });

  @override
  State<_StatefulRedirectorControllerMediatorWidget> createState() => _StatefulRedirectorControllerMediatorWidgetState();
}

class _StatefulRedirectorControllerMediatorWidgetState extends State<_StatefulRedirectorControllerMediatorWidget> {
  bool _isRedirect = false;

  @override
  Widget build(BuildContext context) {
    if (!_isRedirect) {
      _isRedirect = true;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        if (LoginHelper.getTokenWithBearer().result.isNotEmptyString) {
          return PageRestorationHelper.toMainMenuPage(
            context, json.encode(
              <String, dynamic>{
                "has_transition": 0,
                "push_mode": Constant.restorableRouteFuturePushAndRemoveUntil
              }
            )
          );
        } else {
          return PageRestorationHelper.toIntroductionPage(
            context, json.encode(
              <String, dynamic>{
                "has_transition": 0,
                "push_mode": Constant.restorableRouteFuturePushAndRemoveUntil
              }
            )
          );
        }
      });
    }
    return const Scaffold(
      appBar: null,
      body: SizedBox()
    );
  }
}