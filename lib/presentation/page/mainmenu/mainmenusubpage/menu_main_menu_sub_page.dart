import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:masterbagasi/misc/controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../controller/mainmenucontroller/mainmenusubpagecontroller/menu_main_menu_sub_controller.dart';
import '../../../../domain/entity/user/user.dart';
import '../../../../misc/additionalloadingindicatorchecker/menu_main_menu_sub_additional_paging_result_parameter_checker.dart';
import '../../../../misc/carouselbackground/carousel_background.dart';
import '../../../../misc/constant.dart';
import '../../../../misc/controllercontentdelegate/shared_cart_controller_content_delegate.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/builder_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/compound_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/load_data_result_dynamic_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/menu_profile_header_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/no_content_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/profilemenulistitemcontrollerstate/profile_dropdown_menu_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/profilemenulistitemcontrollerstate/profile_menu_group_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/profilemenulistitemcontrollerstate/profile_menu_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/spacing_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/title_and_description_list_item_controller_state.dart';
import '../../../../misc/controllerstate/paging_controller_state.dart';
import '../../../../misc/dialog_helper.dart';
import '../../../../misc/entityandlistitemcontrollerstatemediator/horizontal_component_entity_parameterized_entity_and_list_item_controller_state_mediator.dart';
import '../../../../misc/errorprovider/error_provider.dart';
import '../../../../misc/injector.dart';
import '../../../../misc/load_data_result.dart';
import '../../../../misc/login_helper.dart';
import '../../../../misc/main_route_observer.dart';
import '../../../../misc/manager/controller_manager.dart';
import '../../../../misc/on_observe_load_product_delegate.dart';
import '../../../../misc/page_restoration_helper.dart';
import '../../../../misc/paging/modified_paging_controller.dart';
import '../../../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../../../misc/paging/pagingresult/paging_data_result.dart';
import '../../../../misc/paging/pagingresult/paging_result.dart';
import '../../../../misc/parameterizedcomponententityandlistitemcontrollerstatemediatorparameter/carousel_background_parameterized_entity_and_list_item_controller_state_mediator_parameter.dart';
import '../../../../misc/parameterizedcomponententityandlistitemcontrollerstatemediatorparameter/cart_refresh_delegate_parameterized_entity_and_list_item_controller_state_mediator_parameter.dart';
import '../../../../misc/parameterizedcomponententityandlistitemcontrollerstatemediatorparameter/horizontal_dynamic_item_carousel_parametered_component_entity_and_list_item_controller_state_mediator_parameter.dart';
import '../../../../misc/string_util.dart';
import '../../../../misc/typedef.dart';
import '../../../../misc/web_helper.dart';
import '../../../../misc/widget_helper.dart';
import '../../../notifier/notification_notifier.dart';
import '../../../widget/background_app_bar_scaffold.dart';
import '../../../widget/loaddataresultimplementer/load_data_result_implementer_directly.dart';
import '../../../widget/menu_profile_header.dart';
import '../../../widget/modified_paged_list_view.dart';
import '../../../widget/modified_shimmer.dart';
import '../../../widget/modified_svg_picture.dart';
import '../../../widget/modifiedappbar/default_search_app_bar.dart';
import '../../../widget/modifiedappbar/modified_app_bar.dart' hide TitleInterceptor;
import '../../../widget/modifiedappbar/opacity_modified_app_bar.dart';
import '../../../widget/notification_number_indicator.dart';
import '../../../widget/number_indicator.dart';
import '../../../widget/rx_consumer.dart';
import '../../../widget/something_counter.dart';
import '../../../widget/tap_area.dart';
import '../../../widget/titleanddescriptionitem/title_and_description_item.dart';
import '../../getx_page.dart';
import '../../inbox_page.dart';
import '../../modaldialogpage/select_language_modal_dialog_page.dart';
import '../../product_discussion_page.dart';

class MenuMainMenuSubPage extends DefaultGetxPage {
  late final ControllerMember<MenuMainMenuSubController> _menuMainMenuSubController = ControllerMember<MenuMainMenuSubController>().addToControllerManager(controllerManager);
  final String ancestorPageName;

