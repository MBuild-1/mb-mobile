import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Banner;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/controllerstate/listitemcontrollerstate/builder_list_item_controller_state.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:masterbagasi/misc/parameterizedcomponententityandlistitemcontrollerstatemediatorparameter/wishlist_delegate_parameterized_entity_and_list_item_controller_state_mediator_parameter.dart';
import 'package:masterbagasi/presentation/page/product_entry_page.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../controller/mainmenucontroller/mainmenusubpagecontroller/home_main_menu_sub_controller.dart';
import '../../../../domain/entity/address/address.dart';
import '../../../../domain/entity/banner/banner.dart';
import '../../../../domain/entity/homemainmenucomponententity/banner_home_main_menu_component_entity.dart';
import '../../../../domain/entity/homemainmenucomponententity/home_main_menu_component_entity.dart';
import '../../../../domain/entity/homemainmenucomponententity/separator_home_main_menu_component_entity.dart';
import '../../../../domain/entity/location/location.dart';
import '../../../../misc/additionalloadingindicatorchecker/home_sub_additional_paging_result_parameter_checker.dart';
import '../../../../misc/aspect_ratio_value.dart';
import '../../../../misc/backgroundappbarscaffoldtype/color_background_app_bar_scaffold_type.dart';
import '../../../../misc/carouselbackground/asset_carousel_background.dart';
import '../../../../misc/carouselbackground/carousel_background.dart';
import '../../../../misc/carousellistitemtype/carousel_list_item_type.dart';
import '../../../../misc/carousellistitemtype/default_carousel_list_item_type.dart';
import '../../../../misc/carousellistitemtype/tile_carousel_list_item_Type.dart';
import '../../../../misc/constant.dart';
import '../../../../misc/controllercontentdelegate/wishlist_and_cart_controller_content_delegate.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/carousel_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/colorful_divider_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/column_container_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/compound_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/decorated_container_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/delivery_to_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/failed_prompt_indicator_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/load_data_result_dynamic_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/multi_banner_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/no_content_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/positioned_container_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/product_bundle_highlight_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/product_bundle_highlight_multiple_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/single_banner_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/stack_container_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/title_and_description_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/widget_substitution_list_item_controller_state.dart';
import '../../../../misc/controllerstate/paging_controller_state.dart';
import '../../../../misc/dialog_helper.dart';
import '../../../../misc/entityandlistitemcontrollerstatemediator/horizontal_component_entity_parameterized_entity_and_list_item_controller_state_mediator.dart';
import '../../../../misc/error/message_error.dart';
import '../../../../misc/errorprovider/error_provider.dart';
import '../../../../misc/injector.dart';
import '../../../../misc/load_data_result.dart';
import '../../../../misc/login_helper.dart';
import '../../../../misc/main_route_observer.dart';
import '../../../../misc/manager/controller_manager.dart';
import '../../../../misc/multi_language_string.dart';
import '../../../../misc/on_observe_load_product_delegate.dart';
import '../../../../misc/page_restoration_helper.dart';
import '../../../../misc/paging/modified_paging_controller.dart';
import '../../../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../../../misc/paging/pagingresult/paging_data_result.dart';
import '../../../../misc/paging/pagingresult/paging_result.dart';
import '../../../../misc/parameterizedcomponententityandlistitemcontrollerstatemediatorparameter/carousel_background_parameterized_entity_and_list_item_controller_state_mediator_parameter.dart';
import '../../../../misc/parameterizedcomponententityandlistitemcontrollerstatemediatorparameter/cart_delegate_parameterized_entity_and_list_item_controllere_state_mediator_parameter.dart';
import '../../../../misc/parameterizedcomponententityandlistitemcontrollerstatemediatorparameter/compound_parameterized_entity_and_list_item_controller_state_mediator.dart';
import '../../../../misc/parameterizedcomponententityandlistitemcontrollerstatemediatorparameter/horizontal_brand_appearance_parameterized_entity_and_list_item_controller_state_mediator_parameter.dart';
import '../../../../misc/parameterizedcomponententityandlistitemcontrollerstatemediatorparameter/horizontal_dynamic_item_carousel_parametered_component_entity_and_list_item_controller_state_mediator_parameter.dart';
import '../../../../misc/parameterizedcomponententityandlistitemcontrollerstatemediatorparameter/horizontal_product_appearance_parameterized_entity_and_list_item_controller_state_mediator_parameter.dart';
import '../../../../misc/parameterizedcomponententityandlistitemcontrollerstatemediatorparameter/parameterized_entity_and_list_item_controller_state_mediator_parameter.dart';
import '../../../../misc/shimmercarousellistitemgenerator/factory/product_bundle_shimmer_carousel_list_item_generator_factory.dart';
import '../../../../misc/shimmercarousellistitemgenerator/type/product_bundle_shimmer_carousel_list_item_generator_type.dart';
import '../../../../misc/widget_helper.dart';
import '../../../notifier/component_notifier.dart';
import '../../../notifier/notification_notifier.dart';
import '../../../notifier/product_notifier.dart';
import '../../../widget/background_app_bar_scaffold.dart';
import '../../../widget/button/custombutton/sized_outline_gradient_button.dart';
import '../../../widget/modified_paged_list_view.dart';
import '../../../widget/modified_shimmer.dart';
import '../../../widget/modifiedappbar/main_menu_search_app_bar.dart';
import '../../../widget/modifiedcachednetworkimage/transparent_banner_modified_cached_network_image.dart';
import '../../../widget/tap_area.dart';
import '../../../widget/titleanddescriptionitem/title_and_description_item.dart';
import '../../address_page.dart';
import '../../getx_page.dart';
import '../../modaldialogpage/check_rates_for_various_countries_modal_dialog_page.dart';
import '../../modaldialogpage/select_address_modal_dialog_page.dart';
import '../../modify_address_page.dart';
import '../../product_brand_page.dart';

class HomeMainMenuSubPage extends DefaultGetxPage {
  late final ControllerMember<HomeMainMenuSubController> _homeMainMenuSubController = ControllerMember<HomeMainMenuSubController>().addToControllerManager(controllerManager);
  final String ancestorPageName;

