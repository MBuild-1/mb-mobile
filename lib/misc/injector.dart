import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

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
import '../domain/usecase/get_product_brand_use_case.dart';
import '../domain/usecase/get_product_bundle_use_case.dart';
import '../domain/usecase/get_product_category_list_use_case.dart';
import '../domain/usecase/get_product_detail_use_case.dart';
import '../domain/usecase/get_product_list_use_case.dart';
import '../domain/usecase/get_product_viral_list_use_case.dart';
import '../domain/usecase/get_user_use_case.dart';
import '../domain/usecase/login_use_case.dart';
import '../domain/usecase/register_use_case.dart';
import 'additionalloadingindicatorchecker/home_sub_additional_paging_result_parameter_checker.dart';
import 'additionalloadingindicatorchecker/product_detail_additional_paging_result_parameter_checker.dart';
import 'defaultloaddataresultwidget/default_load_data_result_widget.dart';
import 'defaultloaddataresultwidget/main_default_load_data_result_widget.dart';
import 'entityandlistitemcontrollerstatemediator/horizontal_entity_and_list_item_controller_state_mediator.dart';
import 'errorprovider/default_error_provider.dart';
import 'errorprovider/error_provider.dart';
import 'http_client.dart';
import 'shimmercarousellistitemgenerator/factory/product_brand_shimmer_carousel_list_item_generator_factory.dart';
import 'shimmercarousellistitemgenerator/factory/product_bundle_shimmer_carousel_list_item_generator_factory.dart';
import 'shimmercarousellistitemgenerator/factory/product_category_shimmer_carousel_list_item_generator_factory.dart';
import 'shimmercarousellistitemgenerator/factory/product_shimmer_carousel_list_item_generator_factory.dart';

class _Injector {
  final GetIt locator = GetIt.instance;

  void init() {
    // Controller Injection Factory
    locator.registerLazySingleton<HomeMainMenuSubControllerInjectionFactory>(
      () => HomeMainMenuSubControllerInjectionFactory(
        getProductViralListUseCase: locator(),
        getProductCategoryListUseCase: locator(),
        getProductBrandListUseCase: locator(),
        getProductBundleListUseCase: locator()
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

    // Default Load Data Result Widget
    locator.registerLazySingleton<DefaultLoadDataResultWidget>(() => MainDefaultLoadDataResultWidget());

    // Use Case
    locator.registerLazySingleton<LoginUseCase>(() => LoginUseCase(userRepository: locator()));
    locator.registerLazySingleton<RegisterUseCase>(() => RegisterUseCase(userRepository: locator()));
    locator.registerLazySingleton<GetUserUseCase>(() => GetUserUseCase(userRepository: locator()));
    locator.registerLazySingleton<GetProductBrandListUseCase>(() => GetProductBrandListUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetProductListUseCase>(() => GetProductListUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetProductViralListUseCase>(() => GetProductViralListUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetProductDetailUseCase>(() => GetProductDetailUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetProductCategoryListUseCase>(() => GetProductCategoryListUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetProductBundleListUseCase>(() => GetProductBundleListUseCase(productRepository: locator()));

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