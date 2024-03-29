import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:masterbagasi/presentation/page/product_detail_page.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

import '../../../controller/base_getx_controller.dart';
import '../../../controller/mainmenucontroller/main_menu_controller.dart';
import '../../../controller/mainmenucontroller/mainmenusubpagecontroller/explore_nusantara_main_menu_sub_controller.dart';
import '../../../controller/mainmenucontroller/mainmenusubpagecontroller/feed_main_menu_sub_controller.dart';
import '../../../controller/mainmenucontroller/mainmenusubpagecontroller/home_main_menu_sub_controller.dart';
import '../../../controller/mainmenucontroller/mainmenusubpagecontroller/menu_main_menu_sub_controller.dart';
import '../../../controller/mainmenucontroller/mainmenusubpagecontroller/wishlist_main_menu_sub_controller.dart';
import '../../../domain/usecase/get_help_message_by_user_use_case.dart';
import '../../../misc/constant.dart';
import '../../../misc/device_helper.dart';
import '../../../misc/getextended/get_extended.dart';
import '../../../misc/getextended/get_restorable_route_future.dart';
import '../../../misc/injector.dart';
import '../../../misc/login_helper.dart';
import '../../../misc/main_route_observer.dart';
import '../../../misc/manager/controller_manager.dart';
import '../../../misc/multi_language_string.dart';
import '../../../misc/page_restoration_helper.dart';
import '../../../misc/routeargument/main_menu_route_argument.dart';
import '../../../misc/toast_helper.dart';
import '../../../misc/typedef.dart';
import '../../notifier/product_notifier.dart';
import '../../widget/custom_bottom_navigation_bar.dart';
import '../../widget/modified_scaffold.dart';
import '../../widget/modified_svg_picture.dart';
import '../../widget/rx_consumer.dart';
import '../../widget/tap_area.dart';
import '../accountsecurity/account_security_page.dart';
import '../address_page.dart';
import '../affiliate_page.dart';
import '../cart_page.dart';
import '../country_delivery_review_page.dart';
import '../deliveryreview/delivery_review_page.dart';
import '../edit_profile_page.dart';
import '../favorite_product_brand_page.dart';
import '../help_chat_page.dart';
import '../help_page.dart';
import '../inbox_page.dart';
import '../login_page.dart';
import '../getx_page.dart';
import '../modify_address_page.dart';
import '../msme_partner_page.dart';
import '../newspage/news_detail_page.dart';
import '../newspage/news_page.dart';
import '../notification_page.dart';
import '../order_detail_page.dart';
import '../order_page.dart';
import '../product_brand_page.dart';
import '../product_bundle_detail_page.dart';
import '../product_bundle_page.dart';
import '../product_category_detail_page.dart';
import '../product_category_page.dart';
import '../product_discussion_page.dart';
import '../product_entry_page.dart';
import '../search_page.dart';
import '../shared_cart_page.dart';
import '../videopage/video_page.dart';
import '../web_viewer_page.dart';
import 'mainmenusubpage/explore_nusantara_sub_main_menu_page.dart';
import 'mainmenusubpage/feed_main_menu_sub_page.dart';
import 'mainmenusubpage/home_main_menu_sub_page.dart';
import 'mainmenusubpage/mbestie_main_menu_sub_page.dart';
import 'mainmenusubpage/menu_main_menu_sub_page.dart';
import 'mainmenusubpage/wishlist_main_menu_sub_page.dart';

class MainMenuPage extends RestorableGetxPage<_MainMenuPageRestoration> {
  late final ControllerMember<MainMenuController> _mainMenuController = ControllerMember<MainMenuController>().addToControllerManager(controllerManager);
  late final List<List<dynamic>> _mainMenuSubControllerList;

