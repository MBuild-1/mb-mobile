import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:masterbagasi/domain/usecase/get_product_list.dart';

import '../data/datasource/productdatasource/default_product_data_source.dart';
import '../data/datasource/productdatasource/product_data_source.dart';
import '../data/repository/default_product_repository.dart';
import '../domain/repository/product_repository.dart';
import '../domain/usecase/get_most_discount_product_from_cached_product_list.dart';
import '../domain/usecase/get_product_detail.dart';
import 'additionalloadingindicatorchecker/home_paging_result_parameter_checker.dart';
import 'additionalloadingindicatorchecker/product_detail_paging_result_parameter_checker.dart';
import 'additionalloadingindicatorchecker/product_paging_result_parameter_checker.dart';
import 'defaultloaddataresultwidget/default_load_data_result_widget.dart';
import 'defaultloaddataresultwidget/main_default_load_data_result_widget.dart';
import 'errorprovider/default_error_provider.dart';
import 'errorprovider/error_provider.dart';
import 'http_client.dart';
import 'shimmercarousellistitemgenerator/factory/product_shimmer_carousel_list_item_generator_factory.dart';

class _Injector {
  final GetIt locator = GetIt.instance;

  void init() {
    // Error Provider
    locator.registerLazySingleton<ErrorProvider>(() => DefaultErrorProvider());
    
    // Shimmer Carousel List Item Generator
    locator.registerFactory<ProductShimmerCarouselListItemGeneratorFactory>(() => ProductShimmerCarouselListItemGeneratorFactory());

    // Additional Paging Result Parameter
    locator.registerFactory<HomePagingResultParameterChecker>(
      () => HomePagingResultParameterChecker(
        productShimmerCarouselListItemGeneratorFactory: locator()
      )
    );
    locator.registerFactory<ProductPagingResultParameterChecker>(
      () => ProductPagingResultParameterChecker(
        productShimmerCarouselListItemGeneratorFactory: locator()
      )
    );
    locator.registerFactory<ProductDetailPagingResultParameterChecker>(
      () => ProductDetailPagingResultParameterChecker()
    );

    // Default Load Data Result Widget
    locator.registerLazySingleton<DefaultLoadDataResultWidget>(() => MainDefaultLoadDataResultWidget());

    // Use Case
    locator.registerLazySingleton<GetProductList>(() => GetProductList(productRepository: locator()));
    locator.registerLazySingleton<GetProductDetail>(() => GetProductDetail(productRepository: locator()));
    locator.registerLazySingleton<GetMostDiscountProductFromCachedProductList>(() => GetMostDiscountProductFromCachedProductList());

    // Repository
    locator.registerLazySingleton<ProductRepository>(() => DefaultProductRepository(productDataSource: locator()));

    // Data Sources
    locator.registerLazySingleton<ProductDataSource>(() => DefaultProductDataSource(dio: locator()));

    // Dio
    locator.registerLazySingleton<Dio>(() => DioHttpClient.of());
  }
}

// ignore: non_constant_identifier_names
final Injector = _Injector();