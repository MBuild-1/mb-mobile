import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Banner;
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';
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
import '../../../../misc/constant.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/carousel_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/check_rates_for_various_countries_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/colorful_divider_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/compound_list_item_controller_state.dart';
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
import '../../../../misc/controllerstate/paging_controller_state.dart';
import '../../../../misc/entityandlistitemcontrollerstatemediator/horizontal_component_entity_parameterized_entity_and_list_item_controller_state_mediator.dart';
import '../../../../misc/error/message_error.dart';
import '../../../../misc/errorprovider/error_provider.dart';
import '../../../../misc/injector.dart';
import '../../../../misc/load_data_result.dart';
import '../../../../misc/manager/controller_manager.dart';
import '../../../../misc/on_observe_load_product_delegate.dart';
import '../../../../misc/page_restoration_helper.dart';
import '../../../../misc/paging/modified_paging_controller.dart';
import '../../../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../../../misc/paging/pagingresult/paging_data_result.dart';
import '../../../../misc/paging/pagingresult/paging_result.dart';
import '../../../../misc/parameterizedcomponententityandlistitemcontrollerstatemediatorparameter/horizontal_dynamic_item_carousel_parametered_component_entity_and_list_item_controller_state_mediator_parameter.dart';
import '../../../../misc/parameterizedcomponententityandlistitemcontrollerstatemediatorparameter/wishlist_parameterized_entity_and_list_item_controller_state_mediator.dart';
import '../../../../misc/shimmercarousellistitemgenerator/factory/product_bundle_shimmer_carousel_list_item_generator_factory.dart';
import '../../../../misc/shimmercarousellistitemgenerator/type/product_bundle_shimmer_carousel_list_item_generator_type.dart';
import '../../../widget/modified_paged_list_view.dart';
import '../../../widget/modifiedappbar/default_search_app_bar.dart';
import '../../getx_page.dart';

class HomeMainMenuSubPage extends DefaultGetxPage {
  late final ControllerMember<HomeMainMenuSubController> _homeMainMenuSubController = ControllerMember<HomeMainMenuSubController>().addToControllerManager(controllerManager);
  final String ancestorPageName;

  HomeMainMenuSubPage({Key? key, required this.ancestorPageName}) : super(key: key);

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

  @override
  void initState() {
    super.initState();
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
      );
    widget.homeMainMenuSubController.setHomeMainMenuDelegate(
      HomeMainMenuDelegate(
        onObserveLoadProductDelegate: onObserveLoadProductDelegateFactory.generateOnObserveLoadProductDelegate(),
        onObserveSuccessLoadProductBundleHighlight: (onObserveSuccessLoadProductBundleHighlightParameter) {
          return PaddingContainerListItemControllerState(
            padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
            paddingChildListItemControllerState: CompoundListItemControllerState(
              listItemControllerState: [
                TitleAndDescriptionListItemControllerState(
                  title: "Save More With Bundles".tr,
                  titleAndDescriptionItemInterceptor: (padding, title, titleWidget, description, descriptionWidget, titleAndDescriptionWidget, titleAndDescriptionWidgetList) {
                    return Row(
                      children: [
                        Expanded(child: titleAndDescriptionWidget),
                        GestureDetector(
                          onTap: () => PageRestorationHelper.toProductBundlePage(context),
                          child: Text(
                            "More".tr,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold
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
                  productBundle: onObserveSuccessLoadProductBundleHighlightParameter.productBundle
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
      )
    );
    return Scaffold(
      appBar: DefaultSearchAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
                pagingControllerState: _homeMainMenuSubListItemPagingControllerState,
                onProvidePagedChildBuilderDelegate: (pagingControllerState) => ListItemPagingControllerStatePagedChildBuilderDelegate<int>(
                  pagingControllerState: pagingControllerState!
                ),
                pullToRefresh: true
              ),
            ),
          ]
        )
      ),
    );
  }
}