  MainMenuPage({Key? key}) : super(key: key, pageRestorationId: () => "main-menu-page") {
    _mainMenuSubControllerList = [
      [
        ControllerMember<HomeMainMenuSubController>().addToControllerManager(controllerManager),
        () => Injector.locator<HomeMainMenuSubControllerInjectionFactory>().inject(controllerManager, pageName),
        () {
          void Function()? onRefresh = MainRouteObserver.controllerMediatorMap[Constant.subPageKeyHomeMainMenu];
          if (onRefresh != null) {
            onRefresh();
          }
        },
        () => MainRouteObserver.subMainMenuVisibility[Constant.subPageKeyHomeMainMenu] = false,
        () => MainRouteObserver.subMainMenuVisibility[Constant.subPageKeyHomeMainMenu] = true,
      ],
      [
        ControllerMember<FeedMainMenuSubController>().addToControllerManager(controllerManager),
        () => Injector.locator<FeedMainMenuSubControllerInjectionFactory>().inject(controllerManager, pageName),
        () {
          void Function()? onRefresh = MainRouteObserver.controllerMediatorMap[Constant.subPageKeyFeedMainMenu];
          if (onRefresh != null) {
            onRefresh();
          }
        },
        () => MainRouteObserver.subMainMenuVisibility[Constant.subPageKeyFeedMainMenu] = false,
        () => MainRouteObserver.subMainMenuVisibility[Constant.subPageKeyFeedMainMenu] = true
      ],
      [
        ControllerMember<ExploreNusantaraMainMenuSubController>().addToControllerManager(controllerManager),
        () => Injector.locator<ExploreNusantaraMainMenuSubControllerInjectionFactory>().inject(controllerManager, pageName),
        () {
          void Function()? onRefresh = MainRouteObserver.controllerMediatorMap[Constant.subPageKeyExploreNusantaraMainMenu];
          if (onRefresh != null) {
            onRefresh();
          }
        },
        () => MainRouteObserver.subMainMenuVisibility[Constant.subPageKeyExploreNusantaraMainMenu] = false,
        () => MainRouteObserver.subMainMenuVisibility[Constant.subPageKeyExploreNusantaraMainMenu] = true
      ],
      [
        ControllerMember<MenuMainMenuSubController>().addToControllerManager(controllerManager),
        () => Injector.locator<MenuMainMenuSubControllerInjectionFactory>().inject(controllerManager, pageName),
        () {
          void Function()? onRefresh = MainRouteObserver.controllerMediatorMap[Constant.subPageKeyMBestieMainMenu];
          if (onRefresh != null) {
            onRefresh();
          }
        },
        () => MainRouteObserver.subMainMenuVisibility[Constant.subPageKeyMBestieMainMenu] = false,
        () => MainRouteObserver.subMainMenuVisibility[Constant.subPageKeyMBestieMainMenu] = true
      ],
      [
        ControllerMember<WishlistMainMenuSubController>().addToControllerManager(controllerManager),
        () => Injector.locator<WishlistMainMenuSubControllerInjectionFactory>().inject(controllerManager, pageName),
        () {
          void Function()? onRefresh = MainRouteObserver.controllerMediatorMap[Constant.subPageKeyWishlistMainMenu];
          if (onRefresh != null) {
            onRefresh();
          }
        },
        () => MainRouteObserver.subMainMenuVisibility[Constant.subPageKeyWishlistMainMenu] = false,
        () => MainRouteObserver.subMainMenuVisibility[Constant.subPageKeyWishlistMainMenu] = true
      ],
      [
        ControllerMember<MenuMainMenuSubController>().addToControllerManager(controllerManager),
        () => Injector.locator<MenuMainMenuSubControllerInjectionFactory>().inject(controllerManager, pageName),
        () {
          void Function()? onRefresh = MainRouteObserver.controllerMediatorMap[Constant.subPageKeyMenuMainMenu];
          if (onRefresh != null) {
            onRefresh();
          }
        },
        () => MainRouteObserver.subMainMenuVisibility[Constant.subPageKeyMenuMainMenu] = false,
        () => MainRouteObserver.subMainMenuVisibility[Constant.subPageKeyMenuMainMenu] = true
      ]
    ];
  }

