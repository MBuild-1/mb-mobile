import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main_route_observer.dart';
import '../routeargument/login_route_argument.dart';
import '../routeargument/main_menu_route_argument.dart';
import '../routeargument/notification_redirector_route_argument.dart';
import '../routeargument/order_route_argument.dart';

extension NavigatorStateExt on NavigatorState {
  void popUntilLogin() {
    popUntil(popUntilLoginPredicate());
  }

  void popUntilMainMenu() {
    popUntil(popUntilMainMenuPredicate());
  }

  void popUntilOrder() {
    popUntil(popUntilOrderPredicate());
  }

  void popUntilOneStepBelowNotificationRedirector() {
    popUntil(popUntilOneStepBelowNotificationRedirectorPredicate());
  }

  RoutePredicate popUntilLoginPredicate() {
    return (route) {
      if (route is GetPageRoute) {
        if (route.settings.arguments is LoginRouteArgument) {
          return true;
        }
      }
      return false;
    };
  }

  RoutePredicate popUntilMainMenuPredicate() {
    return (route) {
      if (route is GetPageRoute) {
        if (route.settings.arguments is MainMenuRouteArgument) {
          return true;
        }
      }
      return false;
    };
  }

  RoutePredicate popUntilOrderPredicate() {
    return (route) {
      if (route is GetPageRoute) {
        if (route.settings.arguments is OrderRouteArgument) {
          return true;
        }
      }
      return false;
    };
  }

  RoutePredicate popUntilOneStepBelowNotificationRedirectorPredicate() {
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
    if (resultI > -1) {
      routeName = routeMap[routeKeyList[resultI]]?.route?.settings.name ?? "";
    }
    return (route) {
      if (route is GetPageRoute) {
        if (route.settings.name == routeName) {
          return true;
        }
      }
      return false;
    };
  }
}