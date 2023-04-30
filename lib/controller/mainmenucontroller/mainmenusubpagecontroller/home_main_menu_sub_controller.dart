import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../../../domain/entity/address/address.dart';
import '../../../domain/entity/address/current_selected_address_parameter.dart';
import '../../../domain/entity/banner/transparent_banner.dart';
import '../../../domain/entity/componententity/dynamic_item_carousel_directly_component_entity.dart';
import '../../../domain/entity/homemainmenucomponententity/check_rates_for_various_countries_component_entity.dart';
import '../../../domain/entity/homemainmenucomponententity/dynamic_item_carousel_directly_home_main_menu_component_entity.dart';
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
import '../../../domain/entity/product/productentry/product_entry_header_content_response.dart';
import '../../../domain/usecase/add_wishlist_use_case.dart';
import '../../../domain/usecase/get_bestseller_in_masterbagasi_list_use_case.dart';
import '../../../domain/usecase/get_coffee_and_tea_origin_indonesia_list_use_case.dart';
import '../../../domain/usecase/get_current_selected_address_use_case.dart';
import '../../../domain/usecase/get_handycrafts_contents_banner_use_case.dart';
import '../../../domain/usecase/get_kitchen_contents_banner_use_case.dart';
import '../../../domain/usecase/get_product_brand_use_case.dart';
import '../../../domain/usecase/get_product_bundle_highlight_use_case.dart';
import '../../../domain/usecase/get_product_bundle_list_use_case.dart';
import '../../../domain/usecase/get_product_category_list_use_case.dart';
import '../../../domain/usecase/get_product_viral_list_use_case.dart';
import '../../../domain/usecase/get_snack_for_lying_around_list_use_case.dart';
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
  final GetSnackForLyingAroundListUseCase getSnackForLyingAroundListUseCase;
  final GetBestsellerInMasterbagasiListUseCase getBestsellerInMasterbagasiListUseCase;
  final GetCoffeeAndTeaOriginIndonesiaListUseCase getCoffeeAndTeaOriginIndonesiaListUseCase;
  final GetHandycraftsContentsBannerUseCase getHandycraftsContentsBannerUseCase;
  final GetKitchenContentsBannerUseCase getKitchenContentsBannerUseCase;
  final AddWishlistUseCase addWishlistUseCase;
  final GetCurrentSelectedAddressUseCase getCurrentSelectedAddressUseCase;
  HomeMainMenuDelegate? _homeMainMenuDelegate;

  HomeMainMenuSubController(
    ControllerManager? controllerManager,
    this.getProductBrandListUseCase,
    this.getProductViralListUseCase,
    this.getProductCategoryListUseCase,
    this.getProductBundleListUseCase,
    this.getProductBundleHighlightUseCase,
    this.addWishlistUseCase,
    this.getSnackForLyingAroundListUseCase,
    this.getBestsellerInMasterbagasiListUseCase,
    this.getCoffeeAndTeaOriginIndonesiaListUseCase,
    this.getHandycraftsContentsBannerUseCase,
    this.getKitchenContentsBannerUseCase,
    this.getCurrentSelectedAddressUseCase
  ) : super(controllerManager, initLater: true);

  HomeMainMenuComponentEntity getDeliveryTo() {
    return DynamicItemCarouselDirectlyHomeMainMenuComponentEntity(
      title: MultiLanguageString(""),
      onDynamicItemAction: (title, description, observer) async {
        observer(title, description, IsLoadingLoadDataResult<Address>());
        LoadDataResult<Address> addressPagingDataResult = await getCurrentSelectedAddressUseCase.execute(
          CurrentSelectedAddressParameter()
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPart("short-video-list").value
        ).map<Address>(
          (currentSelectedAddressResponse) => currentSelectedAddressResponse.address
        );
        if (addressPagingDataResult.isFailedBecauseCancellation) {
          return;
        }
        observer(title, description, addressPagingDataResult);
      },
      observeDynamicItemActionStateDirectly: (title, description, itemLoadDataResult, errorProvider) {
        LoadDataResult<Address> addressLoadDataResult = itemLoadDataResult.castFromDynamic<Address>();
        if (_homeMainMenuDelegate != null) {
          return _homeMainMenuDelegate!.onObserveLoadCurrentAddress(
            _OnObserveLoadCurrentAddressParameter(
              addressLoadDataResult: addressLoadDataResult
            )
          );
        } else {
          throw MessageError(title: "Feed main menu sub delegate must be not null");
        }
      },
    );
  }

  List<HomeMainMenuComponentEntity> getHomeMainMenuComponentEntity() {
    return [
      DynamicItemCarouselHomeMainMenuComponentEntity(
        title: MultiLanguageString({
          Constant.textEnUsLanguageKey: "Indonesian Category Product",
          Constant.textInIdLanguageKey: "Kategori Produk Indonesia"
        }),
        onDynamicItemAction: (title, description, observer) async {
          observer(title, description, IsLoadingLoadDataResult<List<ProductCategory>>());
          LoadDataResult<List<ProductCategory>> productEntryPagingDataResult = await getProductCategoryListUseCase.execute().future(
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
                productCategoryList: productCategoryList,
                data: Constant.carouselKeyIndonesianCategoryProduct
              )
            );
          }
          throw MessageError(title: "Home main menu delegate must be initialized");
        },
      ),
      DynamicItemCarouselHomeMainMenuComponentEntity(
        title: MultiLanguageString({
          Constant.textEnUsLanguageKey: "Indonesian Original Brand",
          Constant.textInIdLanguageKey: "Brand Asli Indonesia"
        }),
        onDynamicItemAction: (title, description, observer) async {
          observer(title, description, IsLoadingLoadDataResult<List<ProductBrand>>());
          LoadDataResult<List<ProductBrand>> productEntryPagingDataResult = await getProductBrandListUseCase.execute().future(
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
                productBrandList: productBrandList,
                data: Constant.carouselKeyIndonesianOriginalBrand
              )
            );
          }
          throw MessageError(title: "Home main menu delegate must be initialized");
        },
      ),
      DynamicItemCarouselHomeMainMenuComponentEntity(
        title: Constant.multiLanguageStringIsViral,
        onDynamicItemAction: (title, description, observer) async {
          observer(title, description, IsLoadingLoadDataResult<List<ProductEntry>>());
          LoadDataResult<List<ProductEntry>> productEntryPagingDataResult = await getProductViralListUseCase.execute().future(
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
                productEntryList: productEntryList,
                data: Constant.carouselKeyIsViral
              )
            );
          }
          throw MessageError(title: "Home main menu delegate must be initialized");
        },
      ),
      CheckRatesForVariousCountriesComponentEntity(),
      DynamicItemCarouselHomeMainMenuComponentEntity(
        title: MultiLanguageString({
          Constant.textEnUsLanguageKey: "Indonesia Kitchen Contents",
          Constant.textInIdLanguageKey: "Isi Dapur Indonesia"
        }),
        onDynamicItemAction: (title, description, observer) async {
          observer(title, description, IsLoadingLoadDataResult<ProductBundle>());
          LoadDataResult<List<TransparentBanner>> transparentBannerListLoadDataResult = await getKitchenContentsBannerUseCase.execute().future(
            parameter: apiRequestManager.addRequestToCancellationPart("indonesia-kitchen-contents").value
          );
          if (transparentBannerListLoadDataResult.isFailedBecauseCancellation) {
            return;
          }
          observer(title, description, transparentBannerListLoadDataResult);
        },
        onObserveLoadingDynamicItemActionState: (title, description, loadDataResult) {
          if (_homeMainMenuDelegate != null) {
            return _homeMainMenuDelegate!.onObserveLoadingLoadTransparentBanner(
              _OnObserveLoadingLoadTransparentBannerParameter()
            );
          }
        },
        onObserveSuccessDynamicItemActionState: (title, description, loadDataResult) {
          List<TransparentBanner> transparentBannerList = loadDataResult.resultIfSuccess!;
          if (_homeMainMenuDelegate != null) {
            return _homeMainMenuDelegate!.onObserveSuccessLoadTransparentBanner(
              _OnObserveSuccessLoadTransparentBannerParameter(
                title: title,
                description: description,
                transparentBanner: transparentBannerList.first,
                data: Constant.transparentBannerKeyKitchenContents
              )
            );
          }
          throw MessageError(title: "Home main menu delegate must be initialized");
        },
      ),
      DynamicItemCarouselHomeMainMenuComponentEntity(
        title: MultiLanguageString({
          Constant.textEnUsLanguageKey: "Snack For Lying Around",
          Constant.textInIdLanguageKey: "Cemilan Buat Rebahan"
        }),
        onDynamicItemAction: (title, description, observer) async {
          observer(title, description, IsLoadingLoadDataResult<List<ProductEntry>>());
          LoadDataResult<List<ProductEntry>> productEntryPagingDataResult = await getSnackForLyingAroundListUseCase.execute().future(
            parameter: apiRequestManager.addRequestToCancellationPart("snack-for-lying-around").value
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
                productEntryList: productEntryList,
                data: Constant.carouselKeySnackForLyingAround
              )
            );
          }
          throw MessageError(title: "Home main menu delegate must be initialized");
        },
      ),
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
      DynamicItemCarouselHomeMainMenuComponentEntity(
        title: MultiLanguageString({
          Constant.textEnUsLanguageKey: "Best Selling in Masterbagasi",
          Constant.textInIdLanguageKey: "Terlaris di Masterbagasi"
        }),
        onDynamicItemAction: (title, description, observer) async {
          observer(title, description, IsLoadingLoadDataResult<List<ProductEntry>>());
          LoadDataResult<List<ProductEntry>> productEntryPagingDataResult = await getBestsellerInMasterbagasiListUseCase.execute().future(
            parameter: apiRequestManager.addRequestToCancellationPart("bestselling-in-masterbagasi").value
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
                productEntryList: productEntryList,
                data: Constant.carouselKeyBestSellingInMasterBagasi
              )
            );
          }
          throw MessageError(title: "Home main menu delegate must be initialized");
        },
      ),
      DynamicItemCarouselHomeMainMenuComponentEntity(
        title: MultiLanguageString({
          Constant.textEnUsLanguageKey: "Handicrafts made by the Nation's Children",
          Constant.textInIdLanguageKey: "Kerajinan Tangan Karya Anak Bangsa"
        }),
        onDynamicItemAction: (title, description, observer) async {
          observer(title, description, IsLoadingLoadDataResult<ProductBundle>());
          LoadDataResult<List<TransparentBanner>> transparentBannerListLoadDataResult = await getHandycraftsContentsBannerUseCase.execute().future(
            parameter: apiRequestManager.addRequestToCancellationPart("handycrafts-contents").value
          );
          if (transparentBannerListLoadDataResult.isFailedBecauseCancellation) {
            return;
          }
          observer(title, description, transparentBannerListLoadDataResult);
        },
        onObserveLoadingDynamicItemActionState: (title, description, loadDataResult) {
          if (_homeMainMenuDelegate != null) {
            return _homeMainMenuDelegate!.onObserveLoadingLoadTransparentBanner(
              _OnObserveLoadingLoadTransparentBannerParameter()
            );
          }
        },
        onObserveSuccessDynamicItemActionState: (title, description, loadDataResult) {
          List<TransparentBanner> transparentBannerList = loadDataResult.resultIfSuccess!;
          if (_homeMainMenuDelegate != null) {
            return _homeMainMenuDelegate!.onObserveSuccessLoadTransparentBanner(
              _OnObserveSuccessLoadTransparentBannerParameter(
                title: title,
                description: description,
                transparentBanner: transparentBannerList.first,
                data: Constant.transparentBannerKeyHandycrafts
              )
            );
          }
          throw MessageError(title: "Home main menu delegate must be initialized");
        },
      ),
      DynamicItemCarouselHomeMainMenuComponentEntity(
        title: MultiLanguageString({
          Constant.textEnUsLanguageKey: "Coffee & Tea Origin Indonesia",
          Constant.textInIdLanguageKey: "Kopi & Teh Asli Indonesia"
        }),
        onDynamicItemAction: (title, description, observer) async {
          observer(title, description, IsLoadingLoadDataResult<List<ProductEntry>>());
          LoadDataResult<List<ProductEntry>> productEntryPagingDataResult = await getCoffeeAndTeaOriginIndonesiaListUseCase.execute().future(
            parameter: apiRequestManager.addRequestToCancellationPart("coffee-and-tea-origin-indonesia").value
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
                productEntryList: productEntryList,
                data: Constant.carouselKeyCoffeeAndTeaOriginIndonesia
              )
            );
          }
          throw MessageError(title: "Home main menu delegate must be initialized");
        },
      ),
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
  final GetSnackForLyingAroundListUseCase getSnackForLyingAroundListUseCase;
  final GetBestsellerInMasterbagasiListUseCase getBestsellerInMasterbagasiListUseCase;
  final GetCoffeeAndTeaOriginIndonesiaListUseCase getCoffeeAndTeaOriginIndonesiaListUseCase;
  final GetHandycraftsContentsBannerUseCase getHandycraftsContentsBannerUseCase;
  final GetKitchenContentsBannerUseCase getKitchenContentsBannerUseCase;
  final AddWishlistUseCase addWishlistUseCase;
  final GetCurrentSelectedAddressUseCase getCurrentSelectedAddressUseCase;

  HomeMainMenuSubControllerInjectionFactory({
    required this.getProductBrandListUseCase,
    required this.getProductViralListUseCase,
    required this.getProductCategoryListUseCase,
    required this.getProductBundleListUseCase,
    required this.getProductBundleHighlightUseCase,
    required this.getSnackForLyingAroundListUseCase,
    required this.getBestsellerInMasterbagasiListUseCase,
    required this.getCoffeeAndTeaOriginIndonesiaListUseCase,
    required this.getHandycraftsContentsBannerUseCase,
    required this.getKitchenContentsBannerUseCase,
    required this.addWishlistUseCase,
    required this.getCurrentSelectedAddressUseCase
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
        addWishlistUseCase,
        getSnackForLyingAroundListUseCase,
        getBestsellerInMasterbagasiListUseCase,
        getCoffeeAndTeaOriginIndonesiaListUseCase,
        getHandycraftsContentsBannerUseCase,
        getKitchenContentsBannerUseCase,
        getCurrentSelectedAddressUseCase
      ),
      tag: pageName
    );
  }
}

