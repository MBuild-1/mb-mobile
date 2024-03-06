import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';
import 'main_route_observer.dart';
import 'notification_redirector_helper.dart';
import 'routeargument/reset_password_route_argument.dart';


class _DeeplinkApplinkHelperImpl {
  Uri? _initialURI;
  Uri? get initialURI => _initialURI;

  Uri? _currentURI;
  Uri? get currentURI => _currentURI;

  Object? _err;
  Object? get err => _err;

  bool _initialURILinkHandled = false;
  bool get initialURILinkHandled => _initialURILinkHandled;

  StreamSubscription? _streamSubscription;

  Future<void> initURIHandler({
    required bool Function() mounted,
    required void Function() onSetState
  }) async {
    if (!_initialURILinkHandled) {
      _initialURILinkHandled = true;
      try {
        final initialURI = await getInitialUri();
        if (initialURI != null) {
          _debugPrint("Initial URI received $initialURI");
          if (!mounted()) {
            return;
          }
          _initialURI = initialURI;
          onSetState();
          await Future.delayed(const Duration(milliseconds: 300));
          handlingUri(initialURI);
        } else {
          _debugPrint("Null Initial URI received");
        }
      } on PlatformException {
        _debugPrint("Failed to receive initial uri");
      } on FormatException catch (err) {
        if (!mounted()) {
          return;
        }
        _debugPrint('Malformed Initial URI received');
        _err = err;
        onSetState();
      }
    }
  }

  void incomingLinkHandler({
    required bool Function() mounted,
    required void Function() onSetState
  }) {
    if (!kIsWeb) {
      _streamSubscription = uriLinkStream.listen((Uri? uri) {
        if (!mounted()) {
          return;
        }
        _debugPrint('Received URI: $uri');
        _currentURI = uri;
        _err = null;
        onSetState();
        handlingUri(uri);
      },
      onError: (Object err) {
        _debugPrint('Error occurred: $err');
        if (!mounted()) {
          return;
        }
        _currentURI = null;
        if (err is FormatException) {
          _err = err;
        } else {
          _err = null;
        }
      });
    }
  }

  void handlingUri(Uri? uri) {
    if (uri != null) {
      String urlString = uri.toString();
      late Map<String, dynamic> additionalData;
      if (urlString.contains("/api/auth/apple")) {
        String link = urlString;
        additionalData = {
          "type": "login-with-apple-callback",
          "data": {
            "link": link
          }
        };
      } else if (urlString.contains("/reset-password/check-code")) {
        if (uri.pathSegments.isNotEmpty) {
          // Check if reset password is exist
          for (MapEntry<String, RouteWrapper?> routeMapEntry in MainRouteObserver.routeMap.entries) {
            var argument = routeMapEntry.value?.route?.settings.arguments;
            if (argument is ResetPasswordRouteArgument) {
              return;
            }
          }
          additionalData = {
            "type": "reset-password",
            "data": {
              "code": uri.pathSegments.last,
              "type": "email",
            }
          };
        } else {
          return;
        }
      } else if (urlString.contains("/product/category")) {
        String category = uri.pathSegments.last;
        additionalData = {
          "type": "product-category",
          "data": {
            "category": category
          }
        };
      } else if (urlString.contains("/product/brand")) {
        String brand = uri.pathSegments.last;
        additionalData = {
          "type": "product-brand",
          "data": {
            "brand": brand
          }
        };
      } else if (urlString.contains("/product/bundling")) {
        if (uri.queryParameters.containsKey("slug")) {
          String slug = uri.queryParameters["slug"]!;
          additionalData = {
            "type": "product-bundle-detail",
            "data": {
              "product_bundle_slug": slug
            }
          };
        }
      } else if (urlString.contains("/product/details")) {
        if (uri.queryParameters.containsKey("slug")) {
          String slug = uri.queryParameters["slug"]!;
          additionalData = {
            "type": "product-detail",
            "data": {
              "product_slug": slug
            }
          };
        }
      } else if (urlString.contains("/user/order")) {
        if (uri.queryParameters.containsKey("id")) {
          String combinedOrderId = uri.queryParameters["id"]!;
          additionalData = {
            "type": "order-detail",
            "data": {
              "combined_order_id": combinedOrderId
            }
          };
        } else {
          additionalData = {
            "type": "order"
          };
        }
      } else {
        if (uri.queryParameters.containsKey("code")) {
          String countryCode = uri.queryParameters["code"]!;
          additionalData = {
            "type": "check-rates-for-various-countries",
            "data": {
              "country_code": countryCode
            }
          };
        } else {
          return;
        }
      }
      var notificationRedirectorMap = NotificationRedirectorHelper.notificationRedirectorMap;
      if (notificationRedirectorMap.containsKey(additionalData["type"])) {
        if (MainRouteObserver.routeMap.isNotEmpty) {
          String currentRoute = MainRouteObserver.getCurrentRoute();
          if (MainRouteObserver.onRedirectFromNotificationClick[currentRoute] != null) {
            MainRouteObserver.onRedirectFromNotificationClick[currentRoute]!(additionalData);
          }
        }
      }
    }
  }

  void _debugPrint(String message) {
    if (kDebugMode) {
      print(message);
    }
  }

  void dispose() {
    _streamSubscription?.cancel();
  }
}

// ignore: non_constant_identifier_names
final _DeeplinkApplinkHelperImpl DeeplinkApplinkHelper = _DeeplinkApplinkHelperImpl();