import 'package:flutter/material.dart';
import 'package:masterbagasi/misc/ext/navigator_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../domain/entity/order/order.dart';
import '../presentation/page/product_detail_page.dart';
import 'main_route_observer.dart';
import 'page_restoration_helper.dart';
import 'routeargument/login_route_argument.dart';
import 'routeargument/main_menu_route_argument.dart';
import 'routeargument/order_detail_route_argument.dart';
import 'routeargument/order_route_argument.dart';
import 'routeargument/product_detail_route_argument.dart';
import 'routeargument/product_discussion_route_argument.dart';

class _NavigationHelperImpl {
  void navigationToProductDetailFromProductDiscussion(BuildContext context, ProductDetailPageParameter productDetailPageParameter) {
    Map<String, RouteWrapper?> routeMap = MainRouteObserver.routeMap;
    List<String> routeKeyList = List.of(routeMap.keys);
    int i = 0;
    int? beforeI;
    if (routeKeyList.isNotEmpty) {
      i = routeKeyList.length - 1;
      var arguments = routeMap[routeKeyList[i]]?.route?.settings.arguments;
      if (arguments is ProductDiscussionRouteArgument) {
        beforeI = i - 1;
      }
    }
    if (beforeI != null) {
      while (beforeI! > -1) {
        RouteSettings? routeSettings = routeMap[routeKeyList[beforeI]]?.route?.settings;
        String routeName = routeSettings!.name ?? "";
        var arguments = routeSettings.arguments;
        if (arguments is ProductDetailRouteArgument) {
          Navigator.of(context).popUntil((route) => route.settings.name == routeName);
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            if (MainRouteObserver.onScrollUpIfInProductDetail.containsKey(routeName)) {
              MainRouteObserver.onScrollUpIfInProductDetail[routeName]!();
            }
          });
          return;
        }
        beforeI -= 1;
      }
    }
    PageRestorationHelper.toProductDetailPage(context, productDetailPageParameter);
  }

  void navigationAfterPurchaseProcess(BuildContext context, Order order) {
    navigationAfterPurchaseProcessWithCombinedOrderIdParameter(context, order.combinedOrder.id);
  }

  void navigationAfterPurchaseProcessWithCombinedOrderIdParameter(BuildContext context, String combinedOrderId) {
    Map<String, RouteWrapper?> routeMap = MainRouteObserver.routeMap;
    List<String> routeKeyList = List.of(routeMap.keys);
    int i = 0;
    int? beforeI;
    for (var element in routeMap.entries) {
      var arguments = element.value?.route?.settings.arguments;
      if (arguments is MainMenuRouteArgument) {
        beforeI = i + 1;
        break;
      }
      i++;
    }
    String mainMenuRouteKey = routeKeyList[i];
    while (true) {
      if (beforeI != null) {
        if (beforeI >= 0) {
          String routeKey = routeKeyList[beforeI];
          Route<dynamic>? targetRoute = routeMap[routeKey]?.route;
          if (targetRoute != null) {
            if (!targetRoute.settings.name.isEmptyString) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                //MaterialIgnorePointer.of(context)?.ignoring = true;
                String targetRouteName = (targetRoute.settings.name).toEmptyStringNonNull;
                MainRouteObserver.disposingEventRouteMap[targetRouteName] = () {
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                    BuildContext Function()? buildContextEventFunction = MainRouteObserver.buildContextEventRouteMap[mainMenuRouteKey];
                    if (buildContextEventFunction != null) {
                      BuildContext mainMenuBuildContext = buildContextEventFunction();
                      //MaterialIgnorePointer.of(mainMenuBuildContext)?.ignoring = false;
                      PageRestorationHelper.toOrderDetailPage(mainMenuBuildContext, combinedOrderId);
                    }
                    MainRouteObserver.disposingEventRouteMap[targetRouteName] = null;
                  });
                };
              });
              Navigator.of(context).popUntilMainMenu();
              break;
            }
          }
          beforeI += 1;
        } else {
          break;
        }
      } else {
        break;
      }
    }
  }

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

  void navigationBackFromOrderDetailToOrder(BuildContext context) {
    Map<String, RouteWrapper?> routeMap = MainRouteObserver.routeMap;
    List<String> routeKeyList = List.of(routeMap.keys);
    int i = 0;
    int tempI = -1;
    int tempIBefore = -1;
    bool foundOrderDetail = false;
    for (var element in routeMap.entries) {
      element.value?.requestLoginChangeValue = 1;
      var arguments = element.value?.route?.settings.arguments;
      if (arguments is OrderDetailRouteArgument) {
        tempI = i;
        tempIBefore = tempI - i;
        foundOrderDetail = true;
        break;
      }
      i++;
    }
    if (!foundOrderDetail) {
      return;
    }
    bool allowToPopUntilOrder = false;
    if (tempI > -1) {
      while (tempI >= 0) {
        String iteratedRouteKey = routeKeyList[tempI];
        RouteWrapper? iteratedRouteWrapper = routeMap[iteratedRouteKey];
        if (iteratedRouteWrapper != null) {
          var arguments = iteratedRouteWrapper.route?.settings.arguments;
          if (arguments is OrderRouteArgument) {
            allowToPopUntilOrder = true;
            break;
          }
        }
        tempI -= 1;
      }
    }
    if (allowToPopUntilOrder) {
      Navigator.of(context).popUntilOrder();
    } else {
      if (tempIBefore > -1) {
        String routeKey = routeKeyList[tempIBefore];
        RouteWrapper? routeWrapper = routeMap[routeKey];
        if (routeWrapper != null) {
          Navigator.of(context).popUntil(
            (route) => route.settings.name == routeWrapper.route?.settings.name
          );
        }
      }
    }
  }
}

// ignore: non_constant_identifier_names
final _NavigationHelperImpl NavigationHelper = _NavigationHelperImpl();