  MenuMainMenuSubPage({Key? key, required this.ancestorPageName}) : super(key: key);

  @override
  void onSetController() {
    _menuMainMenuSubController.controller = Injector.locator<MenuMainMenuSubControllerInjectionFactory>().inject(controllerManager, ancestorPageName);
  }

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulMenuMainMenuSubControllerMediatorWidget(
      menuMainMenuSubController: _menuMainMenuSubController.controller
    );
  }
}

class _StatefulMenuMainMenuSubControllerMediatorWidget extends StatefulWidget {
  final MenuMainMenuSubController menuMainMenuSubController;

  const _StatefulMenuMainMenuSubControllerMediatorWidget({
    required this.menuMainMenuSubController
  });

  @override
  State<_StatefulMenuMainMenuSubControllerMediatorWidget> createState() => _StatefulMenuMainMenuSubControllerMediatorWidgetState();
}

class _StatefulMenuMainMenuSubControllerMediatorWidgetState extends State<_StatefulMenuMainMenuSubControllerMediatorWidget> {
  late final ModifiedPagingController<int, ListItemControllerState> _menuMainMenuSubListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _menuMainMenuSubListItemPagingControllerState;
  final List<BaseLoadDataResultDynamicListItemControllerState> _dynamicItemLoadDataResultDynamicListItemControllerStateList = [];
  late AssetImage _menuAppBarBackgroundAssetImage;
  LoadDataResult<PackageInfo> _packageInfoLoadDataResult = NoLoadDataResult<PackageInfo>();

  @override
  void initState() {
    super.initState();
    _menuAppBarBackgroundAssetImage = AssetImage(Constant.imagePatternMenuMainMenuAppBar);
    _menuMainMenuSubListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.menuMainMenuSubController.apiRequestManager,
      additionalPagingResultParameterChecker: Injector.locator<MenuMainMenuSubAdditionalPagingResultParameterChecker>()
    );
    _menuMainMenuSubListItemPagingControllerState = PagingControllerState(
      pagingController: _menuMainMenuSubListItemPagingController,
      isPagingControllerExist: false
    );
    _menuMainMenuSubListItemPagingControllerState.pagingController.addPageRequestListenerForLoadDataResult(
      listener: _wishlistMainMenuListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _menuMainMenuSubListItemPagingControllerState.isPagingControllerExist = true;
    MainRouteObserver.controllerMediatorMap[Constant.subPageKeyMenuMainMenu] = refreshMenuMainMenu;
    MainRouteObserver.onRefreshProfile = refreshMenuMainMenu;
    _loadVersion();
  }

