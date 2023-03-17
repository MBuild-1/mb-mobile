import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../../../domain/entity/homemainmenucomponententity/check_rates_for_various_countries_component_entity.dart';
import '../../../domain/entity/homemainmenucomponententity/dynamic_item_carousel_home_main_menu_component_entity.dart';
import '../../../domain/entity/homemainmenucomponententity/home_main_menu_component_entity.dart';
import '../../../domain/entity/homemainmenucomponententity/separator_home_main_menu_component_entity.dart';
import '../../../domain/entity/product/product.dart';
import '../../../domain/entity/product/productbrand/product_brand.dart';
import '../../../domain/entity/product/productbrand/product_brand_list_parameter.dart';
import '../../../domain/entity/product/productbundle/product_bundle.dart';
import '../../../domain/entity/product/productbundle/product_bundle_list_parameter.dart';
import '../../../domain/entity/product/productcategory/product_category.dart';
import '../../../domain/entity/product/productcategory/product_category_list_parameter.dart';
import '../../../domain/entity/product/productentry/product_entry.dart';
import '../../../domain/entity/product/product_with_condition_paging_parameter.dart';
import '../../../domain/usecase/get_product_brand_use_case.dart';
import '../../../domain/usecase/get_product_bundle_use_case.dart';
import '../../../domain/usecase/get_product_category_list_use_case.dart';
import '../../../domain/usecase/get_product_viral_list_use_case.dart';
import '../../../misc/constant.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../../misc/error/message_error.dart';
import '../../../misc/getextended/get_extended.dart';
import '../../../misc/load_data_result.dart';
import '../../../misc/manager/controller_manager.dart';
import '../../../misc/multi_language_string.dart';
import '../../base_getx_controller.dart';

class HomeMainMenuSubController extends BaseGetxController {
  final GetProductBrandListUseCase getProductBrandListUseCase;
  final GetProductViralListUseCase getProductViralListUseCase;
  final GetProductCategoryListUseCase getProductCategoryListUseCase;
  final GetProductBundleListUseCase getProductBundleListUseCase;
  HomeMainMenuDelegate? _homeMainMenuDelegate;

  HomeMainMenuSubController(
    ControllerManager? controllerManager,
    this.getProductBrandListUseCase,
    this.getProductViralListUseCase,
    this.getProductCategoryListUseCase,
    this.getProductBundleListUseCase
  ) : super(controllerManager, initLater: true);