  HomeMainMenuSubPage({Key? key, required this.ancestorPageName}) : super(key: key, systemUiOverlayStyle: SystemUiOverlayStyle.light);

  @override
  void onSetController() {
    _homeMainMenuSubController.controller = Injector.locator<HomeMainMenuSubControllerInjectionFactory>().inject(controllerManager, ancestorPageName);
  }

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulHomeMainMenuSubControllerMediatorWidget(
      homeMainMenuSubController: _homeMainMenuSubController.controller
    );
  }
}

class _StatefulHomeMainMenuSubControllerMediatorWidget extends StatefulWidget {
  final HomeMainMenuSubController homeMainMenuSubController;

  const _StatefulHomeMainMenuSubControllerMediatorWidget({
    required this.homeMainMenuSubController
  });

  @override
  State<_StatefulHomeMainMenuSubControllerMediatorWidget> createState() => _StatefulHomeMainMenuSubControllerMediatorWidgetState();
}

class _StatefulHomeMainMenuSubControllerMediatorWidgetState extends State<_StatefulHomeMainMenuSubControllerMediatorWidget> {
  late final ModifiedPagingController<int, ListItemControllerState> _homeMainMenuSubListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _homeMainMenuSubListItemPagingControllerState;
  final List<BaseLoadDataResultDynamicListItemControllerState> _dynamicItemLoadDataResultDynamicListItemControllerStateList = [];

  late AssetImage _homeAppBarBackgroundAssetImage;
  Banner? _banner;
  final SelectAddressModalDialogPageActionDelegate selectAddressModalDialogPageActionDelegate = SelectAddressModalDialogPageActionDelegate();

  @override
  void initState() {
    super.initState();
    _homeAppBarBackgroundAssetImage = AssetImage(Constant.imagePatternHomeMainMenuAppBar);
    _homeMainMenuSubListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.homeMainMenuSubController.apiRequestManager,
      additionalPagingResultParameterChecker: Injector.locator<HomeSubAdditionalPagingResultParameterChecker>()
    );
    _homeMainMenuSubListItemPagingControllerState = PagingControllerState(
      pagingController: _homeMainMenuSubListItemPagingController,
      isPagingControllerExist: false
    );
    _homeMainMenuSubListItemPagingControllerState.pagingController.addPageRequestListenerForLoadDataResult(
      listener: _homeMainMenuListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _homeMainMenuSubListItemPagingControllerState.isPagingControllerExist = true;
    MainRouteObserver.controllerMediatorMap[Constant.subPageKeyHomeMainMenu] = refreshHomeMainMenu;
    MainRouteObserver.onRefreshSelectAddress = () => selectAddressModalDialogPageActionDelegate.refresh();
  }

  @override
  void didChangeDependencies() {
    precacheImage(_homeAppBarBackgroundAssetImage, context);
    super.didChangeDependencies();
  }

