import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../controller/mainmenucontroller/mainmenusubpagecontroller/explore_nusantara_main_menu_sub_controller.dart';
import '../controller/mainmenucontroller/mainmenusubpagecontroller/feed_main_menu_sub_controller.dart';
import '../controller/mainmenucontroller/mainmenusubpagecontroller/home_main_menu_sub_controller.dart';
import '../controller/mainmenucontroller/mainmenusubpagecontroller/menu_main_menu_sub_controller.dart';
import '../controller/mainmenucontroller/mainmenusubpagecontroller/wishlist_main_menu_sub_controller.dart';
import '../data/datasource/coupondatasource/coupon_data_source.dart';
import '../data/datasource/coupondatasource/default_coupon_data_source.dart';
import '../data/datasource/feeddatasource/default_feed_data_source.dart';
import '../data/datasource/feeddatasource/feed_data_source.dart';
import '../data/datasource/productdatasource/default_product_data_source.dart';
import '../data/datasource/productdatasource/product_data_source.dart';
import '../data/datasource/userdatasource/default_user_data_source.dart';
import '../data/datasource/userdatasource/user_data_source.dart';
import '../data/repository/default_coupon_repository.dart';
import '../data/repository/default_feed_repository.dart';
import '../data/repository/default_product_repository.dart';
import '../data/repository/default_user_repository.dart';
import '../domain/dummy/coupondummy/coupon_dummy.dart';
import '../domain/dummy/deliveryreviewdummy/delivery_review_dummy.dart';
import '../domain/dummy/newsdummy/news_dummy.dart';
import '../domain/dummy/productdummy/product_brand_dummy.dart';
import '../domain/dummy/productdummy/product_bundle_dummy.dart';
import '../domain/dummy/productdummy/product_category_dummy.dart';
import '../domain/dummy/productdummy/product_certification_dummy.dart';
import '../domain/dummy/productdummy/product_dummy.dart';
import '../domain/dummy/productdummy/product_entry_dummy.dart';
import '../domain/dummy/productdummy/product_variant_dummy.dart';
import '../domain/dummy/provincedummy/province_dummy.dart';
import '../domain/repository/coupon_repository.dart';
import '../domain/repository/feed_repository.dart';
import '../domain/repository/product_repository.dart';
import '../domain/repository/user_repository.dart';
import '../domain/usecase/add_wishlist_use_case.dart';
import '../domain/usecase/get_coupon_paging_use_case.dart';
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
import '../domain/usecase/get_short_video_use_case.dart';
import '../domain/usecase/get_snack_for_lying_around_list_use_case.dart';
import '../domain/usecase/get_trip_default_video_use_case.dart';
import '../domain/usecase/get_user_use_case.dart';
import '../domain/usecase/get_wishlist_paging_use_case.dart';
import '../domain/usecase/login_use_case.dart';
import '../domain/usecase/login_with_google_use_case.dart';
import '../domain/usecase/logout_use_case.dart';
import '../domain/usecase/register_use_case.dart';
import '../domain/usecase/register_with_google_use_case.dart';
import '../domain/usecase/remove_wishlist_use_case.dart';
import 'additionalloadingindicatorchecker/coupon_additional_paging_result_parameter_checker.dart';
import 'additionalloadingindicatorchecker/feed_sub_additional_paging_result_parameter_checker.dart';
import 'additionalloadingindicatorchecker/home_sub_additional_paging_result_parameter_checker.dart';
import 'additionalloadingindicatorchecker/product_brand_detail_additional_paging_result_parameter_checker.dart';
import 'additionalloadingindicatorchecker/product_bundle_additional_paging_result_parameter_checker.dart';
import 'additionalloadingindicatorchecker/product_bundle_detail_additional_paging_result_parameter_checker.dart';
import 'additionalloadingindicatorchecker/product_category_detail_additional_paging_result_parameter_checker.dart';
import 'additionalloadingindicatorchecker/product_detail_additional_paging_result_parameter_checker.dart';
import 'additionalloadingindicatorchecker/wishlist_sub_additional_paging_result_parameter_checker.dart';
import 'defaultloaddataresultwidget/default_load_data_result_widget.dart';
import 'defaultloaddataresultwidget/main_default_load_data_result_widget.dart';
import 'entityandlistitemcontrollerstatemediator/horizontal_component_entity_parameterized_entity_and_list_item_controller_state_mediator.dart';
import 'entityandlistitemcontrollerstatemediator/horizontal_entity_and_list_item_controller_state_mediator.dart';
import 'errorprovider/default_error_provider.dart';
import 'errorprovider/error_provider.dart';
import 'http_client.dart';
import 'on_observe_load_product_delegate.dart';
import 'shimmercarousellistitemgenerator/factory/coupon_shimmer_carousel_list_item_generator_factory.dart';
import 'shimmercarousellistitemgenerator/factory/delivery_review_shimmer_carousel_list_item_generator_factory.dart';
import 'shimmercarousellistitemgenerator/factory/news_shimmer_carousel_list_item_generator_factory.dart';
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
        getProductBundleListUseCase: locator(),
        getProductBundleHighlightUseCase: locator(),
        getSnackForLyingAroundListUseCase: locator(),
        getBestsellerInMasterbagasiListUseCase: locator(),
        getCoffeeAndTeaOriginIndonesiaListUseCase: locator(),
        getHandycraftsContentsBannerUseCase: locator(),
        getKitchenContentsBannerUseCase: locator(),
        addWishlistUseCase: locator()
      )
    );
    locator.registerLazySingleton<FeedMainMenuSubControllerInjectionFactory>(
      () => FeedMainMenuSubControllerInjectionFactory(
        getShortVideoUseCase: locator(),
        getDeliveryReviewUseCase: locator(),
        getNewsUseCase: locator(),
        getTripDefaultVideoUseCase: locator()
      )
    );
    locator.registerLazySingleton<ExploreNusantaraMainMenuSubControllerInjectionFactory>(
      () => ExploreNusantaraMainMenuSubControllerInjectionFactory()
    );
    locator.registerLazySingleton<WishlistMainMenuSubControllerInjectionFactory>(
      () => WishlistMainMenuSubControllerInjectionFactory(
        getWishlistPagingUseCase: locator(),
        removeWishlistUseCase: locator()
      )
    );
    locator.registerLazySingleton<MenuMainMenuSubControllerInjectionFactory>(
      () => MenuMainMenuSubControllerInjectionFactory()
    );

    // Error Provider
    locator.registerLazySingleton<ErrorProvider>(() => DefaultErrorProvider());

    // Entity And List Item Controller State Mediator
    locator.registerLazySingleton<HorizontalParameterizedEntityAndListItemControllerStateMediator>(() => HorizontalParameterizedEntityAndListItemControllerStateMediator());
    locator.registerLazySingleton<HorizontalComponentEntityParameterizedEntityAndListItemControllerStateMediator>(
      () => HorizontalComponentEntityParameterizedEntityAndListItemControllerStateMediator(
        horizontalEntityAndListItemControllerStateMediator: locator(),
        errorProvider: locator()
      )
    );

    // On Observe Load Product Delegate Factory
    locator.registerFactory<OnObserveLoadProductDelegateFactory>(
      () => OnObserveLoadProductDelegateFactory()
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
    locator.registerLazySingleton<DeliveryReviewDummy>(() => DeliveryReviewDummy());
    locator.registerLazySingleton<NewsDummy>(() => NewsDummy());
    locator.registerLazySingleton<CouponDummy>(() => CouponDummy());

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
    locator.registerFactory<DeliveryReviewShimmerCarouselListItemGeneratorFactory>(
      () => DeliveryReviewShimmerCarouselListItemGeneratorFactory(
        deliveryReviewDummy: locator()
      )
    );
    locator.registerFactory<NewsShimmerCarouselListItemGeneratorFactory>(
      () => NewsShimmerCarouselListItemGeneratorFactory(
        newsDummy: locator()
      )
    );
    locator.registerFactory<CouponShimmerCarouselListItemGeneratorFactory>(
      () => CouponShimmerCarouselListItemGeneratorFactory(
        couponDummy: locator()
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
    locator.registerFactory<WishlistSubAdditionalPagingResultParameterChecker>(
      () => WishlistSubAdditionalPagingResultParameterChecker()
    );
    locator.registerFactory<FeedSubAdditionalPagingResultParameterChecker>(
      () => FeedSubAdditionalPagingResultParameterChecker()
    );
    locator.registerFactory<CouponAdditionalPagingResultParameterChecker>(
      () => CouponAdditionalPagingResultParameterChecker()
    );

    // Default Load Data Result Widget
    locator.registerLazySingleton<DefaultLoadDataResultWidget>(() => MainDefaultLoadDataResultWidget());

    // Use Case
    locator.registerLazySingleton<LoginUseCase>(() => LoginUseCase(userRepository: locator()));
    locator.registerLazySingleton<LoginWithGoogleUseCase>(() => LoginWithGoogleUseCase(userRepository: locator()));
    locator.registerLazySingleton<RegisterUseCase>(() => RegisterUseCase(userRepository: locator()));
    locator.registerLazySingleton<RegisterWithGoogleUseCase>(() => RegisterWithGoogleUseCase(userRepository: locator()));
    locator.registerLazySingleton<LogoutUseCase>(() => LogoutUseCase(userRepository: locator()));
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
    locator.registerLazySingleton<GetWishlistPagingUseCase>(() => GetWishlistPagingUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetSnackForLyingAroundListUseCase>(() => GetSnackForLyingAroundListUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetBestsellerInMasterbagasiListUseCase>(() => GetBestsellerInMasterbagasiListUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetCoffeeAndTeaOriginIndonesiaListUseCase>(() => GetCoffeeAndTeaOriginIndonesiaListUseCase(productRepository: locator()));
    locator.registerLazySingleton<AddWishlistUseCase>(() => AddWishlistUseCase(productRepository: locator()));
    locator.registerLazySingleton<RemoveWishlistUseCase>(() => RemoveWishlistUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetShortVideoUseCase>(() => GetShortVideoUseCase(feedRepository: locator()));
    locator.registerLazySingleton<GetDeliveryReviewUseCase>(() => GetDeliveryReviewUseCase(feedRepository: locator()));
    locator.registerLazySingleton<GetNewsUseCase>(() => GetNewsUseCase(feedRepository: locator()));
    locator.registerLazySingleton<GetTripDefaultVideoUseCase>(() => GetTripDefaultVideoUseCase(feedRepository: locator()));
    locator.registerLazySingleton<GetKitchenContentsBannerUseCase>(() => GetKitchenContentsBannerUseCase(bannerRepository: locator()));
    locator.registerLazySingleton<GetHandycraftsContentsBannerUseCase>(() => GetHandycraftsContentsBannerUseCase(bannerRepository: locator()));
    locator.registerLazySingleton<GetCouponPagingUseCase>(() => GetCouponPagingUseCase(couponRepository: locator()));

    // Repository
    locator.registerLazySingleton<UserRepository>(() => DefaultUserRepository(userDataSource: locator()));
    locator.registerLazySingleton<FeedRepository>(() => DefaultFeedRepository(feedDataSource: locator()));
    locator.registerLazySingleton<BannerRepository>(() => DefaultBannerRepository(bannerDataSource: locator()));
    locator.registerLazySingleton<ProductRepository>(() => DefaultProductRepository(productDataSource: locator()));
    locator.registerLazySingleton<CouponRepository>(() => DefaultCouponRepository(couponDataSource: locator()));

    // Data Sources
    locator.registerLazySingleton<UserDataSource>(() => DefaultUserDataSource(dio: locator()));
    locator.registerLazySingleton<BannerDataSource>(() => DefaultBannerDataSource(dio: locator()));
    locator.registerLazySingleton<FeedDataSource>(() => DefaultFeedDataSource(dio: locator()));
    locator.registerLazySingleton<ProductDataSource>(
      () => DefaultProductDataSource(
        dio: locator(),
        productBundleDummy: locator(),
        productEntryDummy: locator()
      )
    );
    locator.registerLazySingleton<CouponDataSource>(() => DefaultCouponDataSource(dio: locator()));

    // Dio
    locator.registerLazySingleton<Dio>(() => DioHttpClient.of());
  }
}

// ignore: non_constant_identifier_names
final Injector = _Injector();