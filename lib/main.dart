import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/translation/default_extended_translation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'domain/usecase/all_versioning_use_case.dart';
import 'domain/usecase/get_cart_list_use_case.dart';
import 'domain/usecase/get_help_message_notification_count_use_case.dart';
import 'domain/usecase/get_notification_by_user_list_use_case.dart';
import 'domain/usecase/get_wishlist_list_ignoring_login_error.dart';
import 'domain/usecase/login_or_register_with_apple_via_callback_use_case.dart';
import 'domain/usecase/third_party_login_visibility_use_case.dart';
import 'domain/usecase/versioning_based_filter_use_case.dart';
import 'firebase_options.dart';

import 'domain/usecase/get_user_use_case.dart';
import 'misc/constant.dart';
import 'misc/getextended/extended_get_material_app.dart';
import 'misc/getextended/get_extended.dart';
import 'misc/injector.dart';
import 'misc/main_route_observer.dart';
import 'presentation/notifier/login_notifier.dart';
import 'presentation/notifier/component_notifier.dart';
import 'presentation/notifier/notification_notifier.dart';
import 'presentation/notifier/product_notifier.dart';
import 'presentation/notifier/third_party_login_notifier.dart';
import 'presentation/notifier/versioning_notifier.dart';
import 'presentation/page/getx_page.dart';
import 'presentation/page/redirector_page.dart';

Future<void> main() async {
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
    TextTheme textTheme = Theme.of(context).textTheme.apply(
      fontFamily: "NunitoSans",
    );
    double? letterSpacing = -0.5;
    textTheme = textTheme.copyWith(
      displayLarge: textTheme.displayLarge?.copyWith(letterSpacing: letterSpacing),
      displayMedium: textTheme.displayMedium?.copyWith(letterSpacing: letterSpacing),
      displaySmall: textTheme.displaySmall?.copyWith(letterSpacing: letterSpacing),
      headlineLarge: textTheme.headlineLarge?.copyWith(letterSpacing: letterSpacing),
      headlineMedium: textTheme.headlineMedium?.copyWith(letterSpacing: letterSpacing),
      headlineSmall: textTheme.headlineSmall?.copyWith(letterSpacing: letterSpacing),
      titleLarge: textTheme.titleLarge?.copyWith(letterSpacing: letterSpacing),
      titleMedium: textTheme.titleMedium?.copyWith(letterSpacing: letterSpacing),
      titleSmall: textTheme.titleSmall?.copyWith(letterSpacing: letterSpacing),
      bodyLarge: textTheme.bodyLarge?.copyWith(letterSpacing: letterSpacing),
      bodyMedium: textTheme.bodyMedium?.copyWith(letterSpacing: letterSpacing),
      bodySmall: textTheme.bodySmall?.copyWith(letterSpacing: letterSpacing),
      labelLarge: textTheme.labelLarge?.copyWith(letterSpacing: letterSpacing),
      labelMedium: textTheme.labelMedium?.copyWith(letterSpacing: letterSpacing),
      labelSmall: textTheme.labelSmall?.copyWith(letterSpacing: letterSpacing),
    ).copyWith(
      headline1: textTheme.headline1?.copyWith(color: Constant.colorTitle, letterSpacing: letterSpacing),
      headline2: textTheme.headline2?.copyWith(color: Constant.colorTitle, letterSpacing: letterSpacing),
      headline3: textTheme.headline3?.copyWith(color: Constant.colorTitle, letterSpacing: letterSpacing),
      headline4: textTheme.headline4?.copyWith(color: Constant.colorTitle, letterSpacing: letterSpacing),
      headline5: textTheme.headline5?.copyWith(letterSpacing: letterSpacing),
      headline6: textTheme.headline6?.copyWith(letterSpacing: letterSpacing),
      subtitle1: textTheme.subtitle1?.copyWith(letterSpacing: letterSpacing),
      subtitle2: textTheme.subtitle2?.copyWith(letterSpacing: letterSpacing),
      bodyText1: textTheme.bodyText1?.copyWith(letterSpacing: letterSpacing),
      bodyText2: textTheme.bodyText2?.copyWith(letterSpacing: letterSpacing),
      caption: textTheme.caption?.copyWith(letterSpacing: letterSpacing),
      button: textTheme.button?.copyWith(letterSpacing: letterSpacing),
      overline: textTheme.overline?.copyWith(letterSpacing: letterSpacing),
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThirdPartyLoginNotifier>(
          create: (_) => ThirdPartyLoginNotifier(
            Injector.locator<ThirdPartyLoginVisibilityUseCase>()
          ),
        ),
        ChangeNotifierProvider<VersioningNotifier>(
          create: (_) => VersioningNotifier(
            Injector.locator<VersioningBasedFilterUseCase>()
          ),
        ),
        ChangeNotifierProvider<LoginNotifier>(
          create: (_) => LoginNotifier(
            Injector.locator<GetUserUseCase>(),
            Injector.locator<LoginOrRegisterWithAppleViaCallbackUseCase>()
          ),
        ),
        ChangeNotifierProvider<ComponentNotifier>(
          create: (_) => ComponentNotifier(),
        ),
        ChangeNotifierProvider<NotificationNotifier>(
          create: (_) => NotificationNotifier(
            getNotificationByUserListUseCase: Injector.locator<GetNotificationByUserListUseCase>(),
            getCartListUseCase: Injector.locator<GetCartListUseCase>(),
            getHelpMessageNotificationCountUseCase: Injector.locator<GetHelpMessageNotificationCountUseCase>()
          ),
        ),
        ChangeNotifierProvider<ProductNotifier>(
          create: (_) => ProductNotifier(
            getCartListUseCase: Injector.locator<GetCartListUseCase>(),
            getWishlistListIgnoringLoginErrorUseCase: Injector.locator<GetWishlistListIgnoringLoginErrorUseCase>(),
          ),
        )
      ],
      child: Sizer(
        builder: (context, orientation, deviceType) => ExtendedGetMaterialApp(
          navigatorObservers: [MainRouteObserver],
          debugShowCheckedModeBanner: false,
          title: 'MasterBagasi',
          smartManagement: SmartManagement.onlyBuilder,
          home: GetxPageBuilder.buildRestorableGetxPage(RedirectorPage()),
          defaultTransition: Transition.topLevel,
          translations: DefaultExtendedTranslation(),
          locale: GetExtended.deviceLocale,
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