  List<HomeMainMenuComponentEntity> getHomeMainMenuComponentEntity() {
    return [
      SeparatorHomeMainMenuComponentEntity(),
      DynamicItemCarouselHomeMainMenuComponentEntity(
        title: MultiLanguageString({
          Constant.textEnUsLanguageKey: "Indonesian Category Product",
          Constant.textInIdLanguageKey: "Kategori Produk Indonesia"
        }),
        onDynamicItemAction: (title, description, observer) async {
          observer(title, description, IsLoadingLoadDataResult<List<ProductCategory>>());
          LoadDataResult<List<ProductCategory>> productEntryPagingDataResult = await getProductCategoryListUseCase.execute(
            ProductCategoryListParameter()
          ).future(
            parameter: apiRequestManager.addRequestToCancellationPart("product-category").value
          );
          if (productEntryPagingDataResult.isFailedBecauseCancellation) {
            return;
          }
          observer(title, description, productEntryPagingDataResult.map<List<ProductCategory>>(
            (trainingPagingDataResult) => trainingPagingDataResult
          ));
        },
        onObserveLoadingDynamicItemActionState: (title, description, loadDataResult) {
          if (_homeMainMenuDelegate != null) {
            return _homeMainMenuDelegate!.onObserveLoadingLoadProductCategoryCarousel(
              _OnObserveLoadingLoadProductCategoryCarouselParameter()
            );
          }
        },
        onObserveSuccessDynamicItemActionState: (title, description, loadDataResult) {
          List<ProductCategory> productCategoryList = loadDataResult.resultIfSuccess!;
          if (_homeMainMenuDelegate != null) {
            return _homeMainMenuDelegate!.onObserveSuccessLoadProductCategoryCarousel(
              _OnObserveSuccessLoadProductCategoryCarouselParameter(
                title: title,
                description: description,
                productCategoryList: productCategoryList
              )
            );
          }
          throw MessageError(title: "Home main menu delegate must be initialized");
        },
      ),
      SeparatorHomeMainMenuComponentEntity(),
      DynamicItemCarouselHomeMainMenuComponentEntity(
        title: MultiLanguageString({
          Constant.textEnUsLanguageKey: "Indonesian Original Brand",
          Constant.textInIdLanguageKey: "Brand Asli Indonesia"
        }),
        onDynamicItemAction: (title, description, observer) async {
          observer(title, description, IsLoadingLoadDataResult<List<ProductBrand>>());
          LoadDataResult<List<ProductBrand>> productEntryPagingDataResult = await getProductBrandListUseCase.execute(
            ProductBrandListParameter()
          ).future(
            parameter: apiRequestManager.addRequestToCancellationPart("product-brand").value
          );
          if (productEntryPagingDataResult.isFailedBecauseCancellation) {
            return;
          }
          observer(title, description, productEntryPagingDataResult.map<List<ProductBrand>>(
            (trainingPagingDataResult) => trainingPagingDataResult
          ));
        },
        onObserveLoadingDynamicItemActionState: (title, description, loadDataResult) {
          if (_homeMainMenuDelegate != null) {
            return _homeMainMenuDelegate!.onObserveLoadingLoadProductBrandCarousel(
              _OnObserveLoadingLoadProductBrandCarouselParameter()
            );
          }
        },
        onObserveSuccessDynamicItemActionState: (title, description, loadDataResult) {
          List<ProductBrand> productBrandList = loadDataResult.resultIfSuccess!;
          if (_homeMainMenuDelegate != null) {
            return _homeMainMenuDelegate!.onObserveSuccessLoadProductBrandCarousel(
              _OnObserveSuccessLoadProductBrandCarouselParameter(
                title: title,
                description: description,
                productBrandList: productBrandList
              )
            );
          }
          throw MessageError(title: "Home main menu delegate must be initialized");
        },
      ),
      SeparatorHomeMainMenuComponentEntity(),
      DynamicItemCarouselHomeMainMenuComponentEntity(
        title: MultiLanguageString({
          Constant.textEnUsLanguageKey: "Is Viral",
          Constant.textInIdLanguageKey: "Lagi Viral"
        }),
        onDynamicItemAction: (title, description, observer) async {
          observer(title, description, IsLoadingLoadDataResult<List<ProductEntry>>());
          LoadDataResult<List<ProductEntry>> productEntryPagingDataResult = await getProductViralListUseCase.execute(
            ProductWithConditionPagingParameter(page: 1, withCondition: "is_viral")
          ).future(
            parameter: apiRequestManager.addRequestToCancellationPart("product-is-viral").value
          );
          if (productEntryPagingDataResult.isFailedBecauseCancellation) {
            return;
          }
          observer(title, description, productEntryPagingDataResult.map<List<ProductEntry>>(
            (trainingPagingDataResult) => trainingPagingDataResult
          ));
        },
        onObserveLoadingDynamicItemActionState: (title, description, loadDataResult) {
          if (_homeMainMenuDelegate != null) {
            return _homeMainMenuDelegate!.onObserveLoadingLoadProductEntryCarousel(
              _OnObserveLoadingLoadProductEntryCarouselParameter()
            );
          }
        },
        onObserveSuccessDynamicItemActionState: (title, description, loadDataResult) {
          List<ProductEntry> productEntryList = loadDataResult.resultIfSuccess!;
          if (_homeMainMenuDelegate != null) {
            return _homeMainMenuDelegate!.onObserveSuccessLoadProductEntryCarousel(
              _OnObserveSuccessLoadProductEntryCarouselParameter(
                title: title,
                description: description,
                productEntryList: productEntryList
              )
            );
          }
          throw MessageError(title: "Home main menu delegate must be initialized");
        },
      ),
      SeparatorHomeMainMenuComponentEntity(),
      CheckRatesForVariousCountriesComponentEntity(),
      SeparatorHomeMainMenuComponentEntity(),
      DynamicItemCarouselHomeMainMenuComponentEntity(
        title: MultiLanguageString({
          Constant.textEnUsLanguageKey: "Product Bundle",
          Constant.textInIdLanguageKey: "Bundle Produk"
        }),
        onDynamicItemAction: (title, description, observer) async {
          observer(title, description, IsLoadingLoadDataResult<List<ProductBundle>>());
          LoadDataResult<List<ProductBundle>> productBundlePagingDataResult = await getProductBundleListUseCase.execute(
            ProductBundleListParameter()
          ).future(
            parameter: apiRequestManager.addRequestToCancellationPart("product-bundle").value
          );
          if (productBundlePagingDataResult.isFailedBecauseCancellation) {
            return;
          }
          observer(title, description, productBundlePagingDataResult.map<List<ProductBundle>>(
            (trainingPagingDataResult) => trainingPagingDataResult
          ));
        },
        onObserveLoadingDynamicItemActionState: (title, description, loadDataResult) {
          if (_homeMainMenuDelegate != null) {
            return _homeMainMenuDelegate!.onObserveLoadingLoadProductBundleCarousel(
              _OnObserveLoadingLoadProductBundleCarouselParameter()
            );
          }
        },
        onObserveSuccessDynamicItemActionState: (title, description, loadDataResult) {
          List<ProductBundle> productBundleList = loadDataResult.resultIfSuccess!;
          if (_homeMainMenuDelegate != null) {
            return _homeMainMenuDelegate!.onObserveSuccessLoadProductBundleCarousel(
              _OnObserveSuccessLoadProductBundleCarouselParameter(
                title: title,
                description: description,
                productBundleList: productBundleList
              )
            );
          }
          throw MessageError(title: "Home main menu delegate must be initialized");
        },
      ),
      SeparatorHomeMainMenuComponentEntity(),
    ];
  }