  void _loadVersion() async {
    _packageInfoLoadDataResult = IsLoadingLoadDataResult<PackageInfo>();
    setState(() {});
    _packageInfoLoadDataResult = await PackageInfo.fromPlatform().getLoadDataResult();
    setState(() {});
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _wishlistMainMenuListItemPagingControllerStateListener(int pageKey) async {
    bool isLogin = false;
    LoginHelper.checkingLogin(
      context,
      () => isLogin = true,
      resultIfHasNotBeenLogin: () {}
    );
    if (!isLogin) {
      return SuccessLoadDataResult<PagingResult<ListItemControllerState>>(
        value: PagingDataResult<ListItemControllerState>(
          page: 1,
          totalPage: 1,
          totalItem: 1,
          itemList: [NoContentListItemControllerState()]
        )
      );
    }
    HorizontalComponentEntityParameterizedEntityAndListItemControllerStateMediator componentEntityMediator = Injector.locator<HorizontalComponentEntityParameterizedEntityAndListItemControllerStateMediator>();
    HorizontalDynamicItemCarouselParameterizedEntityAndListItemControllerStateMediatorParameter carouselParameterizedEntityMediator = HorizontalDynamicItemCarouselParameterizedEntityAndListItemControllerStateMediatorParameter(
      onSetState: () => setState(() {}),
      dynamicItemLoadDataResultDynamicListItemControllerStateList: _dynamicItemLoadDataResultDynamicListItemControllerStateList
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.menuMainMenuSubController.loadLoggedUser();
    });
    ListItemControllerState shortCartListItemControllerState = componentEntityMediator.mapWithParameter(
      widget.menuMainMenuSubController.getMyCart(),
      parameter: carouselParameterizedEntityMediator
    );
    ProfileDropdownMenuListItemControllerState profileDropdownListItemControllerState = ProfileDropdownMenuListItemControllerState(
      onUpdateState: () => setState(() {}),
      isExpand: true,
      title: "",
      profileMenuListItemControllerStateList: [],
    );
    return SuccessLoadDataResult<PagingResult<ListItemControllerState>>(
      value: PagingDataResult<ListItemControllerState>(
        page: 1,
        totalPage: 1,
        totalItem: 1,
        itemList: [
          BuilderListItemControllerState(
            buildListItemControllerState: () {
              double paddingVertical = 12.0;
              EdgeInsetsGeometry? menuPadding = EdgeInsets.symmetric(horizontal: 4.w, vertical: paddingVertical);
              Widget menuTitleInterceptor(title, style) {
                return Text(
                  title,
                  style: style?.copyWith(fontWeight: FontWeight.w600)
                );
              }
              Widget menuIcon(dynamic iconAsset) {
                return SizedBox(
                  height: 20.0,
                  child: () {
                    if (iconAsset is String) {
                      return ModifiedSvgPicture.asset(
                        iconAsset,
                        width: 20.0
                      );
                    } else if (iconAsset is Widget Function(double)) {
                      return iconAsset(20.0);
                    }
                    return const SizedBox();
                  }()
                );
              }
              profileDropdownListItemControllerState.title = 'Regarding Master Bagasi'.tr;
              profileDropdownListItemControllerState.headerPadding = menuPadding;
              profileDropdownListItemControllerState.profileMenuListItemControllerStateList = [
                ProfileMenuListItemControllerState(
                  onTap: (context) {
                    WebHelper.launchUrl(Uri.parse("https://m.masterbagasi.com/about-us"));
                  },
                  icon: (BuildContext context) => menuIcon(Constant.vectorAboutMasterbagasi),
                  title: 'About Master Bagasi'.tr,
                  titleInterceptor: menuTitleInterceptor,
                  padding: menuPadding
                ),
                ProfileMenuListItemControllerState(
                  onTap: (context) {
                    WebHelper.launchUrl(Uri.parse("https://m.masterbagasi.com/mb-care"));
                  },
                  icon: (BuildContext context) => menuIcon((double size) => Icon(Icons.help_center, size: size)),
                  title: 'Master Bagasi Care'.tr,
                  titleInterceptor: menuTitleInterceptor,
                  padding: menuPadding
                ),
                ProfileMenuListItemControllerState(
                  onTap: (context) {
                    WebHelper.launchUrl(Uri.parse(Constant.textTermAndConditionsUrl));
                  },
                  icon: (BuildContext context) => menuIcon(Constant.vectorTermsAndConditions),
                  title: 'Terms & Conditions'.tr,
                  titleInterceptor: menuTitleInterceptor,
                  padding: menuPadding
                ),
                ProfileMenuListItemControllerState(
                  onTap: (context) {
                    WebHelper.launchUrl(Uri.parse(Constant.textPrivacyPolicyUrl));
                  },
                  icon: (BuildContext context) => menuIcon(Constant.vectorPrivacyPolicy),
                  title: 'Privacy Policy'.tr,
                  titleInterceptor: menuTitleInterceptor,
                  padding: menuPadding
                ),
                ProfileMenuListItemControllerState(
                  onTap: (context) {
                    WebHelper.launchUrl(Uri.parse("https://masterbagasi.com/contact-us"));
                  },
                  icon: (BuildContext context) => menuIcon((double size) => Icon(Icons.contact_support, size: size)),
                  title: 'Contact Us'.tr,
                  titleInterceptor: menuTitleInterceptor,
                  padding: menuPadding
                ),
                ProfileMenuListItemControllerState(
                  onTap: (context) async {
                    final InAppReview inAppReview = InAppReview.instance;
                    if (await inAppReview.isAvailable()) {
                      inAppReview.requestReview();
                    }
                  },
                  icon: (BuildContext context) => menuIcon(Constant.vectorReviewThisApplication),
                  title: 'Review This App'.tr,
                  titleInterceptor: menuTitleInterceptor,
                  padding: menuPadding
                ),
              ];
              return CompoundListItemControllerState(
                listItemControllerState: <ListItemControllerState>[
                  VirtualSpacingListItemControllerState(height: Constant.paddingListItem),
                  shortCartListItemControllerState,
                  VirtualSpacingListItemControllerState(height: Constant.paddingListItem),
                  SpacingListItemControllerState(),
                  ProfileMenuListItemControllerState(
                    onTap: (context) => PageRestorationHelper.toOrderPage(context),
                    icon: (BuildContext context) => menuIcon(Constant.vectorTransactionList),
                    title: 'Transaction List'.tr,
                    titleInterceptor: menuTitleInterceptor,
                    padding: menuPadding
                  ),
                  ProfileMenuListItemControllerState(
                    onTap: (context) {
                      void Function(int)? onChangeMainMenuTap = MainRouteObserver.onChangeMainMenuTap;
                      if (onChangeMainMenuTap != null) {
                        onChangeMainMenuTap(3);
                      }
                    },
                    icon: (BuildContext context) => menuIcon(Constant.vectorWishlist),
                    title: 'Wishlist'.tr,
                    titleInterceptor: menuTitleInterceptor,
                    padding: menuPadding
                  ),
                  ProfileMenuListItemControllerState(
                    onTap: (context) => PageRestorationHelper.toFavoriteProductBrandPage(context),
                    icon: (BuildContext context) => menuIcon(Constant.vectorFavoriteBrand),
                    title: 'Favorite Brand'.tr,
                    titleInterceptor: menuTitleInterceptor,
                    padding: menuPadding
                  ),
                  ProfileMenuListItemControllerState(
                    onTap: (context) => PageRestorationHelper.toHelpChatPage(context),
                    icon: (BuildContext context) => menuIcon(Constant.vectorInbox2),
                    title: 'Chat'.tr,
                    titleInterceptor: menuTitleInterceptor,
                    padding: menuPadding
                  ),
                  ProfileMenuListItemControllerState(
                    onTap: (context) => PageRestorationHelper.toProductDiscussionPage(
                      context, ProductDiscussionPageParameter(
                        productId: null,
                        bundleId: null,
                        discussionProductId: null,
                        isBasedUser: true
                      ),
                    ),
                    icon: (BuildContext context) => menuIcon(Constant.vectorProductDiscussion),
                    title: 'Product Discussion'.tr,
                    titleInterceptor: menuTitleInterceptor,
                    padding: menuPadding
                  ),
                  ProfileMenuListItemControllerState(
                    onTap: (context) => PageRestorationHelper.toDeliveryReviewPage(context),
                    icon: (BuildContext context) => menuIcon(Constant.vectorDeliveryShipping),
                    title: 'Delivery Review'.tr,
                    titleInterceptor: menuTitleInterceptor,
                    padding: menuPadding
                  ),
                  ProfileMenuListItemControllerState(
                    onTap: (context) => PageRestorationHelper.toNotificationPage(context),
                    icon: (BuildContext context) => menuIcon(Constant.vectorSupportMessage),
                    title: 'Update'.tr,
                    titleInterceptor: menuTitleInterceptor,
                    padding: menuPadding
                  ),
                  ProfileMenuListItemControllerState(
                    onTap: (context) => PageRestorationHelper.toInboxPage(
                      context, inboxPageParameter: InboxPageParameter(
                        showInboxMenu: false,
                        showFaq: true,
                        title: 'FAQ'.tr
                      )
                    ),
                    icon: (BuildContext context) => menuIcon(Constant.vectorFaq),
                    title: 'FAQ'.tr,
                    titleInterceptor: menuTitleInterceptor,
                    padding: menuPadding
                  ),
                  ProfileMenuListItemControllerState(
                    onTap: (context) => widget.menuMainMenuSubController.sharedCartControllerContentDelegate.checkSharedCart(),
                    icon: (BuildContext context) => menuIcon(Constant.vectorSharedCart),
                    title: 'Shared Cart'.tr,
                    titleInterceptor: menuTitleInterceptor,
                    padding: menuPadding
                  ),
                  ProfileMenuListItemControllerState(
                    onTap: (context) async {
                      dynamic result = await DialogHelper.showModalBottomDialogPage<int, int>(
                        context: context,
                        modalDialogPageBuilder: (context, parameter) => SelectLanguageModalDialogPage(),
                        parameter: 1
                      );
                      if (result is int) {
                        if (result == 1) {
                          DialogHelper.showLoadingDialog(context);
                          await Future.delayed(const Duration(milliseconds: 300));
                          SomethingCounter.of(context)?.updateLanguage();
                          Get.back();
                        }
                      }
                    },
                    icon: (BuildContext context) => menuIcon(Constant.vectorSelectLanguage),
                    title: 'Select Language'.tr,
                    titleInterceptor: menuTitleInterceptor,
                    padding: menuPadding
                  ),
                  SpacingListItemControllerState(),
                  VirtualSpacingListItemControllerState(
                    height: paddingVertical
                  ),
                  PaddingContainerListItemControllerState(
                    padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
                    paddingChildListItemControllerState: TitleAndDescriptionListItemControllerState(
                      title: "Account Configuration".tr,
                      titleInterceptor: (title, titleTextStyle) => Text(
                        title.toStringNonNull,
                        style: const TextStyle(fontWeight: FontWeight.bold)
                      )
                    ),
                  ),
                  VirtualSpacingListItemControllerState(
                    height: 5
                  ),
                  ProfileMenuListItemControllerState(
                    onTap: (context) => PageRestorationHelper.toAddressPage(context),
                    icon: (BuildContext context) => menuIcon(Constant.vectorAddressList),
                    title: 'Address List'.tr,
                    description: "${'Set the address for sending groceries'.tr}.",
                    titleInterceptor: menuTitleInterceptor,
                    padding: menuPadding
                  ),
                  ProfileMenuListItemControllerState(
                    onTap: (context) => PageRestorationHelper.toAccountSecurityPage(context),
                    icon: (BuildContext context) => menuIcon(Constant.vectorAccountSecurity),
                    title: 'Account Security'.tr,
                    description: "${'Password, PIN, and personal data verification'.tr}.",
                    titleInterceptor: menuTitleInterceptor,
                    padding: menuPadding
                  ),
                  ProfileMenuListItemControllerState(
                    onTap: (context) => DialogHelper.showPromptUnderConstruction(context),
                    icon: (BuildContext context) => menuIcon(Constant.vectorNotificationConfiguration),
                    title: 'Notification Configuration'.tr,
                    description: "${'Manage all kinds of notification messages'.tr}.",
                    titleInterceptor: menuTitleInterceptor,
                    padding: menuPadding
                  ),
                  ProfileMenuListItemControllerState(
                    onTap: (context) => DialogHelper.showPromptUnderConstruction(context),
                    icon: (BuildContext context) => menuIcon(Constant.vectorAccountPrivacy),
                    title: 'Account Privation'.tr,
                    description: "${'Manage data usage and connected accounts'.tr}.",
                    titleInterceptor: menuTitleInterceptor,
                    padding: menuPadding
                  ),
                  SpacingListItemControllerState(),
                  profileDropdownListItemControllerState,
                  SpacingListItemControllerState(),
                  ProfileMenuListItemControllerState(
                    onTap: (context) => DialogHelper.showPromptLogout(context, widget.menuMainMenuSubController.logout),
                    title: 'Sign Out'.tr,
                    titleInterceptor: (text, style) => Row(
                      children: [
                        Expanded(
                          child: menuTitleInterceptor(text, style),
                        ),
                        LoadDataResultImplementerDirectly(
                          loadDataResult: _packageInfoLoadDataResult,
                          errorProvider: Injector.locator<ErrorProvider>(),
                          onImplementLoadDataResultDirectly: (result, errorProvider) {
                            Widget? textWidget;
                            if (result.isSuccess) {
                              textWidget = Text(
                                "${"Version".tr} ${result.resultIfSuccess!.version}",
                                style: style?.copyWith(
                                  fontWeight: FontWeight.normal
                                )
                              );
                            } else if (result.isLoading) {
                              textWidget = ModifiedShimmer.fromColors(
                                child: Text(
                                  "${"Version".tr} 0.0.0",
                                  style: style?.copyWith(
                                    fontWeight: FontWeight.normal,
                                    backgroundColor: Colors.grey
                                  )
                                )
                              );
                            }
                            if (textWidget != null) {
                              return Row(
                                children: [
                                  const SizedBox(width: 10),
                                  textWidget
                                ],
                              );
                            } else {
                              return const SizedBox();
                            }
                          }
                        )
                      ],
                    ),
                    icon: (BuildContext context) => menuIcon(Constant.vectorLogout),
                    padding: menuPadding
                  ),
                ]
              );
            }
          )
        ]
      )
    );
  }

