import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../../domain/entity/user/user.dart';
import '../../misc/deeplink_applink_helper.dart';
import '../../misc/getextended/get_extended.dart';
import '../../misc/load_data_result.dart';
import '../../misc/login_helper.dart';
import '../../misc/main_route_observer.dart';
import '../../misc/notification_redirector_helper.dart';
import '../../misc/pusher_helper.dart';
import '../../misc/routeargument/help_chat_route_argument.dart';
import '../../misc/routeargument/order_chat_route_argument.dart';
import '../../misc/routeargument/product_chat_route_argument.dart';
import '../../misc/selected_language_helper.dart';
import '../../misc/widgetbindingobserver/locale_widget_binding_observer.dart';
import '../notifier/login_notifier.dart';
import '../notifier/notification_notifier.dart';

class SomethingCounter extends StatefulWidget {
  // ignore: library_private_types_in_public_api
  static _SomethingCounterState? of(BuildContext context) {
    return context.findAncestorStateOfType<_SomethingCounterState>();
  }

  final Widget child;

  const SomethingCounter({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<SomethingCounter> createState() => _SomethingCounterState();
}

class _SomethingCounterState extends State<SomethingCounter> with RestorationMixin {
  final RestorableRouteKeyMap routeKeyMap = RestorableRouteKeyMap();
  late LoginNotifier _loginNotifier;
  late NotificationNotifier _notificationNotifier;

  final PusherChannelsFlutter _pusher = PusherChannelsFlutter.getInstance();
  LocaleWidgetBindingObserver? _localeWidgetBindingObserver;

  @override
  void initState() {
    super.initState();
    _localeWidgetBindingObserver = LocaleWidgetBindingObserver(
      onUpdateWhileDeviceLocaleIsChange: () {
        String selectedLanguageLocaleString = SelectedLanguageHelper.getSelectedLanguage().result;
        if (selectedLanguageLocaleString.isEmpty) {
          updateLanguage();
        }
      }
    );
    WidgetsBinding.instance.addObserver(_localeWidgetBindingObserver!);
    DeeplinkApplinkHelper.initURIHandler(
      mounted: () => mounted,
      onSetState: () => setState(() {})
    );
    DeeplinkApplinkHelper.incomingLinkHandler(
      mounted: () => mounted,
      onSetState: () => setState(() {})
    );
    _loginNotifier = Provider.of<LoginNotifier>(context, listen: false);
    _notificationNotifier = Provider.of<NotificationNotifier>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      LoginHelper.checkingLogin(context, () async {
        LoadDataResult<User> userLoadDataResult = await _loginNotifier.loadUser();
        if (userLoadDataResult.isSuccess) {
          await subscribeChatCount(userLoadDataResult.resultIfSuccess!.id);
          await subscribeNotificationCount(userLoadDataResult.resultIfSuccess!.id);
        }
      });
    });
    PusherHelper.initPusherChannels(
      pusherChannelsFlutter: _pusher
    );
    _initOneSignalEvent();
  }

  void _initOneSignalEvent() {
    OneSignal.Notifications.addClickListener(_onClickListener);
    OneSignal.Notifications.addForegroundWillDisplayListener(_onForegroundWillDisplayListener);
  }

  void _onClickListener(OSNotificationClickEvent osNotificationClickEvent) {
    Map<String, dynamic>? additionalData = osNotificationClickEvent.notification.additionalData;
    var notificationRedirectorMap = NotificationRedirectorHelper.notificationRedirectorMap;
    if (additionalData != null) {
      if (additionalData.containsKey("type")) {
        String type = additionalData["type"];
        if (notificationRedirectorMap.containsKey(type)) {
          if (MainRouteObserver.routeMap.isNotEmpty) {
            String currentRoute = MainRouteObserver.getCurrentRoute();
            if (MainRouteObserver.onRedirectFromNotificationClick[currentRoute] != null) {
              MainRouteObserver.onRedirectFromNotificationClick[currentRoute]!(additionalData);
            }
          }
        }
      }
    }
  }