  @override
  void onSetController() {
    _mainMenuController.controller = GetExtended.put<MainMenuController>(
      MainMenuController(
        controllerManager,
        Injector.locator<GetHelpMessageByUserUseCase>()
      ),
      tag: pageName
    );
    for (var mainMenuSubController in _mainMenuSubControllerList) {
      (mainMenuSubController[0] as ControllerMember).controller = (mainMenuSubController[1] as GetControllerFromGetPut)();
    }
  }

  @override
  _MainMenuPageRestoration createPageRestoration() => _MainMenuPageRestoration(
    onCompleteAddressPage: (result) {
      if (result != null) {
        if (result) {
          if (MainRouteObserver.onRefreshAddress != null) {
            MainRouteObserver.onRefreshAddress!();
          }
          if (MainRouteObserver.onRefreshSelectAddress != null) {
            MainRouteObserver.onRefreshSelectAddress!();
          }
        }
      }
    },
    onCompleteEditProfilePage: (result) {
      if (result != null) {
        if (result) {
          if (MainRouteObserver.onRefreshProfile != null) {
            MainRouteObserver.onRefreshProfile!();
          }
        }
      }
    },
  );

  @override
  void onLoginChange() {
    _mainMenuController.controller.checkLoginStatus(reset: true);
    for (var mainMenuSubController in _mainMenuSubControllerList) {
      mainMenuSubController[2]();
    }
  }

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulMainMenuControllerMediatorWidget(
      mainMenuController: _mainMenuController.controller,
      mainMenuSubControllerList: _mainMenuSubControllerList,
      pageName: pageName,
    );
  }
}

class _MainMenuPageRestoration extends ExtendedMixableGetxPageRestoration with MainMenuPageRestorationMixin, LoginPageRestorationMixin, ProductEntryPageRestorationMixin, ProductDetailPageRestorationMixin, ProductCategoryDetailPageRestorationMixin, ProductBundlePageRestorationMixin, ProductBundleDetailPageRestorationMixin, ProductBrandPageRestorationMixin, WebViewerPageRestorationMixin, OrderPageRestorationMixin, DeliveryReviewPageRestorationMixin, FavoriteProductBrandPageRestorationMixin, ProductDiscussionPageRestorationMixin, MainMenuPageRestorationMixin, AddressPageRestorationMixin, AffiliatePageRestorationMixin, MsmePartnerPageRestorationMixin, CountryDeliveryReviewPageRestorationMixin, HelpPageRestorationMixin, HelpChatPageRestorationMixin, SearchPageRestorationMixin, VideoPageRestorationMixin, NewsPageRestorationMixin, NewsDetailPageRestorationMixin, AccountSecurityPageRestorationMixin, SharedCartPageRestorationMixin, EditProfilePageRestorationMixin, ProductCategoryPageRestorationMixin, OrderDetailPageRestorationMixin {
  final RouteCompletionCallback<bool?>? _onCompleteAddressPage;
  final RouteCompletionCallback<bool?>? _onCompleteEditProfilePage;

  _MainMenuPageRestoration({
    RouteCompletionCallback<bool?>? onCompleteAddressPage,
    RouteCompletionCallback<bool?>? onCompleteEditProfilePage
  }) : _onCompleteAddressPage = onCompleteAddressPage,
      _onCompleteEditProfilePage = onCompleteEditProfilePage;

  @override
  // ignore: unnecessary_overrides
  void initState() {
    onCompleteSelectAddress = _onCompleteAddressPage;
    onCompleteEditProfile = _onCompleteEditProfilePage;
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

mixin MainMenuPageRestorationMixin on MixableGetxPageRestoration {
  late MainMenuPageRestorableRouteFuture mainMenuPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    mainMenuPageRestorableRouteFuture = MainMenuPageRestorableRouteFuture(restorationId: restorationIdWithPageName('main-menu-page-route'));
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    mainMenuPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    mainMenuPageRestorableRouteFuture.dispose();
  }
}

class MainMenuPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  @override
  GetPageBuilder get pageBuilder => (() => MainMenuPage());

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(MainMenuPage()));
}