  @override
  void didChangeDependencies() {
    precacheImage(_menuAppBarBackgroundAssetImage, context);
    super.didChangeDependencies();
  }

  void refreshMenuMainMenu() {
    setState(() {});
    _menuMainMenuSubListItemPagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    OnObserveLoadProductDelegateFactory onObserveLoadProductDelegateFactory = Injector.locator<OnObserveLoadProductDelegateFactory>()
      ..onInjectLoadCartCarouselParameterizedEntity = (
        () => CartRefreshDelegateParameterizedEntityAndListItemControllerStateMediatorParameter(
          onGetRepeatableDynamicItemCarouselAdditionalParameter: (repeatableDynamicItemCarouselAdditionalParameter) {
            MainRouteObserver.onRefreshCartInMainMenu = () {
              repeatableDynamicItemCarouselAdditionalParameter.onRepeatLoading();
            };
          }
        )
      )
      ..onInjectCarouselParameterizedEntity = (
        (data) {
          Widget moreTapArea({
            void Function()? onTap,
            TextStyle Function(TextStyle)? onInterceptTextStyle
          }) {
            TextStyle textStyle = TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 12
            );
            return TapArea(
              onTap: onTap,
              child: Text(
                "More".tr,
                style: onInterceptTextStyle != null ? onInterceptTextStyle(textStyle) : textStyle
              ),
            );
          }
          Widget titleArea({
            required Widget title,
            void Function()? onTapMore,
            TextStyle Function(TextStyle)? onInterceptTextStyle
          }) {
            return Row(
              children: [
                Expanded(child: title),
                const SizedBox(width: 10),
                if (onTapMore != null) ...[
                  moreTapArea(
                    onTap: onTapMore,
                    onInterceptTextStyle: onInterceptTextStyle
                  )
                ]
              ],
            );
          }
          CarouselBackground? carouselBackground;
          TitleInterceptor? titleInterceptor;
          if (data == Constant.carouselKeyShortMyCart) {
            titleInterceptor = (text, style) => titleArea(
              title: Row(
                children: [
                  Flexible(
                    child: Text(
                      text.toStringNonNull,
                      style: style?.copyWith()
                    )
                  ),
                  const SizedBox(width: 8),
                  Consumer<NotificationNotifier>(
                    builder: (_, notificationNotifier, __) => NumberIndicator(
                      notificationNumber: notificationNotifier.cartLoadDataResult.resultIfSuccess ?? 0,
                      fontSize: 10,
                    )
                  )
                ],
              ),
              onInterceptTextStyle: (style) => style.copyWith(),
              onTapMore: () => PageRestorationHelper.toCartPage(context)
            );
          } else {
            titleInterceptor = (text, style) => Container();
          }
          return CarouselParameterizedEntityAndListItemControllerStateMediatorParameter(
            carouselBackground: carouselBackground,
            titleInterceptor: titleInterceptor
          );
        }
      );
    widget.menuMainMenuSubController.setMenuMainMenuSubDelegate(
      MenuMainMenuSubDelegate(
        onObserveLoadProductDelegate: onObserveLoadProductDelegateFactory.generateOnObserveLoadProductDelegate(),
        onObserveLoadLoggedUserDirectly: (onObserveLoadLoggedUserDirectlyParameter) {
          return MenuProfileHeaderListItemControllerState(
            userLoadDataResult: onObserveLoadLoggedUserDirectlyParameter.userLoadDataResult,
            errorProvider: Injector.locator<ErrorProvider>()
          );
        },
        onUnfocusAllWidget: () => FocusScope.of(context).unfocus(),
        onDeleteToken: () => LoginHelper.deleteToken().future(),
        onShowLogoutRequestProcessLoadingCallback: () async => DialogHelper.showLoadingDialog(context),
        onShowLogoutRequestProcessFailedCallback: (e) async => DialogHelper.showFailedModalBottomDialogFromErrorProvider(
          context: context,
          errorProvider: Injector.locator<ErrorProvider>(),
          e: e
        ),
        onLogoutRequestProcessSuccessCallback: () async {
          Provider.of<NotificationNotifier>(context, listen: false).resetNotification();
          if (MainRouteObserver.onResetInitMainMenu != null) {
            MainRouteObserver.onResetInitMainMenu!();
          }
        },
        onLogoutIntoOneSignal: () async {
          try {
            await OneSignal.logout();
            return SuccessLoadDataResult<String>(value: "");
          } catch (e, stackTrace) {
            return FailedLoadDataResult<String>(e: e, stackTrace: stackTrace);
          }
        },
        onUnsubscribeChatCountRealtimeChannel: (userId) async => await SomethingCounter.of(context)?.unsubscribeChatCount(userId),
        onUnsubscribeNotificationCountRealtimeChannel: (userId) async => await SomethingCounter.of(context)?.unsubscribeNotificationCount(userId),
      )
    );
    widget.menuMainMenuSubController.sharedCartControllerContentDelegate.setSharedCartDelegate(
      Injector.locator<SharedCartDelegateFactory>().generateSharedCartDelegate(
        onGetBuildContext: () => context,
        onGetErrorProvider: () => Injector.locator<ErrorProvider>()
      )
    );
    return WidgetHelper.checkVisibility(
      MainRouteObserver.subMainMenuVisibility[Constant.subPageKeyMenuMainMenu],
      () => Scaffold(
        body: WidgetHelper.checkingLogin(
          context,
          () => Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: _menuAppBarBackgroundAssetImage,
                    fit: BoxFit.cover
                  )
                ),
                child: Column(
                  children: [
                    OpacityModifiedAppBar(
                      value: 0.0,
                      titleInterceptor: (context, title) => Row(
                        children: [
                          Text(
                            "Main Menu".tr,
                            style: const TextStyle(
                              color: Colors.white
                            )
                          ),
                        ],
                      ),
                    ),
                    RxConsumer<LoadDataResultWrapper<User>>(
                      rxValue: widget.menuMainMenuSubController.userLoadDataResultWrapperRx,
                      onConsumeValue: (context, userLoadDataResultWrapper) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0).copyWith(top: 0.0),
                          child: MenuProfileHeader(
                            errorProvider: Injector.locator<ErrorProvider>(),
                            userLoadDataResult: userLoadDataResultWrapper.loadDataResult,
                          ),
                        );
                      },
                    ),
                  ],
                )
              ),
              Expanded(
                child: ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
                  pagingControllerState: _menuMainMenuSubListItemPagingControllerState,
                  onProvidePagedChildBuilderDelegate: (pagingControllerState) => ListItemPagingControllerStatePagedChildBuilderDelegate<int>(
                    pagingControllerState: pagingControllerState!
                  ),
                  pullToRefresh: true
                ),
              ),
            ],
          ),
          Injector.locator<ErrorProvider>(),
          withIndexedStack: true
        ),
      ),
    );
  }
}