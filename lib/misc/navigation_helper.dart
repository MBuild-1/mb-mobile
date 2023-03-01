import 'package:flutter/material.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import 'main_route_observer.dart';
import 'routeargument/login_route_argument.dart';

class _NavigationHelperImpl {
  void navigationAfterRegisterProcess(BuildContext context) {
    Map<String, RouteWrapper?> routeMap = MainRouteObserver.routeMap;
    List<String> routeKeyList = List.of(routeMap.keys);
    int i = 0;
    int? beforeI;
    for (var element in routeMap.entries) {
      element.value?.requestLoginChangeValue = 1;
      var arguments = element.value?.route?.settings.arguments;
      if (arguments is LoginRouteArgument) {
        beforeI = i - 1;
        break;
      }
      i++;
    }
    while (true) {
      if (beforeI != null) {
        if (beforeI >= 0) {
          String routeKey = routeKeyList[beforeI];
          Route<dynamic>? targetRoute = routeMap[routeKey]?.route;
          if (targetRoute != null) {
            if (!targetRoute.settings.name.isEmptyString) {
              String targetRouteName = (targetRoute.settings.name).toEmptyStringNonNull;
              Navigator.of(context).popUntil((route) => route.settings.name == targetRouteName);
              break;
            }
          }
          beforeI -= 1;
        } else {
          break;
        }
      } else {
        break;
      }
    }
  }
}

// ignore: non_constant_identifier_names
final _NavigationHelperImpl NavigationHelper = _NavigationHelperImpl();