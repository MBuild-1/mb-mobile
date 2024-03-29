import 'dart:async';

import 'package:masterbagasi/misc/controllerstate/listitemcontrollerstate/spacing_list_item_controller_state.dart';
import 'package:masterbagasi/misc/controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/processing/future_processing.dart';

import '../../../domain/entity/address/address.dart';
import '../../../domain/entity/address/current_selected_address_parameter.dart';
import '../../../domain/entity/banner/banner.dart';
import '../../../domain/entity/banner/transparent_banner.dart';
import '../../../domain/entity/componententity/dynamicitemcarouseladditionalparameter/dynamic_item_carousel_additional_parameter.dart';
import '../../../domain/entity/homemainmenucomponententity/dynamic_item_carousel_directly_home_main_menu_component_entity.dart';
import '../../../domain/entity/homemainmenucomponententity/dynamic_item_carousel_home_main_menu_component_entity.dart';
import '../../../domain/entity/homemainmenucomponententity/home_main_menu_component_entity.dart';
import '../../../domain/entity/homemainmenucomponententity/separator_home_main_menu_component_entity.dart';
import '../../../domain/entity/product/productbrand/product_brand.dart';
import '../../../domain/entity/product/productbrand/product_brand_list_parameter.dart';
import '../../../domain/entity/product/productbundle/product_bundle.dart';
import '../../../domain/entity/product/productbundle/product_bundle_highlight_parameter.dart';
import '../../../domain/entity/product/productbundle/product_bundle_list_parameter.dart';
import '../../../domain/entity/product/productbundle/product_bundle_paging_parameter.dart';
import '../../../domain/entity/product/productcategory/product_category.dart';
import '../../../domain/entity/product/productcategory/product_category_list_parameter.dart';
import '../../../domain/entity/product/productentry/product_entry.dart';
import '../../../domain/entity/product/product_with_condition_paging_parameter.dart';
import '../../../domain/entity/product/productentry/product_entry_header_content_response.dart';
import '../../../domain/usecase/add_wishlist_use_case.dart';
import '../../../domain/usecase/get_beauty_product_indonesia_list_use_case.dart';
import '../../../domain/usecase/get_bestseller_in_masterbagasi_list_use_case.dart';
import '../../../domain/usecase/get_coffee_and_tea_origin_indonesia_list_use_case.dart';
import '../../../domain/usecase/get_current_selected_address_use_case.dart';
import '../../../domain/usecase/get_fashion_product_indonesia_list_use_case.dart';
import '../../../domain/usecase/get_handycrafts_contents_banner_use_case.dart';
import '../../../domain/usecase/get_homepage_contents_banner_use_case.dart';
import '../../../domain/usecase/get_kitchen_contents_banner_use_case.dart';
import '../../../domain/usecase/get_only_for_you_list_use_case.dart';
import '../../../domain/usecase/get_product_brand_use_case.dart';
import '../../../domain/usecase/get_product_bundle_highlight_use_case.dart';
import '../../../domain/usecase/get_product_bundle_list_use_case.dart';
import '../../../domain/usecase/get_product_bundle_paging_use_case.dart';
import '../../../domain/usecase/get_product_category_list_use_case.dart';
import '../../../domain/usecase/get_product_entry_with_condition_paging_use_case.dart';
import '../../../domain/usecase/get_product_viral_list_use_case.dart';
import '../../../domain/usecase/get_ready_to_eat_street_food_style_list_use_case.dart';
import '../../../domain/usecase/get_selected_beauty_brands_list_use_case.dart';
import '../../../domain/usecase/get_selected_fashion_brands_list_use_case.dart';
import '../../../domain/usecase/get_shipping_price_contents_banner_use_case.dart';
import '../../../domain/usecase/get_snack_for_lying_around_list_use_case.dart';
import '../../../domain/usecase/get_sponsor_contents_banner_use_case.dart';
import '../../../misc/constant.dart';
import '../../../misc/controllercontentdelegate/wishlist_and_cart_controller_content_delegate.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/compound_list_item_controller_state.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../../misc/entityandlistitemcontrollerstatemediator/horizontal_component_entity_parameterized_entity_and_list_item_controller_state_mediator.dart';
import '../../../misc/error/message_error.dart';
import '../../../misc/getextended/get_extended.dart';
import '../../../misc/load_data_result.dart';
import '../../../misc/manager/controller_manager.dart';
import '../../../misc/multi_language_string.dart';
import '../../../misc/on_observe_load_product_delegate.dart';
import '../../../presentation/page/modaldialogpage/select_address_modal_dialog_page.dart';
import '../../base_getx_controller.dart';

