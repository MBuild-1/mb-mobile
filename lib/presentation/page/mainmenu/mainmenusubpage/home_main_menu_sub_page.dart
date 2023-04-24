import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Banner;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:masterbagasi/presentation/page/product_entry_page.dart';
import 'package:sizer/sizer.dart';
import '../../../../controller/mainmenucontroller/mainmenusubpagecontroller/home_main_menu_sub_controller.dart';
import '../../../../domain/entity/banner/banner.dart';
import '../../../../domain/entity/homemainmenucomponententity/banner_home_main_menu_component_entity.dart';
import '../../../../domain/entity/homemainmenucomponententity/check_rates_for_various_countries_component_entity.dart';
import '../../../../domain/entity/homemainmenucomponententity/home_main_menu_component_entity.dart';
import '../../../../domain/entity/homemainmenucomponententity/separator_home_main_menu_component_entity.dart';
import '../../../../domain/entity/location/location.dart';
import '../../../../misc/additionalloadingindicatorchecker/home_sub_additional_paging_result_parameter_checker.dart';
import '../../../../misc/aspect_ratio_value.dart';
import '../../../../misc/carouselbackground/asset_carousel_background.dart';
import '../../../../misc/carouselbackground/carousel_background.dart';
import '../../../../misc/constant.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/carousel_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/check_rates_for_various_countries_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/colorful_divider_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/compound_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/decorated_container_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/delivery_to_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/failed_prompt_indicator_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/load_data_result_dynamic_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/no_content_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/product_bundle_highlight_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/single_banner_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/title_and_description_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/widget_substitution_list_item_controller_state.dart';
import '../../../../misc/controllerstate/paging_controller_state.dart';
import '../../../../misc/entityandlistitemcontrollerstatemediator/horizontal_component_entity_parameterized_entity_and_list_item_controller_state_mediator.dart';
import '../../../../misc/error/message_error.dart';
import '../../../../misc/errorprovider/error_provider.dart';
import '../../../../misc/injector.dart';
import '../../../../misc/load_data_result.dart';
import '../../../../misc/main_route_observer.dart';
import '../../../../misc/manager/controller_manager.dart';
import '../../../../misc/on_observe_load_product_delegate.dart';
import '../../../../misc/page_restoration_helper.dart';
import '../../../../misc/paging/modified_paging_controller.dart';
import '../../../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../../../misc/paging/pagingresult/paging_data_result.dart';
import '../../../../misc/paging/pagingresult/paging_result.dart';
import '../../../../misc/parameterizedcomponententityandlistitemcontrollerstatemediatorparameter/carousel_background_parameterized_entity_and_list_item_controller_state_mediator_parameter.dart';
import '../../../../misc/parameterizedcomponententityandlistitemcontrollerstatemediatorparameter/horizontal_dynamic_item_carousel_parametered_component_entity_and_list_item_controller_state_mediator_parameter.dart';
import '../../../../misc/parameterizedcomponententityandlistitemcontrollerstatemediatorparameter/wishlist_parameterized_entity_and_list_item_controller_state_mediator.dart';
import '../../../../misc/shimmercarousellistitemgenerator/factory/product_bundle_shimmer_carousel_list_item_generator_factory.dart';
import '../../../../misc/shimmercarousellistitemgenerator/type/product_bundle_shimmer_carousel_list_item_generator_type.dart';
import '../../../widget/background_app_bar_scaffold.dart';
import '../../../widget/modified_paged_list_view.dart';
import '../../../widget/modifiedappbar/main_menu_search_app_bar.dart';
import '../../../widget/modifiedcachednetworkimage/transparent_banner_modified_cached_network_image.dart';
import '../../../widget/tap_area.dart';
import '../../../widget/titleanddescriptionitem/title_and_description_item.dart';
import '../../getx_page.dart';

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
  final List<LoadDataResultDynamicListItemControllerState> _dynamicItemLoadDataResultDynamicListItemControllerStateList = [];

  late AssetImage _homeAppBarBackgroundAssetImage;

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
            banner: homeMainMenuComponentEntity.banner
          )
        );
      } else if (homeMainMenuComponentEntity is CheckRatesForVariousCountriesComponentEntity) {
        listItemControllerStateList.add(
          CheckRatesForVariousCountriesControllerState()
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
    List<HomeMainMenuComponentEntity> mainMenuContentList = [
      BannerHomeMainMenuComponentEntity(
        banner: Banner(
          id: "1",
          imageUrl: "https://firebasestorage.googleapis.com/v0/b/actions-codelab-c28a7.appspot.com/o/banner_menu_utama_masterbagasi_1.png?alt=media&token=65e68fd3-5036-427b-bc46-e3e8e3d2e145",
          aspectRatio: AspectRatioValue(width: 360, height: 200)
        )
      ),
      ...widget.homeMainMenuSubController.getHomeMainMenuComponentEntity()
    ];
    List<ListItemControllerState> listItemControllerStateList = [];
    _checkingMainMenuContent(mainMenuContentList, listItemControllerStateList);
    return SuccessLoadDataResult<PagingResult<ListItemControllerState>>(
      value: PagingDataResult<ListItemControllerState>(
        page: 1,
        totalPage: 1,
        totalItem: 1,
        itemList: [
          DeliveryToListItemControllerState(
            location: Location(
              id: "",
              name: "Test",
              description: "",
              latitude: 0.0,
              longitude: 0.0
            )
          ),
          ColorfulDividerListItemControllerState(
            lineColorList: [Constant.colorButtonGradient2, Constant.colorButtonGradient3],
            lineHeight: 3
          ),
          ...listItemControllerStateList,
        ]
      )
    );
  }

  void refreshHomeMainMenu() {
    _homeMainMenuSubListItemPagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    OnObserveLoadProductDelegateFactory onObserveLoadProductDelegateFactory = Injector.locator<OnObserveLoadProductDelegateFactory>()
      ..onInjectLoadProductEntryCarouselParameterizedEntity = (
        () => WishlistParameterizedEntityAndListItemControllerStateMediatorParameter(
          onAddWishlist: (productOrProductEntryId) {},
          onRemoveWishlist: (productOrProductEntryId) {},
        )
      )
      ..onInjectLoadProductBundleCarouselParameterizedEntity = (
        () => WishlistParameterizedEntityAndListItemControllerStateMediatorParameter(
          onAddWishlist: (productBundleId) {},
          onRemoveWishlist: (productBundleId) {},
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
                moreTapArea(
                  onTap: onTapMore,
                  onInterceptTextStyle: onInterceptTextStyle
                )
              ],
            );
          }
          late CarouselBackground carouselBackground;
          TitleInterceptor? titleInterceptor;
          if (data == Constant.carouselKeyIndonesianCategoryProduct) {
            carouselBackground = AssetCarouselBackground(assetImageName: Constant.imagePatternGrey);
          } else if (data == Constant.carouselKeyIndonesianOriginalBrand) {
            carouselBackground = AssetCarouselBackground(assetImageName: Constant.imagePatternGrey2);
          } else if (data == Constant.carouselKeyIsViral) {
            carouselBackground = AssetCarouselBackground(assetImageName: Constant.imagePatternBlue);
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
          } else if (data == Constant.carouselKeySnackForLyingAround) {
            carouselBackground = AssetCarouselBackground(assetImageName: Constant.imagePatternBlue);
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
            carouselBackground = AssetCarouselBackground(assetImageName: Constant.imagePatternBlue);
          } else if (data == Constant.carouselKeyBestSellingInMasterBagasi) {
            carouselBackground = AssetCarouselBackground(assetImageName: Constant.imagePatternLightBlue);
            titleInterceptor = (text, style) => titleArea(
              title: Text(text.toStringNonNull, style: style?.copyWith(color: Colors.white)),
              onInterceptTextStyle: (style) => style.copyWith(color: Colors.white),
              onTapMore: () => PageRestorationHelper.toProductEntryPage(
                context,
                ProductEntryPageParameter(
                  productEntryParameterMap: {
                    "fyp": true,
                    "name": {
                      Constant.textEnUsLanguageKey: "Bestselling in Masterbagasi",
                      Constant.textInIdLanguageKey: "Terlaris di Masterbagasi"
                    }
                  }
                )
              ),
            );
          } else if (data == Constant.carouselKeyCoffeeAndTeaOriginIndonesia) {
            carouselBackground = AssetCarouselBackground(assetImageName: Constant.imagePatternOrange);
            titleInterceptor = (text, style) => titleArea(
              title: Text(text.toStringNonNull, style: style?.copyWith(color: Colors.white)),
              onInterceptTextStyle: (style) => style.copyWith(color: Colors.white),
              onTapMore: () => PageRestorationHelper.toProductEntryPage(
                context,
                ProductEntryPageParameter(
                  productEntryParameterMap: {
                    "category": "teh-kopi-asli-indonesia"
                  }
                )
              ),
            );
          } else {
            carouselBackground = AssetCarouselBackground(assetImageName: Constant.imagePatternGrey);
          }
          return CarouselParameterizedEntityAndListItemControllerStateMediatorParameter(
            carouselBackground: carouselBackground,
            titleInterceptor: titleInterceptor
          );
        }
      );
    widget.homeMainMenuSubController.setHomeMainMenuDelegate(
      HomeMainMenuDelegate(
        onObserveLoadProductDelegate: onObserveLoadProductDelegateFactory.generateOnObserveLoadProductDelegate(),
        onObserveSuccessLoadProductBundleHighlight: (onObserveSuccessLoadProductBundleHighlightParameter) {
          return DecoratedContainerListItemControllerState(
            padding: EdgeInsets.all(Constant.paddingListItem),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Constant.imagePatternGrey3),
                fit: BoxFit.cover,
                opacity: 0.4
              )
            ),
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
                ProductBundleHighlightListItemControllerState(
                  productBundle: onObserveSuccessLoadProductBundleHighlightParameter.productBundle,
                  onAddWishlist: (productBundleId) {},
                )
              ]
            )
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
                  widgetSubstitution: (context, index) => SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: TransparentBannerModifiedCachedNetworkImage(
                      imageUrl: onObserveSuccessLoadTransparentBannerParameter.transparentBanner.imageUrl,
                    ),
                  )
                )
              ]
            )
          );
        },
        onObserveLoadingLoadTransparentBanner: (onObserveLoadingLoadTransparentBannerParameter) {
          return ShimmerCarouselListItemControllerState<ProductBundleShimmerCarouselListItemGeneratorType>(
            padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
            showTitleShimmer: true,
            showDescriptionShimmer: false,
            showItemShimmer: true,
            shimmerCarouselListItemGenerator: Injector.locator<ProductBundleShimmerCarouselListItemGeneratorFactory>().getShimmerCarouselListItemGeneratorType()
          );
        }
      )
    );
    return BackgroundAppBarScaffold(
      backgroundAppBarImage: _homeAppBarBackgroundAssetImage,
      appBar: MainMenuSearchAppBar(value: 0.0, onSearchTextFieldTapped: () =>PageRestorationHelper.toCartPage(context)),
      body: Expanded(
        child: ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
          pagingControllerState: _homeMainMenuSubListItemPagingControllerState,
          onProvidePagedChildBuilderDelegate: (pagingControllerState) => ListItemPagingControllerStatePagedChildBuilderDelegate<int>(
            pagingControllerState: pagingControllerState!
          ),
          pullToRefresh: true
        ),
      ),
    );
  }
}