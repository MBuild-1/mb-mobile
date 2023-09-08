import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:masterbagasi/misc/translation/default_extended_translation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'domain/usecase/get_cart_list_use_case.dart';
import 'domain/usecase/get_notification_by_user_list_use_case.dart';
import 'firebase_options.dart';

import 'domain/usecase/get_user_use_case.dart';
import 'misc/constant.dart';
import 'misc/getextended/extended_get_material_app.dart';
import 'misc/injector.dart';
import 'misc/login_helper.dart';
import 'misc/main_route_observer.dart';
import 'presentation/notifier/login_notifier.dart';
import 'presentation/notifier/component_notifier.dart';
import 'presentation/notifier/notification_notifier.dart';
import 'presentation/page/introduction_page.dart';
import 'presentation/page/mainmenu/main_menu_page.dart';

void main() async {
  Injector.init();
  WidgetsFlutterBinding.ensureInitialized();
  if (kDebugMode) {
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  await Hive.openBox(Constant.settingHiveTable);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent
  ));
  OneSignal.initialize("1eb5f7ad-4784-4ec2-95e0-f6fbcb1dc9b5");
  OneSignal.Notifications.requestPermission(true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme.apply(fontFamily: "Roboto");
    textTheme = textTheme.copyWith(
      headline1: textTheme.headline1?.copyWith(color: Constant.colorTitle),
      headline2: textTheme.headline2?.copyWith(color: Constant.colorTitle),
      headline3: textTheme.headline3?.copyWith(color: Constant.colorTitle),
      headline4: textTheme.headline4?.copyWith(color: Constant.colorTitle),
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginNotifier>(
          create: (_) => LoginNotifier(Injector.locator<GetUserUseCase>()),
        ),
        ChangeNotifierProvider<ComponentNotifier>(
          create: (_) => ComponentNotifier(),
        ),
        ChangeNotifierProvider<NotificationNotifier>(
          create: (_) => NotificationNotifier(
            getNotificationByUserListUseCase: Injector.locator<GetNotificationByUserListUseCase>(),
            getCartListUseCase: Injector.locator<GetCartListUseCase>(),
          ),
        )
      ],
      child: Sizer(
        builder: (context, orientation, deviceType) => ExtendedGetMaterialApp(
          navigatorObservers: [MainRouteObserver],
          debugShowCheckedModeBanner: false,
          title: 'MasterBagasi',
          smartManagement: SmartManagement.onlyBuilder,
          onGenerateRoute: (routeSettings) {
            if (routeSettings.name == "/") {
              if (LoginHelper.getTokenWithBearer().result.isNotEmptyString) {
                return MainMenuPageRestorableRouteFuture.getRoute();
              } else {
                return IntroductionPageRestorableRouteFuture.getRoute();
              }
            }
            return null;
          },
          defaultTransition: Transition.topLevel,
          translations: DefaultExtendedTranslation(),
          locale: Locale(Constant.textInIdLanguageKey),
          theme: ThemeData(
            indicatorColor: Constant.colorMain,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Constant.colorMain,
            ).copyWith(
              primary: Constant.colorMain,
              secondary: Constant.colorMain
            ),
            textTheme: textTheme,
            primaryTextTheme: textTheme,
            dividerTheme: DividerThemeData(
              color: Constant.colorDivider,
              thickness: 1.0
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              unselectedItemColor: Constant.colorBottomNavigationBarIconAndLabel,
            ),
            tabBarTheme: TabBarTheme(
              labelColor: Constant.colorMain,
              unselectedLabelColor: Constant.colorTabUnselected
            )
          ),
          localizationsDelegates: const [
            GlobalWidgetsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
        ),
      )
    );
  }
}