  void _onForegroundWillDisplayListener(OSNotificationWillDisplayEvent osNotificationWillDisplayEvent) {
    osNotificationWillDisplayEvent.preventDefault();
    Map<String, dynamic>? additionalData = osNotificationWillDisplayEvent.notification.additionalData;
    if (additionalData != null) {
      if (additionalData.containsKey("type")) {
        bool checkingForChat(bool Function(dynamic) onCheckingChatArgument) {
          if (MainRouteObserver.routeMap.isNotEmpty) {
            String currentRoute = MainRouteObserver.getCurrentRoute();
            if (MainRouteObserver.routeMap.containsKey(currentRoute)) {
              var argument = MainRouteObserver.routeMap[currentRoute]?.route?.settings.arguments;
              if (onCheckingChatArgument(argument)) {
                return true;
              }
            }
          }
          return false;
        }
        String type = additionalData["type"];
        if (type == "chat-help") {
          if (checkingForChat((argument) => argument is HelpChatRouteArgument)) {
            return;
          }
        } else if (type == "chat-order") {
          if (checkingForChat((argument) => argument is OrderChatRouteArgument)) {
            return;
          }
        } else if (type == "chat-product") {
          if (checkingForChat((argument) => argument is ProductChatRouteArgument)) {
            return;
          }
        }
      }
    }
    osNotificationWillDisplayEvent.notification.display();
  }

  Future<void> subscribeChatCount(String userId) async {
    try {
      await PusherHelper.subscribeChatCountPusherChannel(
        pusherChannelsFlutter: _pusher,
        onEvent: (event) {
          _notificationNotifier.loadInboxLoadDataResult();
        },
        userId: userId
      );
    } catch (e) {
      // Nothing
    }
  }

  Future<void> unsubscribeChatCount(String userId) async {
    try {
      await PusherHelper.unsubscribeChatCountPusherChannel(
        pusherChannelsFlutter: _pusher,
        userId: userId
      );
    } catch (e) {
      // Nothing
    }
  }

  Future<void> subscribeNotificationCount(String userId) async {
    try {
      await PusherHelper.subscribeNotificationCountPusherChannel(
        pusherChannelsFlutter: _pusher,
        onEvent: (event) {
          _notificationNotifier.loadNotificationLoadDataResult();
        },
        userId: userId
      );
    } catch (e) {
      // Nothing
    }
  }

  Future<void> unsubscribeNotificationCount(String userId) async {
    try {
      await PusherHelper.unsubscribeNotificationCountPusherChannel(
        pusherChannelsFlutter: _pusher,
        userId: userId
      );
    } catch (e) {
      // Nothing
    }
  }

  void updateLanguage() {
    Locale? deviceLocale = GetExtended.deviceLocale;
    if (deviceLocale != null) {
      Get.updateLocale(deviceLocale);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  String? get restorationId => "something-counter";

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(routeKeyMap, 'route-key-map');
    MainRouteObserver.applyNewRouteMapFromRouteKeyMap(routeKeyMap.value.key);
  }

  @override
  void dispose() {
    _pusher.disconnect();
    OneSignal.Notifications.removeClickListener(_onClickListener);
    OneSignal.Notifications.removeForegroundWillDisplayListener(_onForegroundWillDisplayListener);
    DeeplinkApplinkHelper.dispose();
    if (_localeWidgetBindingObserver != null) {
      WidgetsBinding.instance.removeObserver(_localeWidgetBindingObserver!);
      _localeWidgetBindingObserver = null;
    }
    super.dispose();
  }
}

class RestorableRouteKeyMap extends RestorableValue<RouteKeyMapValue> {
  @override
  RouteKeyMapValue createDefaultValue() => RouteKeyMapValue(key: {});

  @override
  void didUpdateValue(RouteKeyMapValue? oldValue) {
    notifyListeners();
  }

  @override
  RouteKeyMapValue fromPrimitives(Object? data) {
    //print("FROM PRIMITIVE: $data");
    List<String> key = (data as String).split("|");
    Map<String, int> result = {};
    for (int i = 0; i < key.length; i++) {
      result[key[i]] = 1;
    }
    return RouteKeyMapValue(key: result);
  }

  @override
  Object? toPrimitives() {
    String result = "";
    int i = 0;
    value.key.forEach((key, value) {
      result += "${(i > 0 ? "|" : "")}$key";
      i++;
    });
    //print("TO PRIMITIVE: $result");
    return result;
  }
}

class RouteKeyMapValue {
  Map<String, int> key;

  RouteKeyMapValue({
    required this.key
  });

  RouteKeyMapValue copy({
    Map<String, int>? key
  }) {
    return RouteKeyMapValue(
      key: key ?? this.key
    );
  }
}