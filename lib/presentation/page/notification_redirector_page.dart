import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/navigator_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../controller/notification_redirector_controller.dart';
import '../../misc/constant.dart';
import '../../misc/error/message_error.dart';
import '../../misc/getextended/get_extended.dart';
import '../../misc/getextended/get_restorable_route_future.dart';
import '../../misc/main_route_observer.dart';
import '../../misc/manager/controller_manager.dart';
import '../../misc/notification_redirector_helper.dart';
import '../../misc/page_restoration_helper.dart';
import '../../misc/routeargument/notification_redirector_route_argument.dart';
import 'favorite_product_brand_page.dart';
import 'getx_page.dart';
import 'help_chat_page.dart';
import 'order_chat_page.dart';
import 'order_detail_page.dart';
import 'product_chat_page.dart';
import 'shared_cart_page.dart';

class NotificationRedirectorPage extends RestorableGetxPage<_NotificationRedirectorPageRestoration> {
  late final ControllerMember<NotificationRedirectorController> _notificationRedirectorController = ControllerMember<NotificationRedirectorController>().addToControllerManager(controllerManager);

  final NotificationRedirectorPageParameter notificationRedirectorPageParameter;

  NotificationRedirectorPage({
    Key? key,
    required this.notificationRedirectorPageParameter
  }) : super(key: key, pageRestorationId: () => "notification-redirector-page", systemUiOverlayStyle: SystemUiOverlayStyle.dark);

  @override
  void onSetController() {
    _notificationRedirectorController.controller = GetExtended.put<NotificationRedirectorController>(NotificationRedirectorController(controllerManager), tag: pageName);
  }

  @override
  _NotificationRedirectorPageRestoration createPageRestoration() => _NotificationRedirectorPageRestoration();

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulNotificationRedirectorControllerMediatorWidget(
      notificationRedirectorController: _notificationRedirectorController.controller,
      notificationRedirectorPageParameter: notificationRedirectorPageParameter
    );
  }
}

mixin NotificationRedirectorPageRestorationMixin on MixableGetxPageRestoration {
  late NotificationRedirectorPageRestorableRouteFuture notificationRedirectorPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    notificationRedirectorPageRestorableRouteFuture = NotificationRedirectorPageRestorableRouteFuture(restorationId: restorationIdWithPageName('notification-redirector-route'));
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    notificationRedirectorPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    notificationRedirectorPageRestorableRouteFuture.dispose();
  }
}

class _NotificationRedirectorPageRestoration extends ExtendedMixableGetxPageRestoration with HelpChatPageRestorationMixin, OrderChatPageRestorationMixin, ProductChatPageRestorationMixin, FavoriteProductBrandPageRestorationMixin, OrderDetailPageRestorationMixin, SharedCartPageRestorationMixin {
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

class NotificationRedirectorPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  final NotificationRedirectorPageParameter notificationRedirectorPageParameter;

  NotificationRedirectorPageGetPageBuilderAssistant({
    required this.notificationRedirectorPageParameter
  });

  @override
  GetPageBuilder get pageBuilder => (() => NotificationRedirectorPage(notificationRedirectorPageParameter: notificationRedirectorPageParameter));

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(NotificationRedirectorPage(notificationRedirectorPageParameter: notificationRedirectorPageParameter)));
}

class NotificationRedirectorPageRestorableRouteFuture extends GetRestorableRouteFuture {
  late RestorableRouteFuture<void> _pageRoute;

  NotificationRedirectorPageRestorableRouteFuture({required String restorationId}) : super(restorationId: restorationId) {
    _pageRoute = RestorableRouteFuture<void>(
      onPresent: PageRestorationHelper.onPresentWithPushModeAndTransitionModeParameter(
        onNavigatorRestorablePushAndRemoveUntil: (navigator, arguments) => navigator.restorablePushAndRemoveUntil(_pageRouteBuilder, (route) => false, arguments: arguments),
        onNavigatorRestorablePush: (navigator, arguments) => navigator.restorablePush(_pageRouteBuilder, arguments: arguments),
      )
    );
  }

