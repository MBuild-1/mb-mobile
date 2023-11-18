import 'package:flutter/material.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../../domain/entity/user/user.dart';
import '../../misc/load_data_result.dart';
import '../../misc/login_helper.dart';
import '../../misc/main_route_observer.dart';
import '../../misc/page_restoration_helper.dart';
import '../../misc/pusher_helper.dart';
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

  @override
  void initState() {
    super.initState();
    _loginNotifier = Provider.of<LoginNotifier>(context, listen: false);
    _notificationNotifier = Provider.of<NotificationNotifier>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      LoginHelper.checkingLogin(context, () async {
        LoadDataResult<User> userLoadDataResult = await _loginNotifier.loadUser();
        if (userLoadDataResult.isSuccess) {
          subscribeChatCount(userLoadDataResult.resultIfSuccess!.id);
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
    print("Notification clik: ${osNotificationClickEvent.notification.jsonRepresentation()}");
  }

  void _onForegroundWillDisplayListener(OSNotificationWillDisplayEvent osNotificationWillDisplayEvent) {
    /// Display Notification, preventDefault to not display
    osNotificationWillDisplayEvent.preventDefault();

    /// notification.display() to display after preventing default
    osNotificationWillDisplayEvent.notification.display();

    print("Notification clik foreground: ${osNotificationWillDisplayEvent.notification.jsonRepresentation()}");
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