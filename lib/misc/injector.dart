import 'package:dio/dio.dart';
import 'package:flutter/painting.dart';
import 'package:get_it/get_it.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../controller/mainmenucontroller/mainmenusubpagecontroller/explore_nusantara_main_menu_sub_controller.dart';
import '../controller/mainmenucontroller/mainmenusubpagecontroller/feed_main_menu_sub_controller.dart';
import '../controller/mainmenucontroller/mainmenusubpagecontroller/home_main_menu_sub_controller.dart';
import '../controller/mainmenucontroller/mainmenusubpagecontroller/menu_main_menu_sub_controller.dart';
import '../controller/mainmenucontroller/mainmenusubpagecontroller/wishlist_main_menu_sub_controller.dart';
import '../data/datasource/productdatasource/default_product_data_source.dart';
import '../data/datasource/productdatasource/product_data_source.dart';
import '../data/datasource/userdatasource/default_user_data_source.dart';
import '../data/datasource/userdatasource/user_data_source.dart';
import '../data/repository/default_product_repository.dart';
import '../data/repository/default_user_repository.dart';
import '../domain/dummy/productdummy/product_brand_dummy.dart';
import '../domain/dummy/productdummy/product_bundle_dummy.dart';
import '../domain/dummy/productdummy/product_category_dummy.dart';
import '../domain/dummy/productdummy/product_certification_dummy.dart';
import '../domain/dummy/productdummy/product_dummy.dart';
import '../domain/dummy/productdummy/product_entry_dummy.dart';
import '../domain/dummy/productdummy/product_variant_dummy.dart';
import '../domain/dummy/provincedummy/province_dummy.dart';
import '../domain/repository/product_repository.dart';
import '../domain/repository/user_repository.dart';
import '../domain/usecase/get_product_brand_detail_use_case.dart';
import '../domain/usecase/get_product_brand_use_case.dart';
import '../domain/usecase/get_product_bundle_detail_use_case.dart';
import '../domain/usecase/get_product_bundle_highlight_use_case.dart';
import '../domain/usecase/get_product_bundle_list_use_case.dart';
import '../domain/usecase/get_product_bundle_paging_use_case.dart';
import '../domain/usecase/get_product_category_detail_use_case.dart';
import '../domain/usecase/get_product_category_list_use_case.dart';
import '../domain/usecase/get_product_detail_from_your_search_product_entry_list_use_case.dart';
import '../domain/usecase/get_product_detail_other_chosen_for_you_product_entry_list_use_case.dart';
import '../domain/usecase/get_product_detail_other_from_this_brand_product_entry_list_use_case.dart';
import '../domain/usecase/get_product_detail_other_in_this_category_product_entry_list_use_case.dart';
import '../domain/usecase/get_product_detail_other_interested_product_brand_list_use_case.dart';
import '../domain/usecase/get_product_detail_use_case.dart';
import '../domain/usecase/get_product_list_use_case.dart';
import '../domain/usecase/get_product_viral_list_use_case.dart';
import '../domain/usecase/get_user_use_case.dart';
import '../domain/usecase/login_use_case.dart';
import '../domain/usecase/register_use_case.dart';
import 'additionalloadingindicatorchecker/home_sub_additional_paging_result_parameter_checker.dart';
import 'additionalloadingindicatorchecker/product_brand_detail_additional_paging_result_parameter_checker.dart';
import 'additionalloadingindicatorchecker/product_bundle_additional_paging_result_parameter_checker.dart';
import 'additionalloadingindicatorchecker/product_bundle_detail_additional_paging_result_parameter_checker.dart';
import 'additionalloadingindicatorchecker/product_category_detail_additional_paging_result_parameter_checker.dart';
import 'additionalloadingindicatorchecker/product_detail_additional_paging_result_parameter_checker.dart';
import 'constant.dart';
import 'controllerstate/listitemcontrollerstate/carousel_list_item_controller_state.dart';
import 'controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import 'defaultloaddataresultwidget/default_load_data_result_widget.dart';
import 'defaultloaddataresultwidget/main_default_load_data_result_widget.dart';
import 'entityandlistitemcontrollerstatemediator/horizontal_component_entity_parameterized_entity_and_list_item_controller_state_mediator.dart';
import 'entityandlistitemcontrollerstatemediator/horizontal_entity_and_list_item_controller_state_mediator.dart';
import 'errorprovider/default_error_provider.dart';
import 'errorprovider/error_provider.dart';
import 'http_client.dart';
import 'on_observe_load_product_delegate.dart';
import 'shimmercarousellistitemgenerator/factory/product_brand_shimmer_carousel_list_item_generator_factory.dart';
import 'shimmercarousellistitemgenerator/factory/product_bundle_shimmer_carousel_list_item_generator_factory.dart';
import 'shimmercarousellistitemgenerator/factory/product_category_shimmer_carousel_list_item_generator_factory.dart';
import 'shimmercarousellistitemgenerator/factory/product_shimmer_carousel_list_item_generator_factory.dart';
import 'shimmercarousellistitemgenerator/type/product_brand_shimmer_carousel_list_item_generator_type.dart';
import 'shimmercarousellistitemgenerator/type/product_bundle_shimmer_carousel_list_item_generator_type.dart';
import 'shimmercarousellistitemgenerator/type/product_category_shimmer_carousel_list_item_generator_type.dart';
import 'shimmercarousellistitemgenerator/type/product_shimmer_carousel_list_item_generator_type.dart';