  static Route<void>? _getRoute([Object? arguments]) {
    if (arguments is! String) {
      throw MessageError(message: "Arguments must be a String");
    }
    NotificationRedirectorPageParameter notificationRedirectorPageParameter = arguments.toNotificationRedirectorPageParameter();
    return PageRestorationHelper.getRouteWithPushModeAndTransitionModeParameter(
      arguments: notificationRedirectorPageParameter.pushModeAndTransitionMode.toJsonString(),
      onPassingAdditionalArguments: () => NotificationRedirectorRouteArgument(),
      onInterceptToWithGetPageRouteReturnValue: (getPageBuilderWithPageName, argumentsParameter, additionalArgumentsParameter, duration) {
        return GetExtended.toWithGetPageRouteReturnValue<void>(
          getPageBuilderWithPageName,
          opaque: false,
          arguments: additionalArgumentsParameter,
          duration: duration
        );
      },
      onBuildRestorableGetxPageBuilder: () => GetxPageBuilder.buildRestorableGetxPageBuilder(
        NotificationRedirectorPageGetPageBuilderAssistant(
          notificationRedirectorPageParameter: notificationRedirectorPageParameter
        )
      )
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

class _StatefulNotificationRedirectorControllerMediatorWidget extends StatefulWidget {
  final NotificationRedirectorController notificationRedirectorController;
  final NotificationRedirectorPageParameter notificationRedirectorPageParameter;

  const _StatefulNotificationRedirectorControllerMediatorWidget({
    required this.notificationRedirectorController,
    required this.notificationRedirectorPageParameter
  });

  @override
  State<_StatefulNotificationRedirectorControllerMediatorWidget> createState() => _StatefulNotificationRedirectorControllerMediatorWidgetState();
}

class _StatefulNotificationRedirectorControllerMediatorWidgetState extends State<_StatefulNotificationRedirectorControllerMediatorWidget> {
  bool _isRedirect = false;
  Map<String, dynamic>? _additionalData;
  bool _processingRedirectWhenDispose = false;

  @override
  Widget build(BuildContext context) {
    if (!_isRedirect) {
      _isRedirect = true;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        var notificationRedirectorMap = NotificationRedirectorHelper.notificationRedirectorMap;
        NotificationRedirectorPageParameter notificationRedirectorPageParameter = widget.notificationRedirectorPageParameter;
        _additionalData = notificationRedirectorPageParameter.additionalData;
        if (_additionalData!.containsKey("type")) {
          String type = _additionalData!["type"];
          if (notificationRedirectorMap.containsKey(type)) {
            _processingRedirectWhenDispose = true;
          } else {
            _processingRedirectWhenDispose = false;
          }
        } else {
          _processingRedirectWhenDispose = false;
        }
        Map<String, RouteWrapper?> routeMap = MainRouteObserver.routeMap;
        List<String> routeKeyList = List.of(routeMap.keys);
        int i = 0;
        int resultI = -1;
        for (var element in routeMap.entries) {
          var arguments = element.value?.route?.settings.arguments;
          if (arguments is NotificationRedirectorRouteArgument) {
            resultI = i - 1;
            break;
          }
          i++;
        }
        String routeName = "";
        String thisRouteName = "";
        if (resultI > -1) {
          routeName = routeMap[routeKeyList[resultI]]?.route?.settings.name ?? "";
        }
        if (i > -1) {
          thisRouteName = routeMap[routeKeyList[i]]?.route?.settings.name ?? "";
        }
        if (_processingRedirectWhenDispose) {
          if (_additionalData!.containsKey("type")) {
            String type = _additionalData!["type"];
            if (notificationRedirectorMap.containsKey(type)) {
              notificationRedirectorMap[type]!(_additionalData!, context);
              if (routeName.isNotEmptyString && thisRouteName.isNotEmptyString) {
                String newRouteName = "";
                routeMap = MainRouteObserver.routeMap;
                routeKeyList = List.of(routeMap.keys);
                if (routeMap.isNotEmpty) {
                  newRouteName = routeMap[routeKeyList[routeKeyList.length - 1]]?.route?.settings.name ?? "";
                }
                if (newRouteName.isNotEmptyString) {
                  MainRouteObserver.disposingEventRouteMap[newRouteName] = () {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                      BuildContext Function()? buildContextEventFunction = MainRouteObserver.buildContextEventRouteMap[thisRouteName];
                      if (buildContextEventFunction != null) {
                        BuildContext buildContext = buildContextEventFunction();
                        Navigator.of(buildContext).popUntilOneStepBelowNotificationRedirector();
                      }
                      MainRouteObserver.disposingEventRouteMap[thisRouteName] = null;
                    });
                  };
                }
              }
            }
          }
        }
      });
    }
    return WillPopScope(
      onWillPop: () async => false,
      child: const Scaffold(
        appBar: null,
        backgroundColor: Colors.transparent,
        body: SizedBox()
      ),
    );
  }
}

class NotificationRedirectorPageParameter {
  PushModeAndTransitionMode pushModeAndTransitionMode;
  Map<String, dynamic> additionalData;

  NotificationRedirectorPageParameter({
    required this.pushModeAndTransitionMode,
    required this.additionalData
  });
}

extension NotificationRedirectorPageParameterExt on NotificationRedirectorPageParameter {
  String toJsonString() {
    return json.encode(
      <String, dynamic>{
        "push_mode_and_transition_mode": pushModeAndTransitionMode.toJsonMap(),
        "additional_data": additionalData
      }
    );
  }
}

extension NotificationRedirectorPageParameterStringExt on String {
  NotificationRedirectorPageParameter toNotificationRedirectorPageParameter() {
    dynamic jsonResult = json.decode(this);
    return NotificationRedirectorPageParameter(
      pushModeAndTransitionMode: PageRestorationHelper.parsePushModeAndTransitionMode(json.encode(jsonResult["push_mode_and_transition_mode"])),
      additionalData: jsonResult["additional_data"]
    );
  }
}