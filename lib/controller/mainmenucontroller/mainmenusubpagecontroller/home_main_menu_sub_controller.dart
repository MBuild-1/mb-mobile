import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../../../domain/entity/homemainmenucomponententity/check_rates_for_various_countries_component_entity.dart';
import '../../../domain/entity/homemainmenucomponententity/dynamic_item_carousel_home_main_menu_component_entity.dart';
import '../../../domain/entity/homemainmenucomponententity/home_main_menu_component_entity.dart';
import '../../../domain/entity/homemainmenucomponententity/separator_home_main_menu_component_entity.dart';
import '../../../domain/entity/product/productbrand/product_brand.dart';
import '../../../domain/entity/product/productbrand/product_brand_list_parameter.dart';
import '../../../domain/entity/product/productbundle/product_bundle.dart';
import '../../../domain/entity/product/productbundle/product_bundle_highlight_parameter.dart';
import '../../../domain/entity/product/productcategory/product_category.dart';
import '../../../domain/entity/product/productcategory/product_category_list_parameter.dart';
import '../../../domain/entity/product/productentry/product_entry.dart';
import '../../../domain/entity/product/product_with_condition_paging_parameter.dart';
import '../../../domain/usecase/add_wishlist_use_case.dart';
import '../../../domain/usecase/get_product_brand_use_case.dart';
import '../../../domain/usecase/get_product_bundle_highlight_use_case.dart';
import '../../../domain/usecase/get_product_bundle_list_use_case.dart';
import '../../../domain/usecase/get_product_category_list_use_case.dart';
import '../../../domain/usecase/get_product_viral_list_use_case.dart';
import '../../../misc/constant.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../../misc/error/message_error.dart';
import '../../../misc/getextended/get_extended.dart';
import '../../../misc/load_data_result.dart';
import '../../../misc/manager/controller_manager.dart';
import '../../../misc/multi_language_string.dart';
import '../../../misc/on_observe_load_product_delegate.dart';
import '../../base_getx_controller.dart';

class HomeMainMenuSubController extends BaseGetxController {
  final GetProductBrandListUseCase getProductBrandListUseCase;
  final GetProductViralListUseCase getProductViralListUseCase;
  final GetProductCategoryListUseCase getProductCategoryListUseCase;
  final GetProductBundleListUseCase getProductBundleListUseCase;
  final GetProductBundleHighlightUseCase getProductBundleHighlightUseCase;
  final AddWishlistUseCase addWishlistUseCase;
  HomeMainMenuDelegate? _homeMainMenuDelegate;