class _Injector {
  final GetIt locator = GetIt.instance;

  void init() {
    // Controller Injection Factory
    locator.registerLazySingleton<HomeMainMenuSubControllerInjectionFactory>(
      () => HomeMainMenuSubControllerInjectionFactory(
        getProductViralListUseCase: locator(),
        getProductCategoryListUseCase: locator(),
        getProductBrandListUseCase: locator(),
        getProductBundleListUseCase: locator(),
        getProductBundleHighlightUseCase: locator()
      )
    );
    locator.registerLazySingleton<FeedMainMenuSubControllerInjectionFactory>(
      () => FeedMainMenuSubControllerInjectionFactory()
    );
    locator.registerLazySingleton<ExploreNusantaraMainMenuSubControllerInjectionFactory>(
      () => ExploreNusantaraMainMenuSubControllerInjectionFactory()
    );
    locator.registerLazySingleton<WishlistMainMenuSubControllerInjectionFactory>(
      () => WishlistMainMenuSubControllerInjectionFactory()
    );
    locator.registerLazySingleton<MenuMainMenuSubControllerInjectionFactory>(
      () => MenuMainMenuSubControllerInjectionFactory()
    );

    // Error Provider
    locator.registerLazySingleton<ErrorProvider>(() => DefaultErrorProvider());

    // Entity And List Item Controller State Mediator
    locator.registerLazySingleton<HorizontalEntityAndListItemControllerStateMediator>(() => HorizontalEntityAndListItemControllerStateMediator());
    locator.registerLazySingleton<HorizontalComponentEntityParameterizedEntityAndListItemControllerStateMediator>(
      () => HorizontalComponentEntityParameterizedEntityAndListItemControllerStateMediator(
        horizontalEntityAndListItemControllerStateMediator: locator(),
        errorProvider: locator()
      )
    );

    // On Observe Load Product Delegate
    locator.registerLazySingleton<OnObserveLoadProductDelegate>(
      () => OnObserveLoadProductDelegate(
        onObserveSuccessLoadProductBrandCarousel: (onObserveSuccessLoadProductBrandCarouselParameter) {
          return CarouselListItemControllerState(
            title: onObserveSuccessLoadProductBrandCarouselParameter.title.toEmptyStringNonNull,
            description: onObserveSuccessLoadProductBrandCarouselParameter.description.toEmptyStringNonNull,
            padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
            itemListItemControllerState: onObserveSuccessLoadProductBrandCarouselParameter.productBrandList.map<ListItemControllerState>(
              locator<HorizontalEntityAndListItemControllerStateMediator>().map
            ).toList()
          );
        },
        onObserveLoadingLoadProductBrandCarousel: (onObserveLoadingLoadProductBrandCarouselParameter) {
          return ShimmerCarouselListItemControllerState<ProductBrandShimmerCarouselListItemGeneratorType>(
            padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
            showTitleShimmer: true,
            showDescriptionShimmer: false,
            showItemShimmer: true,
            shimmerCarouselListItemGenerator: locator<ProductBrandShimmerCarouselListItemGeneratorFactory>().getShimmerCarouselListItemGeneratorType()
          );
        },
        onObserveSuccessLoadProductCategoryCarousel: (onObserveSuccessLoadProductCategoryCarouselParameter) {
          return CarouselListItemControllerState(
            title: onObserveSuccessLoadProductCategoryCarouselParameter.title.toEmptyStringNonNull,
            description: onObserveSuccessLoadProductCategoryCarouselParameter.description.toEmptyStringNonNull,
            padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
            itemListItemControllerState: onObserveSuccessLoadProductCategoryCarouselParameter.productCategoryList.map<ListItemControllerState>(
              locator<HorizontalEntityAndListItemControllerStateMediator>().map
            ).toList()
          );
        },
        onObserveLoadingLoadProductCategoryCarousel: (onObserveLoadingLoadProductCategoryCarouselParameter) {
          return ShimmerCarouselListItemControllerState<ProductCategoryShimmerCarouselListItemGeneratorType>(
            padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
            showTitleShimmer: true,
            showDescriptionShimmer: false,
            showItemShimmer: true,
            shimmerCarouselListItemGenerator: locator<ProductCategoryShimmerCarouselListItemGeneratorFactory>().getShimmerCarouselListItemGeneratorType()
          );
        },
        onObserveSuccessLoadProductEntryCarousel: (onObserveSuccessLoadProductEntryCarouselParameter) {
          return CarouselListItemControllerState(
            title: onObserveSuccessLoadProductEntryCarouselParameter.title.toEmptyStringNonNull,
            description: onObserveSuccessLoadProductEntryCarouselParameter.description.toEmptyStringNonNull,
            padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
            itemListItemControllerState: onObserveSuccessLoadProductEntryCarouselParameter.productEntryList.map<ListItemControllerState>(
              locator<HorizontalEntityAndListItemControllerStateMediator>().map
            ).toList()
          );
        },
        onObserveLoadingLoadProductEntryCarousel: (onObserveLoadingLoadProductEntryCarouselParameter) {
          return ShimmerCarouselListItemControllerState<ProductShimmerCarouselListItemGeneratorType>(
            padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
            showTitleShimmer: true,
            showDescriptionShimmer: false,
            showItemShimmer: true,
            shimmerCarouselListItemGenerator: locator<ProductShimmerCarouselListItemGeneratorFactory>().getShimmerCarouselListItemGeneratorType()
          );
        },
        onObserveSuccessLoadProductBundleCarousel: (onObserveSuccessLoadProductBundleCarouselParameter) {
          return CarouselListItemControllerState(
            title: onObserveSuccessLoadProductBundleCarouselParameter.title.toEmptyStringNonNull,
            description: onObserveSuccessLoadProductBundleCarouselParameter.description.toEmptyStringNonNull,
            padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
            itemListItemControllerState: onObserveSuccessLoadProductBundleCarouselParameter.productBundleList.map<ListItemControllerState>(
              locator<HorizontalEntityAndListItemControllerStateMediator>().map
            ).toList()
          );
        },
        onObserveLoadingLoadProductBundleCarousel: (onObserveLoadingLoadProductBundleCarouselParameter) {
          return ShimmerCarouselListItemControllerState<ProductBundleShimmerCarouselListItemGeneratorType>(
            padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
            showTitleShimmer: true,
            showDescriptionShimmer: false,
            showItemShimmer: true,
            shimmerCarouselListItemGenerator: locator<ProductBundleShimmerCarouselListItemGeneratorFactory>().getShimmerCarouselListItemGeneratorType()
          );
        },
      )
    );

    // Dummy
    locator.registerLazySingleton<ProductDummy>(
      () => ProductDummy(
        productBrandDummy: locator(),
        productCategoryDummy: locator(),
        productCertificationDummy: locator(),
        provinceDummy: locator(),
      )
    );
    locator.registerLazySingleton<ProductEntryDummy>(() => ProductEntryDummy(productDummy: locator()));
    locator.registerLazySingleton<ProvinceDummy>(() => ProvinceDummy());
    locator.registerLazySingleton<ProductBrandDummy>(() => ProductBrandDummy());
    locator.registerLazySingleton<ProductCategoryDummy>(() => ProductCategoryDummy());
    locator.registerLazySingleton<ProductCertificationDummy>(() => ProductCertificationDummy());
    locator.registerLazySingleton<ProductVariantDummy>(() => ProductVariantDummy());
    locator.registerLazySingleton<ProductBundleDummy>(() => ProductBundleDummy());

    // Shimmer Carousel List Item Generator
    locator.registerFactory<ProductShimmerCarouselListItemGeneratorFactory>(
      () => ProductShimmerCarouselListItemGeneratorFactory(
        productDummy: locator()
      )
    );
    locator.registerFactory<ProductCategoryShimmerCarouselListItemGeneratorFactory>(
      () => ProductCategoryShimmerCarouselListItemGeneratorFactory(
        productCategoryDummy: locator()
      )
    );
    locator.registerFactory<ProductBundleShimmerCarouselListItemGeneratorFactory>(
      () => ProductBundleShimmerCarouselListItemGeneratorFactory(
        productBundleDummy: locator()
      )
    );
    locator.registerFactory<ProductBrandShimmerCarouselListItemGeneratorFactory>(
      () => ProductBrandShimmerCarouselListItemGeneratorFactory(
        productBrandDummy: locator()
      )
    );

    // Additional Paging Result Parameter
    locator.registerFactory<HomeSubAdditionalPagingResultParameterChecker>(
      () => HomeSubAdditionalPagingResultParameterChecker()
    );
    locator.registerFactory<ProductDetailAdditionalPagingResultParameterChecker>(
      () => ProductDetailAdditionalPagingResultParameterChecker()
    );
    locator.registerFactory<ProductBrandDetailAdditionalPagingResultParameterChecker>(
      () => ProductBrandDetailAdditionalPagingResultParameterChecker()
    );
    locator.registerFactory<ProductCategoryDetailAdditionalPagingResultParameterChecker>(
      () => ProductCategoryDetailAdditionalPagingResultParameterChecker()
    );
    locator.registerFactory<ProductBundleAdditionalPagingResultParameterChecker>(
      () => ProductBundleAdditionalPagingResultParameterChecker()
    );
    locator.registerFactory<ProductBundleDetailAdditionalPagingResultParameterChecker>(
      () => ProductBundleDetailAdditionalPagingResultParameterChecker()
    );

    // Default Load Data Result Widget
    locator.registerLazySingleton<DefaultLoadDataResultWidget>(() => MainDefaultLoadDataResultWidget());

    // Use Case
    locator.registerLazySingleton<LoginUseCase>(() => LoginUseCase(userRepository: locator()));
    locator.registerLazySingleton<RegisterUseCase>(() => RegisterUseCase(userRepository: locator()));
    locator.registerLazySingleton<GetUserUseCase>(() => GetUserUseCase(userRepository: locator()));
    locator.registerLazySingleton<GetProductBrandListUseCase>(() => GetProductBrandListUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetProductBrandDetailUseCase>(() => GetProductBrandDetailUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetProductListUseCase>(() => GetProductListUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetProductViralListUseCase>(() => GetProductViralListUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetProductDetailUseCase>(() => GetProductDetailUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetProductDetailOtherChosenForYouProductEntryListUseCase>(() => GetProductDetailOtherChosenForYouProductEntryListUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetProductDetailOtherFromThisBrandProductEntryListUseCase>(() => GetProductDetailOtherFromThisBrandProductEntryListUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetProductDetailOtherInThisCategoryProductEntryListUseCase>(() => GetProductDetailOtherInThisCategoryProductEntryListUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetProductDetailFromYourSearchProductEntryListUseCase>(() => GetProductDetailFromYourSearchProductEntryListUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetProductDetailOtherInterestedProductBrandListUseCase>(() => GetProductDetailOtherInterestedProductBrandListUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetProductCategoryListUseCase>(() => GetProductCategoryListUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetProductCategoryDetailUseCase>(() => GetProductCategoryDetailUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetProductBundleListUseCase>(() => GetProductBundleListUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetProductBundlePagingUseCase>(() => GetProductBundlePagingUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetProductBundleHighlightUseCase>(() => GetProductBundleHighlightUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetProductBundleDetailUseCase>(() => GetProductBundleDetailUseCase(productRepository: locator()));

    // Repository
    locator.registerLazySingleton<UserRepository>(() => DefaultUserRepository(userDataSource: locator()));
    locator.registerLazySingleton<ProductRepository>(() => DefaultProductRepository(productDataSource: locator()));

    // Data Sources
    locator.registerLazySingleton<UserDataSource>(() => DefaultUserDataSource(dio: locator()));
    locator.registerLazySingleton<ProductDataSource>(() => DefaultProductDataSource(dio: locator(), productBundleDummy: locator()));

    // Dio
    locator.registerLazySingleton<Dio>(() => DioHttpClient.of());
  }
}

// ignore: non_constant_identifier_names
final Injector = _Injector();