class MainMenuPageRestorableRouteFuture extends GetRestorableRouteFuture {
  late RestorableRouteFuture<void> _pageRoute;

  MainMenuPageRestorableRouteFuture({required String restorationId}) : super(restorationId: restorationId) {
    _pageRoute = RestorableRouteFuture<void>(
      onPresent: PageRestorationHelper.onPresentWithPushModeAndTransitionModeParameter(
        onNavigatorRestorablePushAndRemoveUntil: (navigator, arguments) => navigator.restorablePushAndRemoveUntil(_pageRouteBuilder, (route) => false, arguments: arguments),
        onNavigatorRestorablePush: (navigator, arguments) => navigator.restorablePush(_pageRouteBuilder, arguments: arguments),
      )
    );
  }

  static Route<void>? getRoute([Object? arguments]) {
    return PageRestorationHelper.getRouteWithPushModeAndTransitionModeParameter(
      arguments: arguments,
      onPassingAdditionalArguments: () => MainMenuRouteArgument(),
      onBuildRestorableGetxPageBuilder: () => GetxPageBuilder.buildRestorableGetxPageBuilder(MainMenuPageGetPageBuilderAssistant())
    );
  }

  @pragma('vm:entry-point')
  static Route<void> _pageRouteBuilder(BuildContext context, Object? arguments) {
    return getRoute(arguments)!;
  }

  @override
  bool checkBeforePresent([Object? arguments]) => getRoute(arguments) != null;

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

class _StatefulMainMenuControllerMediatorWidget extends StatefulWidget {
  final MainMenuController mainMenuController;
  final List<List<dynamic>> mainMenuSubControllerList;
  final String pageName;

  const _StatefulMainMenuControllerMediatorWidget({
    required this.mainMenuController,
    required this.mainMenuSubControllerList,
    required this.pageName
  });

  @override
  State<_StatefulMainMenuControllerMediatorWidget> createState() => _StatefulMainMenuControllerMediatorWidgetState();
}

class _StatefulMainMenuControllerMediatorWidgetState extends State<_StatefulMainMenuControllerMediatorWidget> {
  late CustomBottomNavigationBarSelectedIndex _customBottomNavigationBarSelectedIndex;
  Timer? _timer;
  bool _canBack = false;
  late ProductNotifier _productNotifier;