class HomeMainMenuSubController extends BaseGetxController {
  final GetProductEntryWithConditionPagingUseCase getProductEntryWithConditionPagingUseCase;
  final GetProductBrandListUseCase getProductBrandListUseCase;
  final GetProductViralListUseCase getProductViralListUseCase;
  final GetProductCategoryListUseCase getProductCategoryListUseCase;
  final GetProductBundleListUseCase getProductBundleListUseCase;
  final GetProductBundleHighlightUseCase getProductBundleHighlightUseCase;
  final GetProductBundlePagingUseCase getProductBundlePagingUseCase;
  final GetSnackForLyingAroundListUseCase getSnackForLyingAroundListUseCase;
  final GetBestsellerInMasterbagasiListUseCase getBestsellerInMasterbagasiListUseCase;
  final GetSelectedFashionBrandsListUseCase getSelectedFashionBrandsListUseCase;
  final GetSelectedBeautyBrandsListUseCase getSelectedBeautyBrandsListUseCase;
  final GetCoffeeAndTeaOriginIndonesiaListUseCase getCoffeeAndTeaOriginIndonesiaListUseCase;
  final GetBeautyProductIndonesiaListUseCase getBeautyProductIndonesiaListUseCase;
  final GetFashionProductIndonesiaListUseCase getFashionProductIndonesiaListUseCase;
  final GetReadyToEatStreetFoodStyleListUseCase getReadyToEatStreetFoodStyleListUseCase;
  final GetOnlyForYouListUseCase getOnlyForYouListUseCase;
  final GetHandycraftsContentsBannerUseCase getHandycraftsContentsBannerUseCase;
  final GetKitchenContentsBannerUseCase getKitchenContentsBannerUseCase;
  final GetHomepageContentsBannerUseCase getHomepageContentsBannerUseCase;
  final GetShippingPriceContentsBannerUseCase getShippingPriceContentsBannerUseCase;
  final GetSponsorContentsBannerUseCase getSponsorContentsBannerUseCase;

  final AddWishlistUseCase addWishlistUseCase;
  final GetCurrentSelectedAddressUseCase getCurrentSelectedAddressUseCase;
  final WishlistAndCartControllerContentDelegate wishlistAndCartControllerContentDelegate;
  HomeMainMenuDelegate? _homeMainMenuDelegate;

  HomeMainMenuSubController(
    ControllerManager? controllerManager,
    this.getProductEntryWithConditionPagingUseCase,
    this.getProductBrandListUseCase,
    this.getProductViralListUseCase,
    this.getProductCategoryListUseCase,
    this.getProductBundleListUseCase,
    this.getProductBundleHighlightUseCase,
    this.getProductBundlePagingUseCase,
    this.addWishlistUseCase,
    this.getSnackForLyingAroundListUseCase,
    this.getBestsellerInMasterbagasiListUseCase,
    this.getSelectedFashionBrandsListUseCase,
    this.getSelectedBeautyBrandsListUseCase,
    this.getCoffeeAndTeaOriginIndonesiaListUseCase,
    this.getBeautyProductIndonesiaListUseCase,
    this.getFashionProductIndonesiaListUseCase,
    this.getReadyToEatStreetFoodStyleListUseCase,
    this.getOnlyForYouListUseCase,
    this.getHandycraftsContentsBannerUseCase,
    this.getKitchenContentsBannerUseCase,
    this.getHomepageContentsBannerUseCase,
    this.getShippingPriceContentsBannerUseCase,
    this.getSponsorContentsBannerUseCase,
    this.getCurrentSelectedAddressUseCase,
    this.wishlistAndCartControllerContentDelegate
  ) : super(controllerManager, initLater: true) {
    wishlistAndCartControllerContentDelegate.setApiRequestManager(
      () => apiRequestManager
    );
  }

