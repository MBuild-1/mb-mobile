import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:masterbagasi/misc/controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../controller/mainmenucontroller/mainmenusubpagecontroller/menu_main_menu_sub_controller.dart';
import '../../../../domain/entity/user/user.dart';
import '../../../../misc/additionalloadingindicatorchecker/menu_main_menu_sub_additional_paging_result_parameter_checker.dart';
import '../../../../misc/carouselbackground/carousel_background.dart';
import '../../../../misc/constant.dart';
import '../../../../misc/controllercontentdelegate/shared_cart_controller_content_delegate.dart';
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
import '../../../../misc/widget_helper.dart';
import '../../../notifier/notification_notifier.dart';
import '../../../widget/background_app_bar_scaffold.dart';
import '../../../widget/menu_profile_header.dart';
import '../../../widget/modified_paged_list_view.dart';
import '../../../widget/modified_svg_picture.dart';
import '../../../widget/modifiedappbar/default_search_app_bar.dart';
import '../../../widget/modifiedappbar/modified_app_bar.dart' hide TitleInterceptor;
import '../../../widget/modifiedappbar/opacity_modified_app_bar.dart';
import '../../../widget/rx_consumer.dart';
import '../../../widget/tap_area.dart';
import '../../../widget/titleanddescriptionitem/title_and_description_item.dart';
import '../../getx_page.dart';
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
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _wishlistMainMenuListItemPagingControllerStateListener(int pageKey) async {
    HorizontalComponentEntityParameterizedEntityAndListItemControllerStateMediator componentEntityMediator = Injector.locator<HorizontalComponentEntityParameterizedEntityAndListItemControllerStateMediator>();
    HorizontalDynamicItemCarouselParameterizedEntityAndListItemControllerStateMediatorParameter carouselParameterizedEntityMediator = HorizontalDynamicItemCarouselParameterizedEntityAndListItemControllerStateMediatorParameter(
      onSetState: () => setState(() {}),
      dynamicItemLoadDataResultDynamicListItemControllerStateList: _dynamicItemLoadDataResultDynamicListItemControllerStateList
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.menuMainMenuSubController.loadLoggedUser();
    });
    return SuccessLoadDataResult<PagingResult<ListItemControllerState>>(
      value: PagingDataResult<ListItemControllerState>(
        page: 1,
        totalPage: 1,
        totalItem: 1,
        itemList: [
          VirtualSpacingListItemControllerState(height: Constant.paddingListItem),
          componentEntityMediator.mapWithParameter(
            widget.menuMainMenuSubController.getMyCart(),
            parameter: carouselParameterizedEntityMediator
          ),
          VirtualSpacingListItemControllerState(height: Constant.paddingListItem),
          SpacingListItemControllerState(),
          ProfileMenuListItemControllerState(
            onTap: (context) => PageRestorationHelper.toOrderPage(context),
            icon: (BuildContext context) => ModifiedSvgPicture.asset(Constant.vectorTransactionList, width: 20.0),
            title: 'Transaction List'.tr,
          ),
          ProfileMenuListItemControllerState(
            onTap: (context) {
              void Function(int)? onChangeMainMenuTap = MainRouteObserver.onChangeMainMenuTap;
              if (onChangeMainMenuTap != null) {
                onChangeMainMenuTap(3);
              }
            },
            icon: (BuildContext context) => ModifiedSvgPicture.asset(Constant.vectorWishlist, width: 20.0),
            title: 'Wishlist'.tr,
          ),
          ProfileMenuListItemControllerState(
            onTap: (context) => PageRestorationHelper.toFavoriteProductBrandPage(context),
            icon: (BuildContext context) => ModifiedSvgPicture.asset(Constant.vectorFavoriteBrand, width: 20.0),
            title: 'Favorite Brand'.tr,
          ),
          ProfileMenuListItemControllerState(
            onTap: (context) => PageRestorationHelper.toHelpChatPage(context),
            icon: (BuildContext context) => ModifiedSvgPicture.asset(Constant.vectorInbox2, width: 20.0),
            title: 'Chat'.tr,
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
            icon: (BuildContext context) => ModifiedSvgPicture.asset(Constant.vectorProductDiscussion, width: 20.0),
            title: 'Product Discussion'.tr,
          ),
          ProfileMenuListItemControllerState(
            onTap: (context) => PageRestorationHelper.toDeliveryReviewPage(context),
            icon: (BuildContext context) => ModifiedSvgPicture.asset(Constant.vectorDeliveryShipping, width: 20.0),
            title: 'Delivery Review'.tr,
          ),
          ProfileMenuListItemControllerState(
            onTap: (context) => PageRestorationHelper.toNotificationPage(context),
            icon: (BuildContext context) => ModifiedSvgPicture.asset(Constant.vectorSupportMessage, width: 20.0),
            title: 'Update'.tr,
          ),
          ProfileMenuListItemControllerState(
            onTap: (context) => widget.menuMainMenuSubController.sharedCartControllerContentDelegate.checkSharedCart(),
            icon: (BuildContext context) => ModifiedSvgPicture.asset(Constant.vectorCart, width: 20.0),
            title: 'Shared Cart'.tr,
          ),
          SpacingListItemControllerState(),
          VirtualSpacingListItemControllerState(
            height: Constant.paddingListItem
          ),
          PaddingContainerListItemControllerState(
            padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
            paddingChildListItemControllerState: TitleAndDescriptionListItemControllerState(
              title: "Application Configuration".tr,
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
            icon: (BuildContext context) => ModifiedSvgPicture.asset(Constant.vectorAddressList, width: 20.0),
            title: 'Address List'.tr,
            description: "${'Set the address for sending groceries'.tr}."
          ),
          ProfileMenuListItemControllerState(
            onTap: (context) => PageRestorationHelper.toAccountSecurityPage(context),
            icon: (BuildContext context) => ModifiedSvgPicture.asset(Constant.vectorAccountSecurity, width: 20.0),
            title: 'Account Security'.tr,
            description: "${'Password, PIN, and personal data verification'.tr}."
          ),
          ProfileMenuListItemControllerState(
            onTap: (context) => DialogHelper.showPromptUnderConstruction(context),
            icon: (BuildContext context) => ModifiedSvgPicture.asset(Constant.vectorNotificationConfiguration, width: 20.0),
            title: 'Notification Configuration'.tr,
            description: "${'Manage all kinds of notification messages'.tr}."
          ),
          ProfileMenuListItemControllerState(
            onTap: (context) => DialogHelper.showPromptUnderConstruction(context),
            icon: (BuildContext context) => ModifiedSvgPicture.asset(Constant.vectorAccountPrivacy, width: 20.0),
            title: 'Account Privation'.tr,
            description: "${'Manage data usage and connected accounts'.tr}."
          ),
          SpacingListItemControllerState(),
          ProfileDropdownMenuListItemControllerState(
            onUpdateState: () => setState(() {}),
            isExpand: false,
            title: 'Regarding MasterBagasi'.tr,
            profileMenuListItemControllerStateList: [
              ProfileMenuListItemControllerState(
                onTap: (context) {
                  PageRestorationHelper.toWebViewerPage(
                    context, <String, dynamic>{
                      Constant.textEncodedUrlKey: StringUtil.encodeBase64String("https://m.masterbagasi.com/about-us")
                    }
                  );
                },
                icon: (BuildContext context) => ModifiedSvgPicture.asset(Constant.vectorAboutMasterbagasi, width: 20.0),
                title: 'About MasterBagasi'.tr
              ),
              ProfileMenuListItemControllerState(
                onTap: (context) {
                  PageRestorationHelper.toWebViewerPage(
                    context, <String, dynamic>{
                      Constant.textEncodedUrlKey: StringUtil.encodeBase64String("https://m.masterbagasi.com/terms-and-conditions")
                    }
                  );
                },
                icon: (BuildContext context) => ModifiedSvgPicture.asset(Constant.vectorTermsAndConditions, width: 20.0),
                title: 'Terms & Conditions'.tr
              ),
              ProfileMenuListItemControllerState(
                onTap: (context) {
                  PageRestorationHelper.toWebViewerPage(
                    context, <String, dynamic>{
                      Constant.textEncodedUrlKey: StringUtil.encodeBase64String("https://m.masterbagasi.com/privacy-policy")
                    }
                  );
                },
                icon: (BuildContext context) => ModifiedSvgPicture.asset(Constant.vectorPrivacyPolicy, width: 20.0),
                title: 'Privacy Policy'.tr
              ),
              ProfileMenuListItemControllerState(
                onTap: (context) {
                  DialogHelper.showPromptUnderConstruction(context);
                },
                icon: (BuildContext context) => ModifiedSvgPicture.asset(Constant.vectorIntellectualPropertyRights, width: 20.0),
                title: 'Intellectual Rights and Property'.tr
              ),
              ProfileMenuListItemControllerState(
                onTap: (context) async {
                  final InAppReview inAppReview = InAppReview.instance;
                  if (await inAppReview.isAvailable()) {
                    inAppReview.requestReview();
                  }
                },
                icon: (BuildContext context) => ModifiedSvgPicture.asset(Constant.vectorReviewThisApplication, width: 20.0),
                title: 'Review This App'.tr
              ),
            ]
          ),
          SpacingListItemControllerState(),
          ProfileMenuListItemControllerState(
            onTap: (context) => widget.menuMainMenuSubController.logout(),
            title: 'Sign Out'.tr,
            icon: (BuildContext context) => ModifiedSvgPicture.asset(Constant.vectorLogout, width: 20.0, height: 13.0),
          ),
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
              title: Text(text.toStringNonNull, style: style?.copyWith()),
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
          PageRestorationHelper.toMainMenuPage(context, Constant.restorableRouteFuturePushAndRemoveUntil);
        }
      )
    );
    widget.menuMainMenuSubController.sharedCartControllerContentDelegate.setSharedCartDelegate(
      Injector.locator<SharedCartDelegateFactory>().generateSharedCartDelegate(
        onGetBuildContext: () => context,
        onGetErrorProvider: () => Injector.locator<ErrorProvider>()
      )
    );
    return Scaffold(
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
                        padding: const EdgeInsets.all(16.0),
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
        Injector.locator<ErrorProvider>()
      ),
    );
  }
}