  @override
  void initState() {
    super.initState();
    DeviceHelper.initVersioningNotifierAndCheckUpdate(context);
    _productNotifier = Provider.of<ProductNotifier>(context, listen: false);
    _initMainMenuPage();
    MainRouteObserver.onResetInitMainMenu = () {
      _productNotifier.loadData();
      _initMainMenuPage();
      for (int i = 0; i < widget.mainMenuSubControllerList.length; i++) {
        widget.mainMenuSubControllerList[i][2]();
      }
      setState(() {});
      widget.mainMenuController.checkLoginStatus(reset: true);
    };
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      DeviceHelper.requestTrackingAuthorization();
    });
  }

  void _initMainMenuPage() {
    _onItemTapped(
      CustomBottomNavigationBarSelectedIndex(
        currentSelectedViewMenuIndex: 0,
        currentSelectedMenuIndex: 0
      )
    );
    MainRouteObserver.onChangeMainMenuTap = (index) => _onItemTappedWithContext(
      CustomBottomNavigationBarSelectedIndex(
        currentSelectedMenuIndex: index,
        currentSelectedViewMenuIndex: index
      ),
      context
    );
    for (int i = 0; i < widget.mainMenuSubControllerList.length; i++) {
      if (i == 0) {
        widget.mainMenuSubControllerList[i][4]();
        continue;
      }
      widget.mainMenuSubControllerList[i][3]();
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.mainMenuController.setMainMenuDelegate(
      MainMenuDelegate(
        onGetLoginStatus: () => LoginHelper.getTokenWithBearer().result.isNotEmptyString
      )
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.mainMenuController.checkLoginStatus();
    });
    Widget bottomNavigationIcon(Widget icon) {
      return SizedBox(
        width: 20,
        height: 20,
        child: icon
      );
    }
    return WillPopScope(
      onWillPop: () async {
        if (_canBack) {
          return true;
        } else {
          if (_timer != null) {
            _timer?.cancel();
          }
          _timer = Timer(
            const Duration(milliseconds: 1000),
            () => _canBack = false
          );
          _canBack = true;
          ToastHelper.showToast("Press again to exit".tr);
        }
        return false;
      },
      child: Material(
        child: ModifiedScaffoldContainer(
          body: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    IndexedStack(
                      index: _customBottomNavigationBarSelectedIndex.currentSelectedViewMenuIndex,
                      children: [
                        HomeMainMenuSubPage(ancestorPageName: widget.pageName),
                        FeedMainMenuSubPage(ancestorPageName: widget.pageName),
                        ExploreNusantaraMainMenuSubPage(ancestorPageName: widget.pageName),
                        MBestieMainMenuSubPage(ancestorPageName: widget.pageName),
                        WishlistMainMenuSubPage(ancestorPageName: widget.pageName),
                        MenuMainMenuSubPage(ancestorPageName: widget.pageName),
                      ],
                    ),
                    Builder(
                      builder: (context) {
                        void login() => PageRestorationHelper.toLoginPage(context, Constant.restorableRouteFuturePush);
                        return Align(
                          alignment: Alignment.bottomCenter,
                          child: RxConsumer<bool>(
                            rxValue: widget.mainMenuController.isLoginRx,
                            onConsumeValue: (context, isLogin) => !isLogin ? Container(
                              padding: EdgeInsets.all(Constant.paddingListItem),
                              height: Constant.mainMenuFooterHeight,
                              color: Colors.transparent,
                              child: Stack(
                                children: [
                                  Builder(
                                    builder: (context) {
                                      return Align(
                                        alignment: Alignment.centerLeft,
                                        child: SizedBox(
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              const SizedBox(
                                                width: 80.0
                                              ),
                                              Expanded(
                                                child: TapArea(
                                                  onTap: login,
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                                    child: Text.rich(
                                                      "Miss Indonesian Food".trTextSpan(),
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(10.0).copyWith(
                                                        topLeft: Radius.zero,
                                                        bottomLeft: Radius.zero
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          blurRadius: 5.0,
                                                          spreadRadius: 1.0,
                                                          color: Colors.black.withOpacity(0.5)
                                                        )
                                                      ]
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: TapArea(
                                      onTap: login,
                                      child: Container(
                                        width: 80,
                                        height: Constant.mainMenuFooterContentHeight,
                                        padding: const EdgeInsets.all(8.0),
                                        child: ModifiedSvgPicture.asset(Constant.vectorBag, overrideDefaultColorWithSingleColor: false),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10.0),
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 5.0,
                                              spreadRadius: 1.0,
                                              color: Colors.black.withOpacity(0.5)
                                            )
                                          ]
                                        ),
                                      ),
                                    ),
                                  )
                                ]
                              ),
                            ) : Container(),
                          ),
                        );
                      }
                    ),
                  ],
                )
              ),
              CustomBottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: _customBottomNavigationBarSelectedIndex.currentSelectedMenuIndex,
                selectedFontSize: 9.0,
                unselectedFontSize: 9.0,
                onTap: (selectedIndex) => _onItemTappedWithContext(selectedIndex, context),
                items: [
                  CustomBottomNavigationBarItem(
                    icon: bottomNavigationIcon(ModifiedSvgPicture.asset(Constant.vectorHomeUnselected, overrideDefaultColorWithSingleColor: false)),
                    activeIcon: bottomNavigationIcon(ModifiedSvgPicture.asset(Constant.vectorHomeSelected, overrideDefaultColorWithSingleColor: false)),
                    label: 'Home',
                    hideLabelWhenInactive: false,
                  ),
                  CustomBottomNavigationBarItem(
                    icon: bottomNavigationIcon(ModifiedSvgPicture.asset(Constant.vectorFeedUnselected, overrideDefaultColorWithSingleColor: false)),
                    activeIcon: bottomNavigationIcon(ModifiedSvgPicture.asset(Constant.vectorFeedSelected, overrideDefaultColorWithSingleColor: false)),
                    label: MultiLanguageString({
                      Constant.textInIdLanguageKey: "Sajian",
                      Constant.textEnUsLanguageKey: "Feed"
                    }).toStringNonNull,
                    hideLabelWhenInactive: false
                  ),
                  CustomBottomNavigationBarItem(
                    icon: bottomNavigationIcon(ModifiedSvgPicture.asset(Constant.vectorExploreUnselected, overrideDefaultColorWithSingleColor: false)),
                    activeIcon: bottomNavigationIcon(ModifiedSvgPicture.asset(Constant.vectorExploreSelected, overrideDefaultColorWithSingleColor: false)),
                    label: "Nusantara",
                    hideLabelWhenInactive: false
                  ),
                  CustomBottomNavigationBarItem(
                    icon: bottomNavigationIcon(ModifiedSvgPicture.asset(Constant.vectorMBestieUnselected, overrideDefaultColorWithSingleColor: false)),
                    activeIcon: bottomNavigationIcon(ModifiedSvgPicture.asset(Constant.vectorMBestieSelected, overrideDefaultColorWithSingleColor: false)),
                    label: "MBestie",
                    hideLabelWhenInactive: false
                  ),
                  CustomBottomNavigationBarItem(
                    icon: bottomNavigationIcon(ModifiedSvgPicture.asset(Constant.vectorWishlistUnselected, overrideDefaultColorWithSingleColor: false)),
                    activeIcon: bottomNavigationIcon(ModifiedSvgPicture.asset(Constant.vectorWishlistSelected, overrideDefaultColorWithSingleColor: false)),
                    label: 'Wishlist',
                    hideLabelWhenInactive: false
                  ),
                  CustomBottomNavigationBarItem(
                    icon: bottomNavigationIcon(ModifiedSvgPicture.asset(Constant.vectorMenuUnselected, overrideDefaultColorWithSingleColor: false)),
                    activeIcon: bottomNavigationIcon(ModifiedSvgPicture.asset(Constant.vectorMenuSelected, overrideDefaultColorWithSingleColor: false)),
                    label: 'Menu',
                    hideLabelWhenInactive: false
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onItemTapped(CustomBottomNavigationBarSelectedIndex selectedIndex) {
    _customBottomNavigationBarSelectedIndex = selectedIndex;
    _firstInitTabChildWidget(selectedIndex);
  }

  void _onItemTappedWithContext(CustomBottomNavigationBarSelectedIndex selectedIndex, BuildContext context) {
    _customBottomNavigationBarSelectedIndex = selectedIndex;
    _firstInitTabChildWidget(selectedIndex);
    _setWidgetVisibilityToTrue(selectedIndex);
    setState(() {});
  }

  void _firstInitTabChildWidget(CustomBottomNavigationBarSelectedIndex selectedIndex) {
    int selectedViewIndex = selectedIndex.currentSelectedViewMenuIndex;
    dynamic controller = (widget.mainMenuSubControllerList[selectedViewIndex][0] as ControllerMember).controller;
    if (controller is BaseGetxController) {
      if (!controller.hasInitController()) {
        controller.initController();
      }
    }
  }

  void _setWidgetVisibilityToTrue(CustomBottomNavigationBarSelectedIndex selectedIndex) {
    int selectedViewIndex = selectedIndex.currentSelectedViewMenuIndex;
    widget.mainMenuSubControllerList[selectedViewIndex][4]();
  }

  @override
  void dispose() {
    MainRouteObserver.onRefreshAddress = null;
    MainRouteObserver.onRefreshProfile = null;
    MainRouteObserver.onRefreshWishlistInMainMenu = null;
    MainRouteObserver.onChangeSelectedProvince = null;
    MainRouteObserver.onResetInitMainMenu = null;
    MainRouteObserver.onRefreshSelectAddress = null;
    _timer?.cancel();
    super.dispose();
  }
}