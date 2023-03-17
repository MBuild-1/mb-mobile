import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Banner;
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import '../../../../controller/mainmenucontroller/mainmenusubpagecontroller/home_main_menu_sub_controller.dart';
import '../../../../domain/entity/banner/banner.dart';
import '../../../../domain/entity/homemainmenucomponententity/banner_home_main_menu_component_entity.dart';
import '../../../../domain/entity/homemainmenucomponententity/check_rates_for_various_countries_component_entity.dart';
import '../../../../domain/entity/homemainmenucomponententity/dynamic_item_carousel_home_main_menu_component_entity.dart';
import '../../../../domain/entity/homemainmenucomponententity/home_main_menu_component_entity.dart';
import '../../../../domain/entity/homemainmenucomponententity/item_carousel_home_main_menu_component_entity.dart';
import '../../../../domain/entity/homemainmenucomponententity/separator_home_main_menu_component_entity.dart';
import '../../../../domain/entity/location/location.dart';
import '../../../../misc/additionalloadingindicatorchecker/home_sub_additional_paging_result_parameter_checker.dart';
import '../../../../misc/aspect_ratio_value.dart';
import '../../../../misc/constant.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/carousel_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/check_rates_for_various_countries_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/colorful_divider_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/delivery_to_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/failed_prompt_indicator_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/load_data_result_dynamic_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/single_banner_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import '../../../../misc/controllerstate/paging_controller_state.dart';
import '../../../../misc/entityandlistitemcontrollerstatemediator/horizontal_entity_and_list_item_controller_state_mediator.dart';
import '../../../../misc/error/message_error.dart';
import '../../../../misc/errorprovider/error_provider.dart';
import '../../../../misc/injector.dart';
import '../../../../misc/load_data_result.dart';
import '../../../../misc/manager/controller_manager.dart';
import '../../../../misc/paging/modified_paging_controller.dart';
import '../../../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../../../misc/paging/pagingresult/paging_data_result.dart';
import '../../../../misc/paging/pagingresult/paging_result.dart';
import '../../../../misc/shimmercarousellistitemgenerator/factory/product_brand_shimmer_carousel_list_item_generator_factory.dart';
import '../../../../misc/shimmercarousellistitemgenerator/factory/product_bundle_shimmer_carousel_list_item_generator_factory.dart';
import '../../../../misc/shimmercarousellistitemgenerator/factory/product_category_shimmer_carousel_list_item_generator_factory.dart';
import '../../../../misc/shimmercarousellistitemgenerator/factory/product_shimmer_carousel_list_item_generator_factory.dart';
import '../../../../misc/shimmercarousellistitemgenerator/type/product_brand_shimmer_carousel_list_item_generator_type.dart';
import '../../../../misc/shimmercarousellistitemgenerator/type/product_bundle_shimmer_carousel_list_item_generator_type.dart';
import '../../../../misc/shimmercarousellistitemgenerator/type/product_category_shimmer_carousel_list_item_generator_type.dart';
import '../../../../misc/shimmercarousellistitemgenerator/type/product_shimmer_carousel_list_item_generator_type.dart';
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
      } else if (homeMainMenuComponentEntity is ItemCarouselHomeMainMenuComponentEntity) {
        listItemControllerStateList.add(
          CarouselListItemControllerState(
            title: homeMainMenuComponentEntity.title.toEmptyStringNonNull,
            description: homeMainMenuComponentEntity.description.toEmptyStringNonNull,
            padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
            itemListItemControllerState: homeMainMenuComponentEntity.item.map<ListItemControllerState>(
              Injector.locator<HorizontalEntityAndListItemControllerStateMediator>().map
            ).toList()
          )
        );
      } else if (homeMainMenuComponentEntity is DynamicItemCarouselHomeMainMenuComponentEntity) {
        LoadDataResultDynamicListItemControllerState dynamicList = LoadDataResultDynamicListItemControllerState(
          loadDataResult: IsLoadingLoadDataResult(),
          errorProvider: Injector.locator<ErrorProvider>(),
          isLoadingListItemControllerState: (listItemControllerState) {
            if (homeMainMenuComponentEntity.onObserveLoadingDynamicItemActionState != null) {
              return homeMainMenuComponentEntity.onObserveLoadingDynamicItemActionState!(
                homeMainMenuComponentEntity.title, homeMainMenuComponentEntity.description, IsLoadingLoadDataResult()
              );
            }
            return ShimmerCarouselListItemControllerState<ProductShimmerCarouselListItemGeneratorType>(
              padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
              showTitleShimmer: true,
              showDescriptionShimmer: false,
              showItemShimmer: true,
              shimmerCarouselListItemGenerator: Injector.locator<ProductShimmerCarouselListItemGeneratorFactory>().getShimmerCarouselListItemGeneratorType()
            );
          },
          successListItemControllerState: (data) {
            return homeMainMenuComponentEntity.onObserveSuccessDynamicItemActionState(
              homeMainMenuComponentEntity.title, homeMainMenuComponentEntity.description, SuccessLoadDataResult(value: data)
            );
          }
        );
        _dynamicItemLoadDataResultDynamicListItemControllerStateList.add(dynamicList);
        listItemControllerStateList.add(
          _dynamicItemLoadDataResultDynamicListItemControllerStateList.last
        );
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          homeMainMenuComponentEntity.onDynamicItemAction(
            homeMainMenuComponentEntity.title,
            homeMainMenuComponentEntity.description,
            (title, description, itemLoadDataResult) {
              dynamicList.loadDataResult = itemLoadDataResult;
              setState(() {});
            }
          );
        });
      } else if (homeMainMenuComponentEntity is CheckRatesForVariousCountriesComponentEntity) {
        listItemControllerStateList.add(
          CheckRatesForVariousCountriesControllerState()
        );
      } else {
        listItemControllerStateList.add(
          FailedPromptIndicatorListItemControllerState(
            errorProvider: Injector.locator<ErrorProvider>(),
            e: FailedLoadDataResult.throwException(() => throw MessageError(
              title: "Item Not Showed",
              message: "This item cannot be showed ${kDebugMode ? "(${homeMainMenuComponentEntity.runtimeType})" : ""}"
            ))!.e,
          )
        );
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
    widget.homeMainMenuSubController.setHomeMainMenuDelegate(
      HomeMainMenuDelegate(
        onObserveSuccessLoadProductBrandCarousel: (onObserveSuccessLoadProductBrandCarouselParameter) {
          return CarouselListItemControllerState(
            title: onObserveSuccessLoadProductBrandCarouselParameter.title.toEmptyStringNonNull,
            description: onObserveSuccessLoadProductBrandCarouselParameter.description.toEmptyStringNonNull,
            padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
            itemListItemControllerState: onObserveSuccessLoadProductBrandCarouselParameter.productBrandList.map<ListItemControllerState>(
              Injector.locator<HorizontalEntityAndListItemControllerStateMediator>().map
            ).toList()
          );
        },
        onObserveLoadingLoadProductBrandCarousel: (onObserveLoadingLoadProductBrandCarouselParameter) {
          return ShimmerCarouselListItemControllerState<ProductBrandShimmerCarouselListItemGeneratorType>(
            padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
            showTitleShimmer: true,
            showDescriptionShimmer: false,
            showItemShimmer: true,
            shimmerCarouselListItemGenerator: Injector.locator<ProductBrandShimmerCarouselListItemGeneratorFactory>().getShimmerCarouselListItemGeneratorType()
          );
        },
        onObserveSuccessLoadProductCategoryCarousel: (onObserveSuccessLoadProductCategoryCarouselParameter) {
          return CarouselListItemControllerState(
            title: onObserveSuccessLoadProductCategoryCarouselParameter.title.toEmptyStringNonNull,
            description: onObserveSuccessLoadProductCategoryCarouselParameter.description.toEmptyStringNonNull,
            padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
            itemListItemControllerState: onObserveSuccessLoadProductCategoryCarouselParameter.productCategoryList.map<ListItemControllerState>(
              Injector.locator<HorizontalEntityAndListItemControllerStateMediator>().map
            ).toList()
          );
        },
        onObserveLoadingLoadProductCategoryCarousel: (onObserveLoadingLoadProductCategoryCarouselParameter) {
          return ShimmerCarouselListItemControllerState<ProductCategoryShimmerCarouselListItemGeneratorType>(
            padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
            showTitleShimmer: true,
            showDescriptionShimmer: false,
            showItemShimmer: true,
            shimmerCarouselListItemGenerator: Injector.locator<ProductCategoryShimmerCarouselListItemGeneratorFactory>().getShimmerCarouselListItemGeneratorType()
          );
        },
        onObserveSuccessLoadProductEntryCarousel: (onObserveSuccessLoadProductEntryCarouselParameter) {
          return CarouselListItemControllerState(
            title: onObserveSuccessLoadProductEntryCarouselParameter.title.toEmptyStringNonNull,
            description: onObserveSuccessLoadProductEntryCarouselParameter.description.toEmptyStringNonNull,
            padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
            itemListItemControllerState: onObserveSuccessLoadProductEntryCarouselParameter.productEntryList.map<ListItemControllerState>(
              Injector.locator<HorizontalEntityAndListItemControllerStateMediator>().map
            ).toList()
          );
        },
        onObserveLoadingLoadProductEntryCarousel: (onObserveLoadingLoadProductEntryCarouselParameter) {
          return ShimmerCarouselListItemControllerState<ProductShimmerCarouselListItemGeneratorType>(
            padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
            showTitleShimmer: true,
            showDescriptionShimmer: false,
            showItemShimmer: true,
            shimmerCarouselListItemGenerator: Injector.locator<ProductShimmerCarouselListItemGeneratorFactory>().getShimmerCarouselListItemGeneratorType()
          );
        },
        onObserveSuccessLoadProductBundleCarousel: (onObserveSuccessLoadProductBundleCarouselParameter) {
          return CarouselListItemControllerState(
            title: onObserveSuccessLoadProductBundleCarouselParameter.title.toEmptyStringNonNull,
            description: onObserveSuccessLoadProductBundleCarouselParameter.description.toEmptyStringNonNull,
            padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
            itemListItemControllerState: onObserveSuccessLoadProductBundleCarouselParameter.productBundleList.map<ListItemControllerState>(
              Injector.locator<HorizontalEntityAndListItemControllerStateMediator>().map
            ).toList()
          );
        },
        onObserveLoadingLoadProductBundleCarousel: (onObserveLoadingLoadProductBundleCarouselParameter) {
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