  void setHomeMainMenuDelegate(HomeMainMenuDelegate homeMainMenuDelegate) {
    _homeMainMenuDelegate = homeMainMenuDelegate;
  }
}

class HomeMainMenuSubControllerInjectionFactory {
  final GetProductBrandListUseCase getProductBrandListUseCase;
  final GetProductViralListUseCase getProductViralListUseCase;
  final GetProductCategoryListUseCase getProductCategoryListUseCase;
  final GetProductBundleListUseCase getProductBundleListUseCase;

  HomeMainMenuSubControllerInjectionFactory({
    required this.getProductBrandListUseCase,
    required this.getProductViralListUseCase,
    required this.getProductCategoryListUseCase,
    required this.getProductBundleListUseCase
  });

  HomeMainMenuSubController inject(ControllerManager controllerManager, String pageName) {
    return GetExtended.put<HomeMainMenuSubController>(
      HomeMainMenuSubController(
        controllerManager,
        getProductBrandListUseCase,
        getProductViralListUseCase,
        getProductCategoryListUseCase,
        getProductBundleListUseCase
      ),
      tag: pageName
    );
  }
}

class HomeMainMenuDelegate {
  ListItemControllerState Function(_OnObserveSuccessLoadProductBrandCarouselParameter) onObserveSuccessLoadProductBrandCarousel;
  ListItemControllerState Function(_OnObserveLoadingLoadProductBrandCarouselParameter) onObserveLoadingLoadProductBrandCarousel;
  ListItemControllerState Function(_OnObserveSuccessLoadProductCategoryCarouselParameter) onObserveSuccessLoadProductCategoryCarousel;
  ListItemControllerState Function(_OnObserveLoadingLoadProductCategoryCarouselParameter) onObserveLoadingLoadProductCategoryCarousel;
  ListItemControllerState Function(_OnObserveSuccessLoadProductEntryCarouselParameter) onObserveSuccessLoadProductEntryCarousel;
  ListItemControllerState Function(_OnObserveLoadingLoadProductEntryCarouselParameter) onObserveLoadingLoadProductEntryCarousel;
  ListItemControllerState Function(_OnObserveSuccessLoadProductBundleCarouselParameter) onObserveSuccessLoadProductBundleCarousel;
  ListItemControllerState Function(_OnObserveLoadingLoadProductBundleCarouselParameter) onObserveLoadingLoadProductBundleCarousel;

  HomeMainMenuDelegate({
    required this.onObserveSuccessLoadProductBrandCarousel,
    required this.onObserveLoadingLoadProductBrandCarousel,
    required this.onObserveSuccessLoadProductCategoryCarousel,
    required this.onObserveLoadingLoadProductCategoryCarousel,
    required this.onObserveSuccessLoadProductEntryCarousel,
    required this.onObserveLoadingLoadProductEntryCarousel,
    required this.onObserveSuccessLoadProductBundleCarousel,
    required this.onObserveLoadingLoadProductBundleCarousel,
  });
}

class _OnObserveSuccessLoadProductBundleCarouselParameter {
  MultiLanguageString? title;
  MultiLanguageString? description;
  List<ProductBundle> productBundleList;

  _OnObserveSuccessLoadProductBundleCarouselParameter({
    required this.title,
    required this.description,
    required this.productBundleList
  });
}

class _OnObserveLoadingLoadProductBundleCarouselParameter {}

class _OnObserveSuccessLoadProductBrandCarouselParameter {
  MultiLanguageString? title;
  MultiLanguageString? description;
  List<ProductBrand> productBrandList;

  _OnObserveSuccessLoadProductBrandCarouselParameter({
    required this.title,
    required this.description,
    required this.productBrandList
  });
}

class _OnObserveLoadingLoadProductBrandCarouselParameter {}

class _OnObserveSuccessLoadProductCategoryCarouselParameter {
  MultiLanguageString? title;
  MultiLanguageString? description;
  List<ProductCategory> productCategoryList;

  _OnObserveSuccessLoadProductCategoryCarouselParameter({
    required this.title,
    required this.description,
    required this.productCategoryList
  });
}

class _OnObserveLoadingLoadProductCategoryCarouselParameter {}

class _OnObserveSuccessLoadProductEntryCarouselParameter {
  MultiLanguageString? title;
  MultiLanguageString? description;
  List<ProductEntry> productEntryList;

  _OnObserveSuccessLoadProductEntryCarouselParameter({
    required this.title,
    required this.description,
    required this.productEntryList
  });
}

class _OnObserveLoadingLoadProductEntryCarouselParameter {}