  HomeMainMenuSubController(
    ControllerManager? controllerManager,
    this.getProductBrandListUseCase,
    this.getProductViralListUseCase,
    this.getProductCategoryListUseCase,
    this.getProductBundleListUseCase,
    this.getProductBundleHighlightUseCase,
    this.addWishlistUseCase
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
            return _homeMainMenuDelegate!.onObserveLoadProductDelegate.onObserveLoadingLoadProductCategoryCarousel(
              OnObserveLoadingLoadProductCategoryCarouselParameter()
            );
          }
        },
        onObserveSuccessDynamicItemActionState: (title, description, loadDataResult) {
          List<ProductCategory> productCategoryList = loadDataResult.resultIfSuccess!;
          if (_homeMainMenuDelegate != null) {
            return _homeMainMenuDelegate!.onObserveLoadProductDelegate.onObserveSuccessLoadProductCategoryCarousel(
              OnObserveSuccessLoadProductCategoryCarouselParameter(
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
            return _homeMainMenuDelegate!.onObserveLoadProductDelegate.onObserveLoadingLoadProductBrandCarousel(
              OnObserveLoadingLoadProductBrandCarouselParameter()
            );
          }
        },
        onObserveSuccessDynamicItemActionState: (title, description, loadDataResult) {
          List<ProductBrand> productBrandList = loadDataResult.resultIfSuccess!;
          if (_homeMainMenuDelegate != null) {
            return _homeMainMenuDelegate!.onObserveLoadProductDelegate.onObserveSuccessLoadProductBrandCarousel(
              OnObserveSuccessLoadProductBrandCarouselParameter(
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
            return _homeMainMenuDelegate!.onObserveLoadProductDelegate.onObserveLoadingLoadProductEntryCarousel(
              OnObserveLoadingLoadProductEntryCarouselParameter()
            );
          }
        },
        onObserveSuccessDynamicItemActionState: (title, description, loadDataResult) {
          List<ProductEntry> productEntryList = loadDataResult.resultIfSuccess!;
          if (_homeMainMenuDelegate != null) {
            return _homeMainMenuDelegate!.onObserveLoadProductDelegate.onObserveSuccessLoadProductEntryCarousel(
              OnObserveSuccessLoadProductEntryCarouselParameter(
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
          Constant.textEnUsLanguageKey: "Product Bundle Highlight",
          Constant.textInIdLanguageKey: "Product Bundle Highlight"
        }),
        onDynamicItemAction: (title, description, observer) async {
          observer(title, description, IsLoadingLoadDataResult<ProductBundle>());
          LoadDataResult<ProductBundle> productBundleHighlightDataResult = await getProductBundleHighlightUseCase.execute(
            ProductBundleHighlightParameter()
          ).future(
            parameter: apiRequestManager.addRequestToCancellationPart("product-bundle-highlight").value
          );
          if (productBundleHighlightDataResult.isFailedBecauseCancellation) {
            return;
          }
          observer(title, description, productBundleHighlightDataResult.map<ProductBundle>(
            (productBundleHighlight) => productBundleHighlight
          ));
        },
        onObserveLoadingDynamicItemActionState: (title, description, loadDataResult) {
          if (_homeMainMenuDelegate != null) {
            return _homeMainMenuDelegate!.onObserveLoadingLoadProductBundleHighlight(
              _OnObserveLoadingLoadProductBundleHighlightParameter()
            );
          }
        },
        onObserveSuccessDynamicItemActionState: (title, description, loadDataResult) {
          ProductBundle productBundle = loadDataResult.resultIfSuccess!;
          if (_homeMainMenuDelegate != null) {
            return _homeMainMenuDelegate!.onObserveSuccessLoadProductBundleHighlight(
              _OnObserveSuccessLoadProductBundleHighlightParameter(
                title: title,
                description: description,
                productBundle: productBundle
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
  final GetProductBundleHighlightUseCase getProductBundleHighlightUseCase;
  final AddWishlistUseCase addWishlistUseCase;

  HomeMainMenuSubControllerInjectionFactory({
    required this.getProductBrandListUseCase,
    required this.getProductViralListUseCase,
    required this.getProductCategoryListUseCase,
    required this.getProductBundleListUseCase,
    required this.getProductBundleHighlightUseCase,
    required this.addWishlistUseCase
  });

  HomeMainMenuSubController inject(ControllerManager controllerManager, String pageName) {
    return GetExtended.put<HomeMainMenuSubController>(
      HomeMainMenuSubController(
        controllerManager,
        getProductBrandListUseCase,
        getProductViralListUseCase,
        getProductCategoryListUseCase,
        getProductBundleListUseCase,
        getProductBundleHighlightUseCase,
        addWishlistUseCase
      ),
      tag: pageName
    );
  }
}

class HomeMainMenuDelegate {
  OnObserveLoadProductDelegate onObserveLoadProductDelegate;
  ListItemControllerState Function(_OnObserveSuccessLoadProductBundleHighlightParameter) onObserveSuccessLoadProductBundleHighlight;
  ListItemControllerState Function(_OnObserveLoadingLoadProductBundleHighlightParameter) onObserveLoadingLoadProductBundleHighlight;

  HomeMainMenuDelegate({
    required this.onObserveLoadProductDelegate,
    required this.onObserveSuccessLoadProductBundleHighlight,
    required this.onObserveLoadingLoadProductBundleHighlight,
  });
}

class _OnObserveSuccessLoadProductBundleHighlightParameter {
  MultiLanguageString? title;
  MultiLanguageString? description;
  ProductBundle productBundle;

  _OnObserveSuccessLoadProductBundleHighlightParameter({
    required this.title,
    required this.description,
    required this.productBundle
  });
}

class _OnObserveLoadingLoadProductBundleHighlightParameter {}