class HomeMainMenuDelegate {
  OnObserveLoadProductDelegate onObserveLoadProductDelegate;
  ListItemControllerState Function(_OnObserveSuccessLoadProductBundleHighlightParameter) onObserveSuccessLoadProductBundleHighlight;
  ListItemControllerState Function(_OnObserveLoadingLoadProductBundleHighlightParameter) onObserveLoadingLoadProductBundleHighlight;
  ListItemControllerState Function(_OnObserveSuccessLoadTransparentBannerParameter) onObserveSuccessLoadTransparentBanner;
  ListItemControllerState Function(_OnObserveLoadingLoadTransparentBannerParameter) onObserveLoadingLoadTransparentBanner;
  ListItemControllerState Function(_OnObserveLoadCurrentAddressParameter) onObserveLoadCurrentAddress;

  HomeMainMenuDelegate({
    required this.onObserveLoadProductDelegate,
    required this.onObserveSuccessLoadProductBundleHighlight,
    required this.onObserveLoadingLoadProductBundleHighlight,
    required this.onObserveSuccessLoadTransparentBanner,
    required this.onObserveLoadingLoadTransparentBanner,
    required this.onObserveLoadCurrentAddress,
  });
}

class _OnObserveSuccessLoadProductBundleHighlightParameter {
  MultiLanguageString? title;
  MultiLanguageString? description;
  ProductBundle productBundle;

  _OnObserveSuccessLoadProductBundleHighlightParameter({
    required this.title,
    required this.description,
    required this.productBundle,
  });
}

class _OnObserveLoadingLoadProductBundleHighlightParameter {}

class _OnObserveSuccessLoadTransparentBannerParameter {
  MultiLanguageString? title;
  MultiLanguageString? description;
  TransparentBanner transparentBanner;
  dynamic data;

  _OnObserveSuccessLoadTransparentBannerParameter({
    required this.title,
    required this.description,
    required this.transparentBanner,
    this.data
  });
}

class _OnObserveLoadingLoadTransparentBannerParameter {}

class _OnObserveLoadCurrentAddressParameter {
  LoadDataResult<Address> addressLoadDataResult;

  _OnObserveLoadCurrentAddressParameter({
    required this.addressLoadDataResult
  });
}