  void _checkingMainMenuContent(List<HomeMainMenuComponentEntity> mainMenuContentList, List<ListItemControllerState> listItemControllerStateList) {
    HorizontalComponentEntityParameterizedEntityAndListItemControllerStateMediator componentEntityMediator = Injector.locator<HorizontalComponentEntityParameterizedEntityAndListItemControllerStateMediator>();
    HorizontalDynamicItemCarouselParameterizedEntityAndListItemControllerStateMediatorParameter carouselParameterizedEntityMediator = HorizontalDynamicItemCarouselParameterizedEntityAndListItemControllerStateMediatorParameter(
      onSetState: () => setState(() {}),
      dynamicItemLoadDataResultDynamicListItemControllerStateList: _dynamicItemLoadDataResultDynamicListItemControllerStateList
    );
    int i = 0;
    _dynamicItemLoadDataResultDynamicListItemControllerStateList.clear();
    while (i < mainMenuContentList.length) {
      HomeMainMenuComponentEntity homeMainMenuComponentEntity = mainMenuContentList[i];
      if (homeMainMenuComponentEntity is SeparatorHomeMainMenuComponentEntity) {
        listItemControllerStateList.add(
          VirtualSpacingListItemControllerState(
            height: Constant.paddingListItem
          )
        );
      } else if (homeMainMenuComponentEntity is BannerHomeMainMenuComponentEntity) {
        listItemControllerStateList.add(
          SingleBannerListItemControllerState(
            banner: homeMainMenuComponentEntity.banner,
            aspectRatioValue: homeMainMenuComponentEntity.aspectRatioValue
          )
        );
      } else {
        ListItemControllerState listItemControllerState = componentEntityMediator.mapWithParameter(
          homeMainMenuComponentEntity, parameter: carouselParameterizedEntityMediator
        );
        if (listItemControllerState is NoContentListItemControllerState) {
          listItemControllerStateList.add(
            FailedPromptIndicatorListItemControllerState(
              errorProvider: Injector.locator<ErrorProvider>(),
              e: FailedLoadDataResult.throwException(() => throw MessageError(
                title: "Item Not Showed",
                message: "This item cannot be showed ${kDebugMode ? "(${homeMainMenuComponentEntity.runtimeType})" : ""}"
              ))!.e,
            )
          );
        } else {
          listItemControllerStateList.add(listItemControllerState);
        }
      }
      i++;
    }
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _homeMainMenuListItemPagingControllerStateListener(int pageKey) async {
    bool isLogin = false;
    LoginHelper.checkingLogin(
      context,
      () => isLogin = true,
      resultIfHasNotBeenLogin: () => isLogin = false
    );
    List<HomeMainMenuComponentEntity> firstMainMenuContentList = [
      widget.homeMainMenuSubController.getDeliveryTo(),
    ];
    List<HomeMainMenuComponentEntity> middleMainMenuContentList = [
      widget.homeMainMenuSubController.getHomepageBanner(),
    ];
    List<HomeMainMenuComponentEntity> mainMenuContentList = [
      ...widget.homeMainMenuSubController.getHomeMainMenuComponentEntity()
    ];
    List<ListItemControllerState> firstListItemControllerStateList = [];
    List<ListItemControllerState> middleListItemControllerStateList = [];
    List<ListItemControllerState> listItemControllerStateList = [];
    _checkingMainMenuContent(firstMainMenuContentList, firstListItemControllerStateList);
    _checkingMainMenuContent(middleMainMenuContentList, middleListItemControllerStateList);
    _checkingMainMenuContent(mainMenuContentList, listItemControllerStateList);
    return SuccessLoadDataResult<PagingResult<ListItemControllerState>>(
      value: PagingDataResult<ListItemControllerState>(
        page: 1,
        totalPage: 1,
        totalItem: 1,
        itemList: [
          BuilderListItemControllerState(
            buildListItemControllerState: () => CompoundListItemControllerState(
              listItemControllerState: [
                ...firstListItemControllerStateList,
                ...middleListItemControllerStateList,
                ...listItemControllerStateList,
                if (!isLogin) ...[
                  VirtualSpacingListItemControllerState(
                    height: Constant.mainMenuFooterHeight - Constant.paddingListItem
                  )
                ]
              ]
            )
          )
        ]
      )
    );
  }

  void refreshHomeMainMenu() {
    _homeMainMenuSubListItemPagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    widget.homeMainMenuSubController.wishlistAndCartControllerContentDelegate.setWishlistAndCartDelegate(
      Injector.locator<WishlistAndCartDelegateFactory>().generateWishlistAndCartDelegate(
        onGetBuildContext: () => context,
        onGetErrorProvider: () => Injector.locator<ErrorProvider>(),
        onAddToWishlistRequestProcessSuccessCallback: () async => context.read<ComponentNotifier>().updateWishlist(),
        onRemoveFromWishlistRequestProcessSuccessCallback: (wishlist) async => context.read<ComponentNotifier>().updateWishlist(),
        onAddCartRequestProcessSuccessCallback: () async {
          context.read<ComponentNotifier>().updateCart();
          context.read<NotificationNotifier>().loadCartLoadDataResult();
          context.read<ProductNotifier>().loadCartList();
        },
      )
    );
    OnObserveLoadProductDelegateFactory onObserveLoadProductDelegateFactory = Injector.locator<OnObserveLoadProductDelegateFactory>()
      ..onInjectLoadProductEntryCarouselParameterizedEntity = (
        () => CompoundParameterizedEntityAndListItemControllerStateMediatorParameter(
          parameterizedEntityAndListItemControllerStateMediatorParameterList: [
            WishlistDelegateParameterizedEntityAndListItemControllerStateMediatorParameter(
              onAddToWishlist: (data) => widget.homeMainMenuSubController.wishlistAndCartControllerContentDelegate.addToWishlist(
                data, () {
                  Completer<bool> checkingLoginCompleter = Completer<bool>();
                  LoginHelper.checkingLogin(
                    context,
                    () => checkingLoginCompleter.complete(true),
                    resultIfHasNotBeenLogin: () => checkingLoginCompleter.complete(false),
                    showLoginPageWhenHasCallbackIfHasNotBeenLogin: true
                  );
                  return checkingLoginCompleter.future;
                }
              ),
              onRemoveFromWishlist: (data) => widget.homeMainMenuSubController.wishlistAndCartControllerContentDelegate.removeFromWishlist(
                data, () {
                  Completer<bool> checkingLoginCompleter = Completer<bool>();
                  LoginHelper.checkingLogin(
                    context,
                    () => checkingLoginCompleter.complete(true),
                    resultIfHasNotBeenLogin: () => checkingLoginCompleter.complete(false),
                    showLoginPageWhenHasCallbackIfHasNotBeenLogin: true
                  );
                  return checkingLoginCompleter.future;
                }
              ),
            ),
            CartDelegateParameterizedEntityAndListItemControllerStateMediatorParameter(
              onAddCart: (data) => widget.homeMainMenuSubController.wishlistAndCartControllerContentDelegate.addToCart(
                data, () {
                  Completer<bool> checkingLoginCompleter = Completer<bool>();
                  LoginHelper.checkingLogin(
                    context,
                    () => checkingLoginCompleter.complete(true),
                    resultIfHasNotBeenLogin: () => checkingLoginCompleter.complete(false),
                    showLoginPageWhenHasCallbackIfHasNotBeenLogin: true
                  );
                  return checkingLoginCompleter.future;
                }
              ),
              onRemoveCart: (data) => widget.homeMainMenuSubController.wishlistAndCartControllerContentDelegate.removeFromCart(
                data, () {
                  Completer<bool> checkingLoginCompleter = Completer<bool>();
                  LoginHelper.checkingLogin(
                    context,
                    () => checkingLoginCompleter.complete(true),
                    resultIfHasNotBeenLogin: () => checkingLoginCompleter.complete(false),
                    showLoginPageWhenHasCallbackIfHasNotBeenLogin: true
                  );
                  return checkingLoginCompleter.future;
                }
              ),
            )
          ]
        )
      )
      ..onInjectLoadProductBundleCarouselParameterizedEntity = (
        () => CompoundParameterizedEntityAndListItemControllerStateMediatorParameter(
          parameterizedEntityAndListItemControllerStateMediatorParameterList: [
            WishlistDelegateParameterizedEntityAndListItemControllerStateMediatorParameter(
              onAddToWishlist: (data) => widget.homeMainMenuSubController.wishlistAndCartControllerContentDelegate.addToWishlist(
                data, () {
                  Completer<bool> checkingLoginCompleter = Completer<bool>();
                  LoginHelper.checkingLogin(
                    context,
                    () => checkingLoginCompleter.complete(true),
                    resultIfHasNotBeenLogin: () => checkingLoginCompleter.complete(false),
                    showLoginPageWhenHasCallbackIfHasNotBeenLogin: true
                  );
                  return checkingLoginCompleter.future;
                }
              ),
              onRemoveFromWishlist: (data) => widget.homeMainMenuSubController.wishlistAndCartControllerContentDelegate.removeFromWishlist(
                data, () {
                  Completer<bool> checkingLoginCompleter = Completer<bool>();
                  LoginHelper.checkingLogin(
                    context,
                    () => checkingLoginCompleter.complete(true),
                    resultIfHasNotBeenLogin: () => checkingLoginCompleter.complete(false),
                    showLoginPageWhenHasCallbackIfHasNotBeenLogin: true
                  );
                  return checkingLoginCompleter.future;
                }
              ),
            ),
            CartDelegateParameterizedEntityAndListItemControllerStateMediatorParameter(
              onAddCart: (data) => widget.homeMainMenuSubController.wishlistAndCartControllerContentDelegate.addToCart(
                data, () {
                  Completer<bool> checkingLoginCompleter = Completer<bool>();
                  LoginHelper.checkingLogin(
                    context,
                    () => checkingLoginCompleter.complete(true),
                    resultIfHasNotBeenLogin: () => checkingLoginCompleter.complete(false),
                    showLoginPageWhenHasCallbackIfHasNotBeenLogin: true
                  );
                  return checkingLoginCompleter.future;
                }
              ),
              onRemoveCart: (data) => widget.homeMainMenuSubController.wishlistAndCartControllerContentDelegate.removeFromCart(
                data, () {
                  Completer<bool> checkingLoginCompleter = Completer<bool>();
                  LoginHelper.checkingLogin(
                    context,
                    () => checkingLoginCompleter.complete(true),
                    resultIfHasNotBeenLogin: () => checkingLoginCompleter.complete(false),
                    showLoginPageWhenHasCallbackIfHasNotBeenLogin: true
                  );
                  return checkingLoginCompleter.future;
                }
              ),
            )
          ]
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
          CarouselListItemType? carouselListItemType;
          ParameterizedEntityAndListItemControllerStateMediatorParameter? additionalParameter;
          if (data == Constant.carouselKeyIndonesianCategoryProduct) {
            titleInterceptor = (text, style) => titleArea(
              title: Text(text.toStringNonNull, style: style?.copyWith()),
              onInterceptTextStyle: (style) => style.copyWith(),
              onTapMore: () => PageRestorationHelper.toProductCategoryPage(context)
            );
          } else if (data == Constant.carouselKeyIndonesianOriginalBrand) {
            carouselBackground = AssetCarouselBackground(assetImageName: Constant.imagePatternGrey2);
            titleInterceptor = (text, style) => titleArea(
              title: Text(text.toStringNonNull, style: style?.copyWith()),
              onInterceptTextStyle: (style) => style.copyWith(),
              onTapMore: () => PageRestorationHelper.toProductBrandPage(
                context, ProductBrandPageParameter(
                  productBrandPageType: ProductBrandPageType.defaultProductDetail
                )
              )
            );
          } else if (data == Constant.carouselKeyIsViral) {
            carouselBackground = AssetCarouselBackground(assetImageName: Constant.imagePatternBlack);
            titleInterceptor = (text, style) => titleArea(
              title: Text(text.toStringNonNull, style: style?.copyWith(color: Colors.white)),
              onTapMore: () => PageRestorationHelper.toProductEntryPage(
                context,
                ProductEntryPageParameter(
                  productEntryParameterMap: {
                    "type": "viral",
                    "name": {
                      Constant.textEnUsLanguageKey: "Is Viral",
                      Constant.textInIdLanguageKey: "Lagi Viral"
                    }
                  }
                )
              ),
            );
          } else if (data == Constant.carouselKeyReadyToEatStreetFoodStyle) {
            carouselBackground = AssetCarouselBackground(assetImageName: Constant.imagePatternBlack);
            titleInterceptor = (text, style) => titleArea(
              title: Text(text.toStringNonNull, style: style?.copyWith(color: Colors.white)),
              onTapMore: () => PageRestorationHelper.toProductEntryPage(
                context,
                ProductEntryPageParameter(
                  productEntryParameterMap: {
                    "category": "siap-saji-ala-kaki-lima"
                  }
                )
              ),
            );
          } else if (data == Constant.carouselKeySnackForLyingAround) {
            carouselBackground = AssetCarouselBackground(assetImageName: Constant.imagePatternBlack);
            titleInterceptor = (text, style) => titleArea(
              title: Text(text.toStringNonNull, style: style?.copyWith(color: Colors.white)),
              onTapMore: () => PageRestorationHelper.toProductEntryPage(
                context,
                ProductEntryPageParameter(
                  productEntryParameterMap: {
                    "category": "cemilan-buat-rebahan"
                  }
                )
              ),
            );
          } else if (data == Constant.carouselKeyProductBundleHighlight) {
            carouselBackground = AssetCarouselBackground(assetImageName: Constant.imagePatternBlack);
          } else if (data == Constant.carouselKeyBestSellingInMasterBagasi) {
            carouselBackground = AssetCarouselBackground(assetImageName: Constant.imagePatternBlack);
            titleInterceptor = (text, style) => titleArea(
              title: Text(text.toStringNonNull, style: style?.copyWith(color: Colors.white)),
              onTapMore: () => PageRestorationHelper.toProductEntryPage(
                context,
                ProductEntryPageParameter(
                  productEntryParameterMap: {
                    'type': 'best-seller',
                    "name": {
                      Constant.textEnUsLanguageKey: "Bestselling in Masterbagasi",
                      Constant.textInIdLanguageKey: "Terlaris di Masterbagasi"
                    }
                  }
                )
              ),
            );
          } else if (data == Constant.carouselKeySelectedFashionBrands) {
            carouselBackground = AssetCarouselBackground(
              assetImageName: Constant.imagePatternBlackSquare,
              imageBackgroundHeight: 340
            );
            carouselListItemType = TileCarouselListItemType();
            additionalParameter = HorizontalBrandAppearanceParameterizedEntityAndListItemControllerStateMediatorParameter(
              horizontalBrandAppearance: HorizontalBrandAppearance.squareAppearance
            );
            titleInterceptor = (text, style) => titleArea(
              title: Text(text.toStringNonNull, style: style?.copyWith(color: Colors.white))
            );
          } else if (data == Constant.carouselKeyChoiceBeautyBrand) {
            carouselBackground = AssetCarouselBackground(
              assetImageName: Constant.imageSelectedBeautyBrand,
              imageBackgroundHeight: 0.0
            );
            carouselListItemType = DefaultCarouselListItemType(
              additionalPadding: const EdgeInsets.only(left: 120)
            );
            additionalParameter = HorizontalBrandAppearanceParameterizedEntityAndListItemControllerStateMediatorParameter(
              horizontalBrandAppearance: HorizontalBrandAppearance.squareWithGlassBackgroundTitleAppearance
            );
            titleInterceptor = (text, style) => titleArea(
              title: Text(text.toStringNonNull, style: style?.copyWith(color: Colors.white)),
            );
          } else if (data == Constant.carouselKeyCoffeeAndTeaOriginIndonesia) {
            carouselBackground = AssetCarouselBackground(assetImageName: Constant.imagePatternBlack);
            titleInterceptor = (text, style) => titleArea(
              title: Text(text.toStringNonNull, style: style?.copyWith(color: Colors.white)),
              onTapMore: () => PageRestorationHelper.toProductEntryPage(
                context,
                ProductEntryPageParameter(
                  productEntryParameterMap: {
                    "category": "teh-kopi-asli-indonesia"
                  }
                )
              ),
            );
          } else if (data == Constant.carouselKeyBeautyProductIndonesia) {
            carouselBackground = AssetCarouselBackground(assetImageName: Constant.imagePatternBlack);
            titleInterceptor = (text, style) => titleArea(
              title: Text(text.toStringNonNull, style: style?.copyWith(color: Colors.white)),
              onTapMore: () => PageRestorationHelper.toProductEntryPage(
                context,
                ProductEntryPageParameter(
                  productEntryParameterMap: {
                    "category": "produk-kecantikan-indonesia"
                  }
                )
              ),
            );
          } else if (data == Constant.carouselKeyFashionProductIndonesia) {
            carouselBackground = AssetCarouselBackground(assetImageName: Constant.imagePatternBlack);
            titleInterceptor = (text, style) => titleArea(
              title: Text(text.toStringNonNull, style: style?.copyWith(color: Colors.white)),
              onTapMore: () => PageRestorationHelper.toProductEntryPage(
                context,
                ProductEntryPageParameter(
                  productEntryParameterMap: {
                    "category": "produk-fesyen-indonesia"
                  }
                )
              ),
            );
          } else if (data == Constant.carouselKeyOnlyForYou) {
            carouselBackground = AssetCarouselBackground(assetImageName: Constant.imagePatternBlack);
            titleInterceptor = (text, style) => titleArea(
              title: Text(text.toStringNonNull, style: style?.copyWith(color: Colors.white)),
              onTapMore: () => PageRestorationHelper.toProductEntryPage(
                context,
                ProductEntryPageParameter(
                  productEntryParameterMap: {
                    "fyp": true,
                    "name": {
                      Constant.textEnUsLanguageKey: "Only For You",
                      Constant.textInIdLanguageKey: "Hanya Untuk Kamu"
                    }
                  }
                )
              ),
            );
          } else if (data == Constant.carouselKeyProductSponsor) {
            carouselBackground = null;
            titleInterceptor = (text, style) => Container();
            additionalParameter = HorizontalProductAppearanceParameterizedEntityAndListItemControllerStateMediatorParameter(
              horizontalProductAppearance: HorizontalProductAppearance.onlyPicture
            );
          } else {
            carouselBackground = AssetCarouselBackground(assetImageName: Constant.imagePatternGrey);
          }
          return CarouselParameterizedEntityAndListItemControllerStateMediatorParameter(
            carouselBackground: carouselBackground,
            titleInterceptor: titleInterceptor,
            carouselListItemType: carouselListItemType,
            additionalParameter: additionalParameter
          );
        }
      );
    void toSponsorProductEntryPage(Banner? banner) {
      String brandName = "";
      String brandTitle = "";
      String? brandId;
      String? brandSlug;
      bool hasBrandIdAndBrandSlug() => brandId.isNotEmptyString && brandSlug.isNotEmptyString;
      dynamic bannerData = banner?.data;
      if (bannerData is Map<String, dynamic>) {
        brandTitle = bannerData["title"] as String;
        brandName = brandTitle.toLowerCase();
        if (bannerData.containsKey("data")) {
          dynamic bannerDataDetail = bannerData["data"];
          if (bannerDataDetail is Map<String, dynamic>) {
            if (bannerDataDetail.containsKey("brand_id") && bannerDataDetail.containsKey("slug")) {
              brandId = bannerDataDetail["brand_id"];
              brandSlug = bannerDataDetail["slug"];
            }
          }
        }
      } else if (bannerData is String) {
        brandName = bannerData;
      }
      PageRestorationHelper.toProductEntryPage(
        context,
        ProductEntryPageParameter(
          productEntryParameterMap: {
            if (hasBrandIdAndBrandSlug()) ...{
              "brand_id": brandId.toEmptyStringNonNull,
              "brand": brandSlug.toEmptyStringNonNull
            } else ...{
              "type": "sponsor",
              "brand": brandName,
              "sponsor_image_url": banner?.imageUrl ?? "",
              "sponsor_title": brandName,
              "sponsor_aspect_ratio": Constant.aspectRatioValueSponsorBanner.toDouble()
            }
          }
        )
      );
    }
    widget.homeMainMenuSubController.setHomeMainMenuDelegate(
      HomeMainMenuDelegate(
        onObserveLoadProductDelegate: onObserveLoadProductDelegateFactory.generateOnObserveLoadProductDelegate(),
        onObserveSuccessLoadProductBundleHighlight: (onObserveSuccessLoadProductBundleHighlightParameter) {
          return CompoundListItemControllerState(
            listItemControllerState: [
              DecoratedContainerListItemControllerState(
                padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
                decoration: const BoxDecoration(),
                decoratedChildListItemControllerState: CompoundListItemControllerState(
                  listItemControllerState: [
                    TitleAndDescriptionListItemControllerState(
                      title: "Save More With Bundles".tr,
                      titleAndDescriptionItemInterceptor: (padding, title, titleWidget, description, descriptionWidget, titleAndDescriptionWidget, titleAndDescriptionWidgetList) {
                        return Row(
                          children: [
                            Expanded(child: titleAndDescriptionWidget),
                            TapArea(
                              onTap: () => PageRestorationHelper.toProductBundlePage(context),
                              child: Text(
                                "More".tr,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12
                                )
                              ),
                            )
                          ]
                        );
                      },
                      verticalSpace: 0.3.h,
                    ),
                    VirtualSpacingListItemControllerState(height: 3.w),
                    ProductBundleHighlightMultipleListItemControllerState(
                      productBundleList: onObserveSuccessLoadProductBundleHighlightParameter.productBundleList,
                      onAddWishlist: (productBundleOutput) => widget.homeMainMenuSubController.wishlistAndCartControllerContentDelegate.addToWishlist(
                        productBundleOutput, () {
                          Completer<bool> checkingLoginCompleter = Completer<bool>();
                          LoginHelper.checkingLogin(
                            context,
                            () => checkingLoginCompleter.complete(true),
                            resultIfHasNotBeenLogin: () => checkingLoginCompleter.complete(false),
                            showLoginPageWhenHasCallbackIfHasNotBeenLogin: true
                          );
                          return checkingLoginCompleter.future;
                        }
                      ),
                      onRemoveWishlist: (productBundleOutput) => widget.homeMainMenuSubController.wishlistAndCartControllerContentDelegate.removeFromWishlist(
                        productBundleOutput, () {
                          Completer<bool> checkingLoginCompleter = Completer<bool>();
                          LoginHelper.checkingLogin(
                            context,
                            () => checkingLoginCompleter.complete(true),
                            resultIfHasNotBeenLogin: () => checkingLoginCompleter.complete(false),
                            showLoginPageWhenHasCallbackIfHasNotBeenLogin: true
                          );
                          return checkingLoginCompleter.future;
                        }
                      ),
                      onAddCart: (productBundleOutput) => widget.homeMainMenuSubController.wishlistAndCartControllerContentDelegate.addToCart(
                        productBundleOutput, () {
                          Completer<bool> checkingLoginCompleter = Completer<bool>();
                          LoginHelper.checkingLogin(
                            context,
                            () => checkingLoginCompleter.complete(true),
                            resultIfHasNotBeenLogin: () => checkingLoginCompleter.complete(false),
                            showLoginPageWhenHasCallbackIfHasNotBeenLogin: true
                          );
                          return checkingLoginCompleter.future;
                        }
                      ),
                      onRemoveCart: (productBundleOutput) => widget.homeMainMenuSubController.wishlistAndCartControllerContentDelegate.removeFromCart(
                        productBundleOutput, () {
                          Completer<bool> checkingLoginCompleter = Completer<bool>();
                          LoginHelper.checkingLogin(
                            context,
                            () => checkingLoginCompleter.complete(true),
                            resultIfHasNotBeenLogin: () => checkingLoginCompleter.complete(false),
                            showLoginPageWhenHasCallbackIfHasNotBeenLogin: true
                          );
                          return checkingLoginCompleter.future;
                        }
                      ),
                    )
                  ]
                )
              ),
              VirtualSpacingListItemControllerState(
                height: Constant.paddingListItem
              )
            ]
          );
        },
        onObserveLoadingLoadProductBundleHighlight: (onObserveLoadingLoadProductBundleHighlightParameter) {
          return ShimmerCarouselListItemControllerState<ProductBundleShimmerCarouselListItemGeneratorType>(
            padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
            showTitleShimmer: true,
            showDescriptionShimmer: false,
            showItemShimmer: true,
            shimmerCarouselListItemGenerator: Injector.locator<ProductBundleShimmerCarouselListItemGeneratorFactory>().getShimmerCarouselListItemGeneratorType()
          );
        },
        onObserveSuccessLoadMultipleTransparentBanner: (onObserveSuccessLoadMultipleTransparentBannerParameter) {
          dynamic data = onObserveSuccessLoadMultipleTransparentBannerParameter.data;
          if (data == Constant.transparentBannerKeyMultipleHomepage) {
            return WidgetSubstitutionWithInjectionListItemControllerState(
              widgetSubstitutionWithInjection: (context, index, widgetList) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10.0)
                    ),
                    child: Column(
                      children: widgetList
                    ),
                  ),
                );
              },
              onInjectListItemControllerState: () {
                return <ListItemControllerState>[
                  MultiBannerListItemControllerState(
                    bannerList: onObserveSuccessLoadMultipleTransparentBannerParameter.transparentBannerList.map(
                      (transparentBanner) => Banner(
                        id: transparentBanner.id,
                        imageUrl: transparentBanner.imageUrl
                      )
                    ).toList(),
                    aspectRatioValue: Constant.aspectRatioValueHomepageBanner,
                  )
                ];
              }
            );
          } else if (data == Constant.transparentBannerKeyMultipleShippingPrice) {
            return CompoundListItemControllerState(
              listItemControllerState: [
                MultiBannerListItemControllerState(
                  bannerList: onObserveSuccessLoadMultipleTransparentBannerParameter.transparentBannerList.map(
                    (transparentBanner) => Banner(
                      id: transparentBanner.id,
                      imageUrl: transparentBanner.imageUrl
                    )
                  ).toList(),
                  aspectRatioValue: Constant.aspectRatioValueShippingPriceBanner
                ),
                WidgetSubstitutionListItemControllerState(
                  widgetSubstitution: (BuildContext context, int index) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem, vertical: 10),
                    child: Align(
                      child: SizedOutlineGradientButton(
                        width: double.infinity,
                        outlineGradientButtonType: OutlineGradientButtonType.solid,
                        onPressed: () async {
                          DialogHelper.showModalDialogPage<String, String>(
                            context: context,
                            modalDialogPageBuilder: (context, parameter) => CheckRatesForVariousCountriesModalDialogPage(
                              checkRatesForVariousCountriesModalDialogPageParameter: CheckRatesForVariousCountriesModalDialogPageParameter(
                                onGotoCountryDeliveryReview: (countryId) {
                                  PageRestorationHelper.toCountryDeliveryReviewPage(
                                    countryId, this.context
                                  );
                                },
                              )
                            ),
                          );
                        },
                        text: "Check Rates to Other Countries".tr,
                      ),
                      alignment: Alignment.topLeft
                    )
                  )
                )
              ]
            );
          } else if (data is ProductSponsorTransparentBannerParameterData) {
            List<Banner> bannerList = onObserveSuccessLoadMultipleTransparentBannerParameter.transparentBannerList.map(
              (transparentBanner) {
                return Banner(
                  id: transparentBanner.id,
                  imageUrl: transparentBanner.imageUrl,
                  data: transparentBanner.data
                );
              }
            ).toList();
            return BuilderListItemControllerState(
              buildListItemControllerState: () {
                return StackContainerListItemControllerState(
                  childListItemControllerStateList: [
                    MultiBannerListItemControllerState(
                      bannerList: bannerList,
                      aspectRatioValue: Constant.aspectRatioValueSponsorBanner,
                      onTapBanner: (banner) => toSponsorProductEntryPage(banner),
                      onPageChanged: (index, reason) {
                        _banner = bannerList[index];
                        data.repeatableDynamicItemCarouselAdditionalParameter?.onRepeatLoading();
                      },
                      isAutoSwipe: false,
                      withIndicator: false
                    ),
                    WidgetSubstitutionListItemControllerState(
                      widgetSubstitution: (BuildContext context, int index) {
                        return Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(8.0)
                            ),
                            child: Text(
                              MultiLanguageString({
                                Constant.textEnUsLanguageKey: "Product Sponsor",
                                Constant.textInIdLanguageKey: "Produk Sponsor"
                              }).toEmptyStringNonNull,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold
                              ),
                            )
                          )
                        );
                      }
                    ),
                    WidgetSubstitutionListItemControllerState(
                      widgetSubstitution: (BuildContext context, int index) {
                        return Positioned(
                          top: 10,
                          right: 10,
                          child: TapArea(
                            onTap: () => toSponsorProductEntryPage(_banner),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Constant.colorMain
                              ),
                              child: Text(
                                MultiLanguageString({
                                  Constant.textEnUsLanguageKey: "Look More",
                                  Constant.textInIdLanguageKey: "Lihat Selengkapnya"
                                }).toEmptyStringNonNull,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold
                                ),
                              )
                            )
                          )
                        );
                      }
                    ),
                  ]
                );
              }
            );
          } else {
            return NoContentListItemControllerState();
          }
        },
        onObserveSuccessLoadTransparentBanner: (onObserveSuccessLoadTransparentBannerParameter) {
          return DecoratedContainerListItemControllerState(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Constant.imagePatternGrey3),
                fit: BoxFit.cover,
                opacity: 0.4
              )
            ),
            decoratedChildListItemControllerState: CompoundListItemControllerState(
              listItemControllerState: [
                VirtualSpacingListItemControllerState(height: Constant.paddingListItem),
                PaddingContainerListItemControllerState(
                  padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
                  paddingChildListItemControllerState: TitleAndDescriptionListItemControllerState(
                    title: onObserveSuccessLoadTransparentBannerParameter.title.toStringNonNull,
                    titleAndDescriptionItemInterceptor: (padding, title, titleWidget, description, descriptionWidget, titleAndDescriptionWidget, titleAndDescriptionWidgetList) {
                      return Row(
                        children: [
                          Expanded(child: titleAndDescriptionWidget),
                          TapArea(
                            onTap: () {
                              Map<String, dynamic> productEntryParameterMap = {};
                              dynamic data = onObserveSuccessLoadTransparentBannerParameter.data;
                              if (data == Constant.transparentBannerKeyKitchenContents) {
                                productEntryParameterMap = {
                                  "type": "kitchen",
                                  "name": {
                                    Constant.textEnUsLanguageKey: "Indonesian Kitchen Contents",
                                    Constant.textInIdLanguageKey: "Isi Dapur Indonesia"
                                  }
                                };
                              } else if (data == Constant.transparentBannerKeyHandycrafts) {
                                productEntryParameterMap = {
                                  "type": "handycrafts",
                                  "name": {
                                    Constant.textEnUsLanguageKey: "Handicrafts made by the Nation's Children",
                                    Constant.textInIdLanguageKey: "Kerajinan Tangan Karya Anak Bangsa"
                                  }
                                };
                              }
                              PageRestorationHelper.toProductEntryPage(
                                context,
                                ProductEntryPageParameter(
                                  productEntryParameterMap: productEntryParameterMap
                                )
                              );
                            },
                            child: Text(
                              "More".tr,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12
                              )
                            ),
                          )
                        ]
                      );
                    },
                    verticalSpace: 0.3.h,
                  ),
                ),
                VirtualSpacingListItemControllerState(height: 3.w),
                WidgetSubstitutionListItemControllerState(
                  widgetSubstitution: (context, index) {
                    AspectRatioValue aspectRatioValue = Constant.aspectRatioValueTransparentBanner;
                    double height = MediaQuery.of(context).size.width * aspectRatioValue.height / aspectRatioValue.width;
                    return SizedBox(
                      width: double.infinity,
                      height: height,
                      child: TransparentBannerModifiedCachedNetworkImage(
                        imageUrl: onObserveSuccessLoadTransparentBannerParameter.transparentBanner.imageUrl,
                      ),
                    );
                  }
                )
              ]
            )
          );
        },
        onObserveLoadingLoadTransparentBanner: (onObserveLoadingLoadTransparentBannerParameter) {
          return WidgetSubstitutionListItemControllerState(
            widgetSubstitution: (context, index) {
              AspectRatioValue aspectRatioValue = Constant.aspectRatioValueHomepageBanner;
              double height = MediaQuery.of(context).size.width * aspectRatioValue.height / aspectRatioValue.width;
              return ModifiedShimmer.fromColors(
                child: Container(
                  color: Colors.grey,
                  width: double.infinity,
                  height: height,
                ),
              );
            }
          );
        },
        onObserveLoadCurrentAddress: (onObserveLoadCurrentAddressParameter) {
          MainRouteObserver.onRefreshAddress = onObserveLoadCurrentAddressParameter.repeatableDynamicItemCarouselAdditionalParameter.onRepeatLoading;
          return CompoundListItemControllerState(
            listItemControllerState: [
              DeliveryToListItemControllerState(
                addressLoadDataResult: onObserveLoadCurrentAddressParameter.addressLoadDataResult,
                errorProvider: Injector.locator<ErrorProvider>(),
                onAddressSelectedChanged: (address) {
                  onObserveLoadCurrentAddressParameter.repeatableDynamicItemCarouselAdditionalParameter.onRepeatLoading();
                },
                onGotoAddAddress: () => PageRestorationHelper.toAddressPage(
                  context,
                  addressPageParameter: AddressPageParameter(
                    directToAddAddress: true
                  )
                ),
                selectAddressModalDialogPageActionDelegate: selectAddressModalDialogPageActionDelegate
              ),
            ]
          );
        },
        onObserveSuccessLoadProductSponsor: (onObserveSuccessLoadProductSponsorParameter) {
          LoadSponsorBannerAndContentResponse loadSponsorBannerAndContentResponse = onObserveSuccessLoadProductSponsorParameter.loadSponsorBannerAndContentResponse;
          return BuilderListItemControllerState(
            buildListItemControllerState: () {
              List<Banner> bannerList = loadSponsorBannerAndContentResponse.sponsorTransparentBannerList.map<Banner>(
                (transparentBanner) => Banner(
                  id: transparentBanner.id,
                  imageUrl: transparentBanner.imageUrl,
                  data: transparentBanner.data
                )
              ).toList();
              return StackContainerListItemControllerState(
                childListItemControllerStateList: [
                  ColumnContainerListItemControllerState(
                    columnChildListItemControllerState: [
                      MultiBannerListItemControllerState(
                        bannerList: bannerList,
                        aspectRatioValue: Constant.aspectRatioValueSponsorBanner,
                        onTapBanner: (banner) => toSponsorProductEntryPage(banner),
                        onPageChanged: (index, reason) {
                          _banner = bannerList[index];
                          //data.repeatableDynamicItemCarouselAdditionalParameter?.onRepeatLoading();
                        },
                        isAutoSwipe: false,
                        withIndicator: false
                      ),
                    ]
                  ),
                  WidgetSubstitutionListItemControllerState(
                    widgetSubstitution: (BuildContext context, int index) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: EdgeInsets.all(Constant.paddingListItem),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  loadSponsorBannerAndContentResponse.brandName.isNotEmptyString
                                    ? loadSponsorBannerAndContentResponse.brandName
                                    : MultiLanguageString({
                                        Constant.textEnUsLanguageKey: "Selected Brand",
                                        Constant.textInIdLanguageKey: "Brand Pilihan"
                                      }).toEmptyStringNonNull,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                  )
                                ),
                              ),
                              TapArea(
                                onTap: () => toSponsorProductEntryPage(_banner),
                                child: Text(
                                  MultiLanguageString({
                                    Constant.textEnUsLanguageKey: "Look More",
                                    Constant.textInIdLanguageKey: "Lihat Semua"
                                  }).toEmptyStringNonNull,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold
                                  ),
                                )
                              )
                            ]
                          ),
                        )
                      );
                    }
                  ),
                  ColumnContainerListItemControllerState(
                    columnChildListItemControllerState: [
                      WidgetSubstitutionListItemControllerState(
                        widgetSubstitution: (context, index) {
                          AspectRatioValue aspectRatioValue = Constant.aspectRatioValueSponsorBanner;
                          double bannerWidth = MediaQuery.of(context).size.width;
                          double bannerHeight = bannerWidth * aspectRatioValue.height / aspectRatioValue.width;
                          return SizedBox(
                            width: bannerWidth,
                            height: bannerHeight - 90
                          );
                        }
                      ),
                      onObserveSuccessLoadProductSponsorParameter.onCreateProductSponsorCarousel()
                    ]
                  )
                ]
              );
            }
          );
        },
        getBannerData: () {
          dynamic data = _banner?.data;
          if (data is Map<String, dynamic>) {
            if (data.containsKey("data")) {
              dynamic dataDetail = data["data"];
              if (dataDetail is Map<String, dynamic>) {
                if (dataDetail.containsKey("slug")) {
                  return dataDetail["slug"] as String;
                }
              } else if (dataDetail is String) {
                return dataDetail;
              } else {
                if (data.containsKey("title")) {
                  return data["title"] as String;
                }
              }
            } else if (data.containsKey("title")) {
              return data["title"] as String;
            }
          } else if (data is String) {
            return data;
          }
          return "";
        },
        setBanner: (bannerData) => _banner = bannerData
      )
    );
    return WidgetHelper.checkVisibility(
      MainRouteObserver.subMainMenuVisibility[Constant.subPageKeyHomeMainMenu],
      () => BackgroundAppBarScaffold(
        backgroundAppBarScaffoldType: ColorBackgroundAppBarScaffoldType(
          color: Constant.colorDarkBlack2
        ),
        appBar: MainMenuSearchAppBar(value: 0.0),
        withModifiedScaffold: false,
        backgroundColor: Constant.colorSurfaceGrey,
        body: Expanded(
          child: ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
            pagingControllerState: _homeMainMenuSubListItemPagingControllerState,
            onProvidePagedChildBuilderDelegate: (pagingControllerState) => ListItemPagingControllerStatePagedChildBuilderDelegate<int>(
              pagingControllerState: pagingControllerState!
            ),
            pullToRefresh: true
          ),
        ),
      )
    );
  }
}