  HomeMainMenuComponentEntity getHomepageBanner() {
    return DynamicItemCarouselHomeMainMenuComponentEntity(
      title: MultiLanguageString({
        Constant.textEnUsLanguageKey: "Homepage Banner",
        Constant.textInIdLanguageKey: "Homepage Banner"
      }),
      onDynamicItemAction: (title, description, observer) async {
        observer(title, description, IsLoadingLoadDataResult<List<TransparentBanner>>());
        LoadDataResult<List<TransparentBanner>> bannerLoadDataResult = await getHomepageContentsBannerUseCase.execute().future(
          parameter: apiRequestManager.addRequestToCancellationPart("homepage-banner-highlight").value
        );
        if (bannerLoadDataResult.isFailedBecauseCancellation) {
          return;
        }
        observer(title, description, bannerLoadDataResult);
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
          return _homeMainMenuDelegate!.onObserveSuccessLoadMultipleTransparentBanner(
            _OnObserveSuccessLoadMultipleTransparentBannerParameter(
              title: title,
              description: description,
              transparentBannerList: transparentBannerList,
              data: Constant.transparentBannerKeyMultipleHomepage
            )
          );
        }
        throw MessageError(title: "Home main menu delegate must be initialized");
      },
    );
  }

  HomeMainMenuComponentEntity getDeliveryTo() {
    RepeatableDynamicItemCarouselAdditionalParameter repeatableDynamicItemCarouselAdditionalParameter = RepeatableDynamicItemCarouselAdditionalParameter();
    return DynamicItemCarouselDirectlyHomeMainMenuComponentEntity(
      title: MultiLanguageString(""),
      onDynamicItemAction: (title, description, observer) async {
        observer(title, description, IsLoadingLoadDataResult<Address>());
        LoadDataResult<Address> addressPagingDataResult = await getCurrentSelectedAddressUseCase.execute(
          CurrentSelectedAddressParameter()
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPart("delivery-to").value
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
              addressLoadDataResult: addressLoadDataResult,
              repeatableDynamicItemCarouselAdditionalParameter: repeatableDynamicItemCarouselAdditionalParameter
            )
          );
        } else {
          throw MessageError(title: "Feed main menu sub delegate must be not null");
        }
      },
      dynamicItemCarouselAdditionalParameter: repeatableDynamicItemCarouselAdditionalParameter
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
            return CompoundListItemControllerState(
              listItemControllerState: [
                VirtualSpacingListItemControllerState(height: 16),
                _homeMainMenuDelegate!.onObserveLoadProductDelegate.onObserveLoadingLoadProductCategoryCarousel(
                  OnObserveLoadingLoadProductCategoryCarouselParameter()
                ),
                VirtualSpacingListItemControllerState(height: 16),
              ]
            );
          }
        },
        onObserveSuccessDynamicItemActionState: (title, description, loadDataResult) {
          List<ProductCategory> productCategoryList = loadDataResult.resultIfSuccess!;
          if (_homeMainMenuDelegate != null) {
            return CompoundListItemControllerState(
              listItemControllerState: [
                VirtualSpacingListItemControllerState(
                  height: 8.0
                ),
                _homeMainMenuDelegate!.onObserveLoadProductDelegate.onObserveSuccessLoadProductCategoryCarousel(
                  OnObserveSuccessLoadProductCategoryCarouselParameter(
                    title: title,
                    description: description,
                    productCategoryList: productCategoryList,
                    data: Constant.carouselKeyIndonesianCategoryProduct
                  )
                ),
                VirtualSpacingListItemControllerState(
                  height: 16.0
                )
              ]
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
            return CompoundListItemControllerState(
              listItemControllerState: [
                VirtualSpacingListItemControllerState(height: 16),
                _homeMainMenuDelegate!.onObserveLoadProductDelegate.onObserveLoadingLoadProductCategoryCarousel(
                  OnObserveLoadingLoadProductCategoryCarouselParameter()
                ),
                VirtualSpacingListItemControllerState(height: 16),
              ]
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
            return CompoundListItemControllerState(
              listItemControllerState: [
                VirtualSpacingListItemControllerState(height: 16),
                _homeMainMenuDelegate!.onObserveLoadProductDelegate.onObserveLoadingLoadProductCategoryCarousel(
                  OnObserveLoadingLoadProductCategoryCarouselParameter()
                ),
                VirtualSpacingListItemControllerState(height: 16),
              ]
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
      DynamicItemCarouselHomeMainMenuComponentEntity(
        title: MultiLanguageString({
          Constant.textEnUsLanguageKey: "Shipping Price Banner",
          Constant.textInIdLanguageKey: "Shipping Price Banner"
        }),
        onDynamicItemAction: (title, description, observer) async {
          observer(title, description, IsLoadingLoadDataResult<List<TransparentBanner>>());
          LoadDataResult<List<TransparentBanner>> bannerLoadDataResult = await getShippingPriceContentsBannerUseCase.execute().future(
            parameter: apiRequestManager.addRequestToCancellationPart("shipping-price-banner-highlight").value
          );
          if (bannerLoadDataResult.isFailedBecauseCancellation) {
            return;
          }
          observer(title, description, bannerLoadDataResult);
        },
        onObserveLoadingDynamicItemActionState: (title, description, loadDataResult) {
          if (_homeMainMenuDelegate != null) {
            return CompoundListItemControllerState(
              listItemControllerState: [
                VirtualSpacingListItemControllerState(height: 16),
                _homeMainMenuDelegate!.onObserveLoadProductDelegate.onObserveLoadingLoadProductCategoryCarousel(
                  OnObserveLoadingLoadProductCategoryCarouselParameter()
                ),
                VirtualSpacingListItemControllerState(height: 16),
              ]
            );
          }
        },
        onObserveSuccessDynamicItemActionState: (title, description, loadDataResult) {
          List<TransparentBanner> transparentBannerList = loadDataResult.resultIfSuccess!;
          if (_homeMainMenuDelegate != null) {
            return _homeMainMenuDelegate!.onObserveSuccessLoadMultipleTransparentBanner(
              _OnObserveSuccessLoadMultipleTransparentBannerParameter(
                title: title,
                description: description,
                transparentBannerList: transparentBannerList,
                data: Constant.transparentBannerKeyMultipleShippingPrice
              )
            );
          }
          throw MessageError(title: "Home main menu delegate must be initialized");
        },
      ),
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
            return CompoundListItemControllerState(
              listItemControllerState: [
                VirtualSpacingListItemControllerState(height: 16),
                _homeMainMenuDelegate!.onObserveLoadProductDelegate.onObserveLoadingLoadProductCategoryCarousel(
                  OnObserveLoadingLoadProductCategoryCarouselParameter()
                ),
                VirtualSpacingListItemControllerState(height: 16),
              ]
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
          Constant.textEnUsLanguageKey: "Ready To Eat Street Food Style",
          Constant.textInIdLanguageKey: "Siap Saji Ala Kaki Lima"
        }),
        onDynamicItemAction: (title, description, observer) async {
          observer(title, description, IsLoadingLoadDataResult<List<ProductEntry>>());
          LoadDataResult<List<ProductEntry>> productEntryPagingDataResult = await getReadyToEatStreetFoodStyleListUseCase.execute().future(
            parameter: apiRequestManager.addRequestToCancellationPart("ready-to-eat-street-food-style").value
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
            return CompoundListItemControllerState(
              listItemControllerState: [
                VirtualSpacingListItemControllerState(height: 16),
                _homeMainMenuDelegate!.onObserveLoadProductDelegate.onObserveLoadingLoadProductCategoryCarousel(
                  OnObserveLoadingLoadProductCategoryCarouselParameter()
                ),
                VirtualSpacingListItemControllerState(height: 16),
              ]
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
                data: Constant.carouselKeyReadyToEatStreetFoodStyle
              )
            );
          }
          throw MessageError(title: "Home main menu delegate must be initialized");
        },
      ),
      DynamicItemCarouselHomeMainMenuComponentEntity(
        title: MultiLanguageString({
          Constant.textEnUsLanguageKey: "Sponsor Banner",
          Constant.textInIdLanguageKey: "Sponsor Banner"
        }),
        onDynamicItemAction: (title, description, observer) async {
          observer(title, description, IsLoadingLoadDataResult<LoadSponsorBannerAndContentResponse>());
          LoadDataResult<List<TransparentBanner>> bannerLoadDataResult = await getSponsorContentsBannerUseCase.execute().future(
            parameter: apiRequestManager.addRequestToCancellationPart("sponsor-banner-highlight").value
          ).map(
            (transparentBannerList) => transparentBannerList.take(1).map<TransparentBanner>(
              (transparentBanner) => TransparentBanner(
                id: transparentBanner.id,
                title: transparentBanner.title,
                type: transparentBanner.type,
                imageUrl: transparentBanner.imageUrl,
                data: <String, dynamic>{
                  "title": transparentBanner.title,
                  "data": transparentBanner.data
                }
              )
            ).toList()
          );
          if (bannerLoadDataResult.isFailedBecauseCancellation) {
            return;
          }
          String bannerTitle = "";
          if (bannerLoadDataResult.isSuccess) {
            List<TransparentBanner> transparentBannerList = bannerLoadDataResult.resultIfSuccess!;
            if (transparentBannerList.isNotEmpty) {
              TransparentBanner transparentBanner = transparentBannerList.first;
              bannerTitle = transparentBanner.title;
              Banner banner = Banner(
                id: transparentBanner.id,
                imageUrl: transparentBanner.imageUrl,
                data: transparentBanner.data
              );
              _homeMainMenuDelegate?.setBanner(banner);
            }
          } else if (bannerLoadDataResult.isFailed) {
            observer(title, description, bannerLoadDataResult.map<LoadSponsorBannerAndContentResponse>((value) => throw UnimplementedError()));
            return;
          }
          String bannerData = "";
          if (_homeMainMenuDelegate != null) {
            bannerData = _homeMainMenuDelegate!.getBannerData();
          }
          LoadDataResult<List<ProductEntry>> productEntryPagingDataResult = await getProductEntryWithConditionPagingUseCase.execute(
            ProductWithConditionPagingParameter(
              page: 1,
              itemEachPageCount: 20,
              withCondition: {
                "type": "sponsor",
                "brand": bannerData.toLowerCase(),
              }
            )
          ).future(
            parameter: apiRequestManager.addRequestToCancellationPart("product-sponsor").value
          ).map((value) => value.itemList);
          if (productEntryPagingDataResult.isFailedBecauseCancellation) {
            return;
          }
          if (productEntryPagingDataResult.isFailed) {
            observer(title, description, bannerLoadDataResult.map<LoadSponsorBannerAndContentResponse>((value) => throw UnimplementedError()));
            return;
          }
          observer(title, description, productEntryPagingDataResult.map<LoadSponsorBannerAndContentResponse>(
            (value) => LoadSponsorBannerAndContentResponse(
              brandName: bannerTitle,
              sponsorTransparentBannerList: bannerLoadDataResult.resultIfSuccess!,
              sponsorProductEntryList: productEntryPagingDataResult.resultIfSuccess!
            )
          ));
        },
        onObserveLoadingDynamicItemActionState: (title, description, loadDataResult) {
          if (_homeMainMenuDelegate != null) {
            return CompoundListItemControllerState(
              listItemControllerState: [
                VirtualSpacingListItemControllerState(height: 16),
                _homeMainMenuDelegate!.onObserveLoadProductDelegate.onObserveLoadingLoadProductCategoryCarousel(
                  OnObserveLoadingLoadProductCategoryCarouselParameter()
                ),
                VirtualSpacingListItemControllerState(height: 16),
              ]
            );
          }
        },
        onObserveSuccessDynamicItemActionState: (title, description, loadDataResult) {
          LoadSponsorBannerAndContentResponse loadSponsorBannerAndContentResponse = loadDataResult.resultIfSuccess!;
          if (_homeMainMenuDelegate != null) {
            ListItemControllerState result = _homeMainMenuDelegate!.onObserveSuccessLoadProductSponsor(
              _OnObserveSuccessLoadProductSponsorParameter(
                loadSponsorBannerAndContentResponse: loadSponsorBannerAndContentResponse,
                onCreateProductSponsorCarousel: () {
                  return CompoundListItemControllerState(
                    listItemControllerState: [
                      _homeMainMenuDelegate!.onObserveLoadProductDelegate.onObserveSuccessLoadProductEntryCarousel(
                        OnObserveSuccessLoadProductEntryCarouselParameter(
                          title: title,
                          description: description,
                          productEntryList: loadSponsorBannerAndContentResponse.sponsorProductEntryList,
                          data: Constant.carouselKeyProductSponsor
                        )
                      ),
                      VirtualSpacingListItemControllerState(height: 16),
                    ]
                  );
                }
              )
            );
            return result;
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
          observer(title, description, IsLoadingLoadDataResult<List<ProductBundle>>());
          LoadDataResult<List<ProductBundle>> productBundleHighlightMultipleListDataResult = await getProductBundlePagingUseCase.execute(
            ProductBundlePagingParameter(page: 1, itemEachPageCount: 20)
          ).future(
            parameter: apiRequestManager.addRequestToCancellationPart("product-bundle-highlight-multiple").value
          ).map((value) {
            return value.itemList;
          });
          if (productBundleHighlightMultipleListDataResult.isFailedBecauseCancellation) {
            return;
          }
          observer(title, description, productBundleHighlightMultipleListDataResult);
        },
        onObserveLoadingDynamicItemActionState: (title, description, loadDataResult) {
          if (_homeMainMenuDelegate != null) {
            return CompoundListItemControllerState(
              listItemControllerState: [
                VirtualSpacingListItemControllerState(height: 16),
                _homeMainMenuDelegate!.onObserveLoadProductDelegate.onObserveLoadingLoadProductCategoryCarousel(
                  OnObserveLoadingLoadProductCategoryCarouselParameter()
                ),
                VirtualSpacingListItemControllerState(height: 16),
              ]
            );
          }
        },
        onObserveSuccessDynamicItemActionState: (title, description, loadDataResult) {
          List<ProductBundle> productBundleList = loadDataResult.resultIfSuccess!;
          if (_homeMainMenuDelegate != null) {
            return _homeMainMenuDelegate!.onObserveSuccessLoadProductBundleHighlight(
              _OnObserveSuccessLoadProductBundleHighlightParameter(
                title: title,
                description: description,
                productBundleList: productBundleList
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
            return CompoundListItemControllerState(
              listItemControllerState: [
                VirtualSpacingListItemControllerState(height: 16),
                _homeMainMenuDelegate!.onObserveLoadProductDelegate.onObserveLoadingLoadProductCategoryCarousel(
                  OnObserveLoadingLoadProductCategoryCarouselParameter()
                ),
                VirtualSpacingListItemControllerState(height: 16),
              ]
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
          Constant.textEnUsLanguageKey: "Teh & Coffee Origin Indonesia",
          Constant.textInIdLanguageKey: "Teh & Kopi Asli Indonesia"
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
            return CompoundListItemControllerState(
              listItemControllerState: [
                VirtualSpacingListItemControllerState(height: 16),
                _homeMainMenuDelegate!.onObserveLoadProductDelegate.onObserveLoadingLoadProductCategoryCarousel(
                  OnObserveLoadingLoadProductCategoryCarouselParameter()
                ),
                VirtualSpacingListItemControllerState(height: 16),
              ]
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
            return CompoundListItemControllerState(
              listItemControllerState: [
                VirtualSpacingListItemControllerState(height: 16),
                _homeMainMenuDelegate!.onObserveLoadProductDelegate.onObserveLoadingLoadProductCategoryCarousel(
                  OnObserveLoadingLoadProductCategoryCarouselParameter()
                ),
                VirtualSpacingListItemControllerState(height: 16),
              ]
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
        title: Constant.multiLanguageStringSelectedFashionBrands,
        onDynamicItemAction: (title, description, observer) async {
          observer(title, description, IsLoadingLoadDataResult<List<ProductBrand>>());
          LoadDataResult<List<ProductBrand>> productEntryPagingDataResult = await getSelectedFashionBrandsListUseCase.execute().future(
            parameter: apiRequestManager.addRequestToCancellationPart("selected-fashion-brands").value
          );
          if (productEntryPagingDataResult.isFailedBecauseCancellation) {
            return;
          }
          observer(title, description, productEntryPagingDataResult);
        },
        onObserveLoadingDynamicItemActionState: (title, description, loadDataResult) {
          if (_homeMainMenuDelegate != null) {
            return CompoundListItemControllerState(
              listItemControllerState: [
                VirtualSpacingListItemControllerState(height: 16),
                _homeMainMenuDelegate!.onObserveLoadProductDelegate.onObserveLoadingLoadProductBrandCarousel(
                  OnObserveLoadingLoadProductBrandCarouselParameter()
                ),
                VirtualSpacingListItemControllerState(height: 16),
              ]
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
                data: Constant.carouselKeySelectedFashionBrands
              )
            );
          }
          throw MessageError(title: "Home main menu delegate must be initialized");
        },
      ),
      DynamicItemCarouselHomeMainMenuComponentEntity(
        title: MultiLanguageString({
          Constant.textEnUsLanguageKey: "Indonesian Fashion Products",
          Constant.textInIdLanguageKey: "Produk Fesyen Indonesia"
        }),
        onDynamicItemAction: (title, description, observer) async {
          observer(title, description, IsLoadingLoadDataResult<List<ProductEntry>>());
          LoadDataResult<List<ProductEntry>> productEntryPagingDataResult = await getFashionProductIndonesiaListUseCase.execute().future(
            parameter: apiRequestManager.addRequestToCancellationPart("fashiion-product-indonesia").value
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
            return CompoundListItemControllerState(
              listItemControllerState: [
                VirtualSpacingListItemControllerState(height: 16),
                _homeMainMenuDelegate!.onObserveLoadProductDelegate.onObserveLoadingLoadProductCategoryCarousel(
                  OnObserveLoadingLoadProductCategoryCarouselParameter()
                ),
                VirtualSpacingListItemControllerState(height: 16),
              ]
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
                data: Constant.carouselKeyFashionProductIndonesia
              )
            );
          }
          throw MessageError(title: "Home main menu delegate must be initialized");
        },
      ),
      DynamicItemCarouselHomeMainMenuComponentEntity(
        title: Constant.multiLanguageStringChoiceBeautyBrand,
        onDynamicItemAction: (title, description, observer) async {
          observer(title, description, IsLoadingLoadDataResult<List<ProductBrand>>());
          LoadDataResult<List<ProductBrand>> productEntryPagingDataResult = await getSelectedBeautyBrandsListUseCase.execute().future(
            parameter: apiRequestManager.addRequestToCancellationPart("choice-beauty-brand").value
          );
          if (productEntryPagingDataResult.isFailedBecauseCancellation) {
            return;
          }
          observer(title, description, productEntryPagingDataResult);
        },
        onObserveLoadingDynamicItemActionState: (title, description, loadDataResult) {
          if (_homeMainMenuDelegate != null) {
            return CompoundListItemControllerState(
              listItemControllerState: [
                VirtualSpacingListItemControllerState(height: 16),
                _homeMainMenuDelegate!.onObserveLoadProductDelegate.onObserveLoadingLoadProductBrandCarousel(
                  OnObserveLoadingLoadProductBrandCarouselParameter()
                ),
                VirtualSpacingListItemControllerState(height: 16),
              ]
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
                data: Constant.carouselKeyChoiceBeautyBrand
              )
            );
          }
          throw MessageError(title: "Home main menu delegate must be initialized");
        },
      ),
      DynamicItemCarouselHomeMainMenuComponentEntity(
        title: MultiLanguageString({
          Constant.textEnUsLanguageKey: "Indonesian Beauty Products",
          Constant.textInIdLanguageKey: "Produk Kecantikan Indonesia"
        }),
        onDynamicItemAction: (title, description, observer) async {
          observer(title, description, IsLoadingLoadDataResult<List<ProductEntry>>());
          LoadDataResult<List<ProductEntry>> productEntryPagingDataResult = await getBeautyProductIndonesiaListUseCase.execute().future(
            parameter: apiRequestManager.addRequestToCancellationPart("beauty-product-indonesia").value
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
            return CompoundListItemControllerState(
              listItemControllerState: [
                VirtualSpacingListItemControllerState(height: 16),
                _homeMainMenuDelegate!.onObserveLoadProductDelegate.onObserveLoadingLoadProductCategoryCarousel(
                  OnObserveLoadingLoadProductCategoryCarouselParameter()
                ),
                VirtualSpacingListItemControllerState(height: 16),
              ]
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
                data: Constant.carouselKeyBeautyProductIndonesia
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
            return CompoundListItemControllerState(
              listItemControllerState: [
                VirtualSpacingListItemControllerState(height: 16),
                _homeMainMenuDelegate!.onObserveLoadProductDelegate.onObserveLoadingLoadProductCategoryCarousel(
                  OnObserveLoadingLoadProductCategoryCarouselParameter()
                ),
                VirtualSpacingListItemControllerState(height: 16),
              ]
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
          Constant.textEnUsLanguageKey: "Only For You",
          Constant.textInIdLanguageKey: "Hanya Untuk Kamu"
        }),
        onDynamicItemAction: (title, description, observer) async {
          observer(title, description, IsLoadingLoadDataResult<List<ProductEntry>>());
          LoadDataResult<List<ProductEntry>> productEntryPagingDataResult = await getOnlyForYouListUseCase.execute().future(
            parameter: apiRequestManager.addRequestToCancellationPart("only-for-you").value
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
            return CompoundListItemControllerState(
              listItemControllerState: [
                VirtualSpacingListItemControllerState(height: 16),
                _homeMainMenuDelegate!.onObserveLoadProductDelegate.onObserveLoadingLoadProductCategoryCarousel(
                  OnObserveLoadingLoadProductCategoryCarouselParameter()
                ),
                VirtualSpacingListItemControllerState(height: 16),
              ]
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
                data: Constant.carouselKeyOnlyForYou
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
  final GetProductEntryWithConditionPagingUseCase getProductEntryWithConditionPagingUseCase;
  final GetProductBrandListUseCase getProductBrandListUseCase;
  final GetProductViralListUseCase getProductViralListUseCase;
  final GetProductCategoryListUseCase getProductCategoryListUseCase;
  final GetProductBundleListUseCase getProductBundleListUseCase;
  final GetProductBundleHighlightUseCase getProductBundleHighlightUseCase;
  final GetProductBundlePagingUseCase getProductBundlePagingUseCase;
  final GetSnackForLyingAroundListUseCase getSnackForLyingAroundListUseCase;
  final GetBestsellerInMasterbagasiListUseCase getBestsellerInMasterbagasiListUseCase;
  final GetSelectedFashionBrandsListUseCase getSelectedFashionBrandsListUseCase;
  final GetCoffeeAndTeaOriginIndonesiaListUseCase getCoffeeAndTeaOriginIndonesiaListUseCase;
  final GetBeautyProductIndonesiaListUseCase getBeautyProductIndonesiaListUseCase;
  final GetSelectedBeautyBrandsListUseCase getSelectedBeautyBrandsListUseCase;
  final GetFashionProductIndonesiaListUseCase getFashionProductIndonesiaListUseCase;
  final GetReadyToEatStreetFoodStyleListUseCase getReadyToEatStreetFoodStyleListUseCase;
  final GetOnlyForYouListUseCase getOnlyForYouListUseCase;
  final GetHandycraftsContentsBannerUseCase getHandycraftsContentsBannerUseCase;
  final GetKitchenContentsBannerUseCase getKitchenContentsBannerUseCase;
  final GetHomepageContentsBannerUseCase getHomepageContentsBannerUseCase;
  final GetShippingPriceContentsBannerUseCase getShippingPriceContentsBannerUseCase;
  final GetSponsorContentsBannerUseCase getSponsorContentsBannerUseCase;
  final AddWishlistUseCase addWishlistUseCase;
  final GetCurrentSelectedAddressUseCase getCurrentSelectedAddressUseCase;
  final WishlistAndCartControllerContentDelegate wishlistAndCartControllerContentDelegate;

  HomeMainMenuSubControllerInjectionFactory({
    required this.getProductEntryWithConditionPagingUseCase,
    required this.getProductBrandListUseCase,
    required this.getProductViralListUseCase,
    required this.getProductCategoryListUseCase,
    required this.getProductBundleListUseCase,
    required this.getProductBundleHighlightUseCase,
    required this.getProductBundlePagingUseCase,
    required this.getSnackForLyingAroundListUseCase,
    required this.getBestsellerInMasterbagasiListUseCase,
    required this.getSelectedFashionBrandsListUseCase,
    required this.getCoffeeAndTeaOriginIndonesiaListUseCase,
    required this.getBeautyProductIndonesiaListUseCase,
    required this.getSelectedBeautyBrandsListUseCase,
    required this.getFashionProductIndonesiaListUseCase,
    required this.getReadyToEatStreetFoodStyleListUseCase,
    required this.getOnlyForYouListUseCase,
    required this.getHandycraftsContentsBannerUseCase,
    required this.getKitchenContentsBannerUseCase,
    required this.getHomepageContentsBannerUseCase,
    required this.getShippingPriceContentsBannerUseCase,
    required this.getSponsorContentsBannerUseCase,
    required this.addWishlistUseCase,
    required this.getCurrentSelectedAddressUseCase,
    required this.wishlistAndCartControllerContentDelegate
  });

  HomeMainMenuSubController inject(ControllerManager controllerManager, String pageName) {
    return GetExtended.put<HomeMainMenuSubController>(
      HomeMainMenuSubController(
        controllerManager,
        getProductEntryWithConditionPagingUseCase,
        getProductBrandListUseCase,
        getProductViralListUseCase,
        getProductCategoryListUseCase,
        getProductBundleListUseCase,
        getProductBundleHighlightUseCase,
        getProductBundlePagingUseCase,
        addWishlistUseCase,
        getSnackForLyingAroundListUseCase,
        getBestsellerInMasterbagasiListUseCase,
        getSelectedFashionBrandsListUseCase,
        getSelectedBeautyBrandsListUseCase,
        getCoffeeAndTeaOriginIndonesiaListUseCase,
        getBeautyProductIndonesiaListUseCase,
        getFashionProductIndonesiaListUseCase,
        getReadyToEatStreetFoodStyleListUseCase,
        getOnlyForYouListUseCase,
        getHandycraftsContentsBannerUseCase,
        getKitchenContentsBannerUseCase,
        getHomepageContentsBannerUseCase,
        getShippingPriceContentsBannerUseCase,
        getSponsorContentsBannerUseCase,
        getCurrentSelectedAddressUseCase,
        wishlistAndCartControllerContentDelegate
      ),
      tag: pageName
    );
  }
}

class HomeMainMenuDelegate {
  OnObserveLoadProductDelegate onObserveLoadProductDelegate;
  ListItemControllerState Function(_OnObserveSuccessLoadProductBundleHighlightParameter) onObserveSuccessLoadProductBundleHighlight;
  ListItemControllerState Function(_OnObserveLoadingLoadProductBundleHighlightParameter) onObserveLoadingLoadProductBundleHighlight;
  ListItemControllerState Function(_OnObserveSuccessLoadMultipleTransparentBannerParameter) onObserveSuccessLoadMultipleTransparentBanner;
  ListItemControllerState Function(_OnObserveSuccessLoadTransparentBannerParameter) onObserveSuccessLoadTransparentBanner;
  ListItemControllerState Function(_OnObserveLoadingLoadTransparentBannerParameter) onObserveLoadingLoadTransparentBanner;
  ListItemControllerState Function(_OnObserveLoadCurrentAddressParameter) onObserveLoadCurrentAddress;
  ListItemControllerState Function(_OnObserveSuccessLoadProductSponsorParameter) onObserveSuccessLoadProductSponsor;
  String Function() getBannerData;
  void Function(Banner) setBanner;

  HomeMainMenuDelegate({
    required this.onObserveLoadProductDelegate,
    required this.onObserveSuccessLoadProductBundleHighlight,
    required this.onObserveLoadingLoadProductBundleHighlight,
    required this.onObserveSuccessLoadMultipleTransparentBanner,
    required this.onObserveSuccessLoadTransparentBanner,
    required this.onObserveLoadingLoadTransparentBanner,
    required this.onObserveLoadCurrentAddress,
    required this.onObserveSuccessLoadProductSponsor,
    required this.getBannerData,
    required this.setBanner
  });
}

class _OnObserveSuccessLoadProductBundleHighlightParameter {
  MultiLanguageString? title;
  MultiLanguageString? description;
  List<ProductBundle> productBundleList;

  _OnObserveSuccessLoadProductBundleHighlightParameter({
    required this.title,
    required this.description,
    required this.productBundleList,
  });
}

class _OnObserveLoadingLoadProductBundleHighlightParameter {}

class _OnObserveSuccessLoadMultipleTransparentBannerParameter {
  MultiLanguageString? title;
  MultiLanguageString? description;
  List<TransparentBanner> transparentBannerList;
  dynamic data;

  _OnObserveSuccessLoadMultipleTransparentBannerParameter({
    required this.title,
    required this.description,
    required this.transparentBannerList,
    this.data
  });
}

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
  RepeatableDynamicItemCarouselAdditionalParameter repeatableDynamicItemCarouselAdditionalParameter;

  _OnObserveLoadCurrentAddressParameter({
    required this.addressLoadDataResult,
    required this.repeatableDynamicItemCarouselAdditionalParameter
  });
}

class _OnObserveSuccessLoadProductSponsorParameter {
  LoadSponsorBannerAndContentResponse loadSponsorBannerAndContentResponse;
  ListItemControllerState Function() onCreateProductSponsorCarousel;

  _OnObserveSuccessLoadProductSponsorParameter({
    required this.loadSponsorBannerAndContentResponse,
    required this.onCreateProductSponsorCarousel
  });
}

class ProductSponsorTransparentBannerParameterData {
  RepeatableDynamicItemCarouselAdditionalParameter? repeatableDynamicItemCarouselAdditionalParameter;

  ProductSponsorTransparentBannerParameterData({
    required this.repeatableDynamicItemCarouselAdditionalParameter
  });
}

class LoadSponsorBannerAndContentResponse {
  String brandName;
  List<TransparentBanner> sponsorTransparentBannerList;
  List<ProductEntry> sponsorProductEntryList;

  LoadSponsorBannerAndContentResponse({
    required this.brandName,
    required this.sponsorTransparentBannerList,
    required this.sponsorProductEntryList
  });
}