import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../domain/entity/cart/support_cart.dart';
import '../domain/entity/componententity/dynamic_item_carousel_component_entity.dart';
import '../domain/entity/componententity/dynamic_item_carousel_directly_component_entity.dart';
import '../domain/entity/componententity/i_component_entity.dart';
import '../domain/entity/componententity/i_dynamic_item_carousel_component_entity.dart';
import '../domain/entity/order/purchase_direct_parameter.dart';
import '../domain/entity/order/purchase_direct_response.dart';
import '../domain/entity/product/product_detail.dart';
import '../domain/entity/product/product_detail_by_slug_parameter.dart';
import '../domain/entity/product/product_detail_from_your_search_product_entry_list_parameter.dart';
import '../domain/entity/product/product_detail_get_other_from_this_brand_parameter.dart';
import '../domain/entity/product/product_detail_get_other_in_this_category_parameter.dart';
import '../domain/entity/product/product_detail_other_chosen_for_you_product_entry_list_parameter.dart';
import '../domain/entity/product/product_detail_other_from_this_brand_product_entry_list_parameter.dart';
import '../domain/entity/product/product_detail_other_in_this_category_product_entry_list_parameter.dart';
import '../domain/entity/product/product_detail_other_interested_product_brand_list_parameter.dart';
import '../domain/entity/product/product_detail_parameter.dart';
import '../domain/entity/product/productbrand/product_brand.dart';
import '../domain/entity/product/productdiscussion/product_discussion.dart';
import '../domain/entity/product/productdiscussion/product_discussion_list_parameter.dart';
import '../domain/entity/product/productentry/product_entry.dart';
import '../domain/entity/product/shareproduct/share_product_parameter.dart';
import '../domain/entity/product/shareproduct/share_product_response.dart';
import '../domain/entity/search/store_search_last_seen_history_parameter.dart';
import '../domain/entity/search/store_search_last_seen_history_response.dart';
import '../domain/usecase/add_to_cart_use_case.dart';
import '../domain/usecase/get_product_detail_by_slug_use_case.dart';
import '../domain/usecase/get_product_detail_from_your_search_product_entry_list_use_case.dart';
import '../domain/usecase/get_product_detail_other_chosen_for_you_product_entry_list_use_case.dart';
import '../domain/usecase/get_product_detail_other_from_this_brand_product_entry_list_use_case.dart';
import '../domain/usecase/get_product_detail_other_in_this_category_product_entry_list_use_case.dart';
import '../domain/usecase/get_product_detail_other_interested_product_brand_list_use_case.dart';
import '../domain/usecase/get_product_detail_use_case.dart';
import '../domain/usecase/get_product_discussion_use_case.dart';
import '../domain/usecase/purchase_direct_use_case.dart';
import '../domain/usecase/share_product_use_case.dart';
import '../domain/usecase/store_search_last_seen_history_use_case.dart';
import '../misc/constant.dart';
import '../misc/controllercontentdelegate/product_brand_favorite_controller_content_delegate.dart';
import '../misc/controllercontentdelegate/wishlist_and_cart_controller_content_delegate.dart';
import '../misc/controllerstate/listitemcontrollerstate/failed_prompt_indicator_list_item_controller_state.dart';
import '../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../misc/controllerstate/listitemcontrollerstate/loading_list_item_controller_state.dart';
import '../misc/controllerstate/listitemcontrollerstate/no_content_list_item_controller_state.dart';
import '../misc/entityandlistitemcontrollerstatemediator/horizontal_component_entity_parameterized_entity_and_list_item_controller_state_mediator.dart';
import '../misc/error/message_error.dart';
import '../misc/load_data_result.dart';
import '../misc/multi_language_string.dart';
import '../misc/on_observe_load_product_delegate.dart';
import '../misc/typedef.dart';
import 'base_getx_controller.dart';

typedef _OnGetSupportCart = SupportCart? Function();
typedef _OnGetSelectedPaymentMethodSettlingId = String? Function();
typedef _OnGetSelectedCouponId = String? Function();
typedef _OnShowAddToCartRequestProcessLoadingCallback = Future<void> Function();
typedef _OnAddToCartRequestProcessSuccessCallback = Future<void> Function();
typedef _OnShowAddToCartRequestProcessFailedCallback = Future<void> Function(dynamic e);
typedef _OnShowBuyDirectlyRequestProcessLoadingCallback = Future<void> Function();
typedef _OnBuyDirectlyRequestProcessSuccessCallback = Future<void> Function(PurchaseDirectResponse purchaseDirectResponse);
typedef _OnShowBuyDirectlyRequestProcessFailedCallback = Future<void> Function(dynamic e);
typedef _OnShowShareProductRequestProcessLoadingCallback = Future<void> Function();
typedef _OnShareProductRequestProcessSuccessCallback = Future<void> Function(ShareProductResponse);
typedef _OnShowShareProductRequestProcessFailedCallback = Future<void> Function(dynamic e);

class ProductDetailController extends BaseGetxController {
  final GetProductDetailUseCase getProductDetailUseCase;
  final GetProductDetailBySlugUseCase getProductDetailBySlugUseCase;
  final GetProductDetailOtherChosenForYouProductEntryListUseCase getProductDetailOtherChosenForYouProductEntryListUseCase;
  final GetProductDetailOtherFromThisBrandProductEntryListUseCase getProductDetailOtherFromThisBrandProductEntryListUseCase;
  final GetProductDetailOtherInThisCategoryProductEntryListUseCase getProductDetailOtherInThisCategoryProductEntryListUseCase;
  final GetProductDetailFromYourSearchProductEntryListUseCase getProductDetailFromYourSearchProductEntryListUseCase;
  final GetProductDetailOtherInterestedProductBrandListUseCase getProductDetailOtherInterestedProductBrandListUseCase;
  final PurchaseDirectUseCase purchaseDirectUseCase;
  final AddToCartUseCase addToCartUseCase;
  final GetProductDiscussionUseCase getProductDiscussionUseCase;
  final StoreSearchLastSeenHistoryUseCase storeSearchLastSeenHistoryUseCase;
  final ShareProductUseCase shareProductUseCase;
  final WishlistAndCartControllerContentDelegate wishlistAndCartControllerContentDelegate;
  final ProductBrandFavoriteControllerContentDelegate productBrandFavoriteControllerContentDelegate;
  ProductDetailMainMenuDelegate? _productDetailMainMenuDelegate;

  ProductDetailController(
    super.controllerManager,
    this.getProductDetailUseCase,
    this.getProductDetailBySlugUseCase,
    this.getProductDetailOtherChosenForYouProductEntryListUseCase,
    this.getProductDetailOtherFromThisBrandProductEntryListUseCase,
    this.getProductDetailOtherInThisCategoryProductEntryListUseCase,
    this.getProductDetailFromYourSearchProductEntryListUseCase,
    this.getProductDetailOtherInterestedProductBrandListUseCase,
    this.purchaseDirectUseCase,
    this.addToCartUseCase,
    this.getProductDiscussionUseCase,
    this.storeSearchLastSeenHistoryUseCase,
    this.shareProductUseCase,
    this.wishlistAndCartControllerContentDelegate,
    this.productBrandFavoriteControllerContentDelegate
  ) {
    wishlistAndCartControllerContentDelegate.setApiRequestManager(() => apiRequestManager);
    productBrandFavoriteControllerContentDelegate.setApiRequestManager(() => apiRequestManager);
  }

  Future<LoadDataResult<ProductDetail>> getProductDetail(ProductDetailParameter productDetailParameter) {
    return getProductDetailUseCase.execute(productDetailParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("product-detail").value
    );
  }

  Future<LoadDataResult<ProductDetail>> getProductDetailBySlug(ProductDetailBySlugParameter productDetailBySlugParameter) {
    return getProductDetailBySlugUseCase.execute(productDetailBySlugParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("product-detail-by-slug").value
    );
  }

  Future<LoadDataResult<StoreSearchLastSeenHistoryResponse>> storeSearchLastSeenHistoryResponse(StoreSearchLastSeenHistoryParameter storeSearchLastSeenHistoryParameter) {
    return storeSearchLastSeenHistoryUseCase.execute(storeSearchLastSeenHistoryParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("store-search-last-seen-history").value
    );
  }

  IDynamicItemCarouselComponentEntity getOtherFromThisBrand(ProductDetailGetOtherFromThisBrandParameter productDetailGetOtherFromThisBrandParameter) {
    return DynamicItemCarouselComponentEntity(
      title: Constant.multiLanguageStringOtherFromThisBrand,
      onDynamicItemAction: (title, description, observer) async {
        observer(title, description, IsLoadingLoadDataResult<List<ProductEntry>>());
        LoadDataResult<List<ProductEntry>> productEntryPagingDataResult = await getProductDetailOtherFromThisBrandProductEntryListUseCase.execute(
          ProductDetailOtherFromThisBrandProductEntryListParameter(
            brandSlug: productDetailGetOtherFromThisBrandParameter.brandSlug
          )
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPart("other-from-this-brand-product-entry-list").value
        );
        if (productEntryPagingDataResult.isFailedBecauseCancellation) {
          return;
        }
        observer(title, description, productEntryPagingDataResult.map<List<ProductEntry>>(
          (productEntryList) => productEntryList
        ));
      },
      onObserveLoadingDynamicItemActionState: (title, description, loadDataResult) {
        if (_productDetailMainMenuDelegate != null) {
          return _productDetailMainMenuDelegate!.onObserveLoadProductDelegate.onObserveLoadingLoadProductEntryCarousel(
            OnObserveLoadingLoadProductEntryCarouselParameter()
          );
        }
        throw MessageError(title: "Product detail delegate must be initialized");
      },
      onObserveSuccessDynamicItemActionState: (title, description, loadDataResult) {
        List<ProductEntry> productEntryList = loadDataResult.resultIfSuccess!;
        if (_productDetailMainMenuDelegate != null) {
          return _productDetailMainMenuDelegate!.onObserveLoadProductDelegate.onObserveSuccessLoadProductEntryCarousel(
            OnObserveSuccessLoadProductEntryCarouselParameter(
              title: title,
              description: description,
              productEntryList: productEntryList,
              data: Constant.carouselKeyProductDetailOtherFromThisBrand
            )
          );
        }
        throw MessageError(title: "Product detail delegate must be initialized");
      },
    );
  }

  IDynamicItemCarouselComponentEntity getOtherChosenForYou() {
    return DynamicItemCarouselComponentEntity(
      title: Constant.multiLanguageStringOtherChosenForYou,
      onDynamicItemAction: (title, description, observer) async {
        observer(title, description, IsLoadingLoadDataResult<List<ProductEntry>>());
        LoadDataResult<List<ProductEntry>> productEntryPagingDataResult = await getProductDetailOtherChosenForYouProductEntryListUseCase.execute(
          ProductDetailOtherChosenForYouProductEntryListParameter()
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPart("other-choosen-for-you-product-entry-list").value
        );
        if (productEntryPagingDataResult.isFailedBecauseCancellation) {
          return;
        }
        observer(title, description, productEntryPagingDataResult.map<List<ProductEntry>>(
          (productEntryList) => productEntryList
        ));
      },
      onObserveLoadingDynamicItemActionState: (title, description, loadDataResult) {
        if (_productDetailMainMenuDelegate != null) {
          return _productDetailMainMenuDelegate!.onObserveLoadProductDelegate.onObserveLoadingLoadProductEntryCarousel(
            OnObserveLoadingLoadProductEntryCarouselParameter()
          );
        }
        throw MessageError(title: "Product detail delegate must be initialized");
      },
      onObserveSuccessDynamicItemActionState: (title, description, loadDataResult) {
        List<ProductEntry> productEntryList = loadDataResult.resultIfSuccess!;
        if (_productDetailMainMenuDelegate != null) {
          return _productDetailMainMenuDelegate!.onObserveLoadProductDelegate.onObserveSuccessLoadProductEntryCarousel(
            OnObserveSuccessLoadProductEntryCarouselParameter(
              title: title,
              description: description,
              productEntryList: productEntryList,
              data: Constant.carouselKeyProductDetailOtherChosenForYou
            )
          );
        }
        throw MessageError(title: "Product detail delegate must be initialized");
      },
    );
  }

  IDynamicItemCarouselComponentEntity getOtherInThisCategory(ProductDetailGetOtherInThisCategoryParameter productDetailGetOtherInThisCategoryParameter) {
    return DynamicItemCarouselComponentEntity(
      title: MultiLanguageString({
        Constant.textEnUsLanguageKey: "Other In This Category",
        Constant.textInIdLanguageKey: "Lainnya Di Kategory Ini"
      }),
      onDynamicItemAction: (title, description, observer) async {
        observer(title, description, IsLoadingLoadDataResult<List<ProductEntry>>());
        LoadDataResult<List<ProductEntry>> productEntryPagingDataResult = await getProductDetailOtherInThisCategoryProductEntryListUseCase.execute(
          ProductDetailOtherInThisCategoryProductEntryListParameter(
            categorySlug: productDetailGetOtherInThisCategoryParameter.categorySlug
          )
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPart("other-in-this-category-product-entry-list").value
        );
        if (productEntryPagingDataResult.isFailedBecauseCancellation) {
          return;
        }
        observer(title, description, productEntryPagingDataResult.map<List<ProductEntry>>(
          (productEntryList) => productEntryList
        ));
      },
      onObserveLoadingDynamicItemActionState: (title, description, loadDataResult) {
        if (_productDetailMainMenuDelegate != null) {
          return _productDetailMainMenuDelegate!.onObserveLoadProductDelegate.onObserveLoadingLoadProductEntryCarousel(
            OnObserveLoadingLoadProductEntryCarouselParameter()
          );
        }
        throw MessageError(title: "Product detail delegate must be initialized");
      },
      onObserveSuccessDynamicItemActionState: (title, description, loadDataResult) {
        List<ProductEntry> productEntryList = loadDataResult.resultIfSuccess!;
        if (_productDetailMainMenuDelegate != null) {
          return _productDetailMainMenuDelegate!.onObserveLoadProductDelegate.onObserveSuccessLoadProductEntryCarousel(
            OnObserveSuccessLoadProductEntryCarouselParameter(
              title: title,
              description: description,
              productEntryList: productEntryList,
              data: Constant.carouselKeyProductDetailOtherInThisCategory
            )
          );
        }
        throw MessageError(title: "Product detail delegate must be initialized");
      },
    );
  }

  IDynamicItemCarouselComponentEntity getOtherFromYourSearch() {
    return DynamicItemCarouselComponentEntity(
      title: Constant.multiLanguageStringFromYourSearch,
      onDynamicItemAction: (title, description, observer) async {
        observer(title, description, IsLoadingLoadDataResult<List<ProductEntry>>());
        LoadDataResult<List<ProductEntry>> productEntryPagingDataResult = await getProductDetailFromYourSearchProductEntryListUseCase.execute(
          ProductDetailFromYourSearchProductEntryListParameter()
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPart("other-from-your-search-product-entry-list").value
        );
        if (productEntryPagingDataResult.isFailedBecauseCancellation) {
          return;
        }
        observer(title, description, productEntryPagingDataResult.map<List<ProductEntry>>(
          (productEntryList) => productEntryList
        ));
      },
      onObserveLoadingDynamicItemActionState: (title, description, loadDataResult) {
        if (_productDetailMainMenuDelegate != null) {
          return _productDetailMainMenuDelegate!.onObserveLoadProductDelegate.onObserveLoadingLoadProductEntryCarousel(
            OnObserveLoadingLoadProductEntryCarouselParameter()
          );
        }
        throw MessageError(title: "Product detail delegate must be initialized");
      },
      onObserveSuccessDynamicItemActionState: (title, description, loadDataResult) {
        List<ProductEntry> productEntryList = loadDataResult.resultIfSuccess!;
        if (_productDetailMainMenuDelegate != null) {
          return _productDetailMainMenuDelegate!.onObserveLoadProductDelegate.onObserveSuccessLoadProductEntryCarousel(
            OnObserveSuccessLoadProductEntryCarouselParameter(
              title: title,
              description: description,
              productEntryList: productEntryList,
              data: Constant.carouselKeyProductDetailFromYourSearch
            )
          );
        }
        throw MessageError(title: "Product detail delegate must be initialized");
      },
    );
  }

  IDynamicItemCarouselComponentEntity getOtherInterestedProductBrand() {
    return DynamicItemCarouselComponentEntity(
      title: MultiLanguageString({
        Constant.textEnUsLanguageKey: "Other Interested Brand",
        Constant.textInIdLanguageKey: "Brand Menarik Lainnya"
      }),
      onDynamicItemAction: (title, description, observer) async {
        observer(title, description, IsLoadingLoadDataResult<List<ProductBrand>>());
        LoadDataResult<List<ProductBrand>> productEntryPagingDataResult = await getProductDetailOtherInterestedProductBrandListUseCase.execute(
          ProductDetailOtherInterestedProductBrandListParameter()
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPart("other-interested-product-brand-list").value
        );
        if (productEntryPagingDataResult.isFailedBecauseCancellation) {
          return;
        }
        observer(title, description, productEntryPagingDataResult.map<List<ProductBrand>>(
          (productBrandList) => productBrandList
        ));
      },
      onObserveLoadingDynamicItemActionState: (title, description, loadDataResult) {
        if (_productDetailMainMenuDelegate != null) {
          return _productDetailMainMenuDelegate!.onObserveLoadProductDelegate.onObserveLoadingLoadProductBrandCarousel(
            OnObserveLoadingLoadProductBrandCarouselParameter()
          );
        }
        throw MessageError(title: "Product detail delegate must be initialized");
      },
      onObserveSuccessDynamicItemActionState: (title, description, loadDataResult) {
        List<ProductBrand> productBrandList = loadDataResult.resultIfSuccess!;
        if (_productDetailMainMenuDelegate != null) {
          return _productDetailMainMenuDelegate!.onObserveLoadProductDelegate.onObserveSuccessLoadProductBrandCarousel(
            OnObserveSuccessLoadProductBrandCarouselParameter(
              title: title,
              description: description,
              productBrandList: productBrandList,
              data: Constant.carouselKeyProductDetailOtherInterestedBrand
            )
          );
        }
        throw MessageError(title: "Product detail delegate must be initialized");
      },
    );
  }

  IComponentEntity getShortProductDiscussion() {
    RepeatableDynamicItemCarouselAdditionalParameter repeatableDynamicItemCarouselAdditionalParameter = RepeatableDynamicItemCarouselAdditionalParameter();
    return DynamicItemCarouselDirectlyComponentEntity(
      title: MultiLanguageString(""),
      onDynamicItemAction: (title, description, observer) async {
        observer(title, description, IsLoadingLoadDataResult<ProductDiscussion>());
        String productId = "";
        if (_productDetailMainMenuDelegate != null) {
          SupportCart? supportCart = _productDetailMainMenuDelegate!.onGetSupportCart();
          if (supportCart is ProductEntry) {
            productId = supportCart.productId;
          }
        }
        LoadDataResult<ProductDiscussion> productDiscussionLoadDataResult = await getProductDiscussionUseCase.execute(
          ProductDiscussionParameter(productId: productId)
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPart("short-product-discussion").value
        );
        if (productDiscussionLoadDataResult.isFailedBecauseCancellation) {
          return;
        }
        observer(title, description, productDiscussionLoadDataResult);
      },
      observeDynamicItemActionStateDirectly: (title, description, loadDataResult, errorProvider) {
        LoadDataResult<ProductDiscussion> productDiscussionLoadDataResult = loadDataResult.castFromDynamic<ProductDiscussion>();
        if (_productDetailMainMenuDelegate != null) {
          return _productDetailMainMenuDelegate!.onObserveLoadShortProductDiscussionDirectly(
            _OnObserveLoadShortProductDiscussionParameter(
              successResultProductDiscussion: productDiscussionLoadDataResult.resultIfSuccess,
              repeatableDynamicItemCarouselAdditionalParameter: repeatableDynamicItemCarouselAdditionalParameter,
              onGetDefaultListItemControllerState: () {
                if (productDiscussionLoadDataResult.isLoading) {
                  return LoadingListItemControllerState();
                } else if (productDiscussionLoadDataResult.isFailed) {
                  return FailedPromptIndicatorListItemControllerState(
                    errorProvider: errorProvider,
                    e: productDiscussionLoadDataResult.resultIfFailed
                  );
                } else {
                  return null;
                }
              }
            )
          );
        }
        return NoContentListItemControllerState();
      },
      dynamicItemCarouselAdditionalParameter: repeatableDynamicItemCarouselAdditionalParameter
    );
  }

  void setProductDetailMainMenuDelegate(ProductDetailMainMenuDelegate productDetailMainMenuDelegate) {
    _productDetailMainMenuDelegate = productDetailMainMenuDelegate;
  }

  void addToCart() {
    if (_productDetailMainMenuDelegate != null) {
      SupportCart? supportCart = _productDetailMainMenuDelegate!.onGetSupportCart();
      if (supportCart != null) {
        if (supportCart is ProductEntry) {
          wishlistAndCartControllerContentDelegate.addToCart(supportCart, _productDetailMainMenuDelegate!.onCheckingLogin);
        }
      }
    }
  }

  void buyDirectly(String settlingId, String? couponId) async {
    if (_productDetailMainMenuDelegate != null) {
      SupportCart? supportCart = _productDetailMainMenuDelegate!.onGetSupportCart();
      if (supportCart != null) {
        if (supportCart is ProductEntry) {
          _productDetailMainMenuDelegate!.onUnfocusAllWidget();
          _productDetailMainMenuDelegate!.onShowBuyDirectlyRequestProcessLoadingCallback();
          PurchaseDirectParameter purchaseDirectParameter = PurchaseDirectParameter(
            productEntryId: supportCart.productEntryId,
            settlingId: settlingId,
            couponId: couponId,
            quantity: 1,
            notes: ""
          );
          LoadDataResult<PurchaseDirectResponse> purchaseDirectResponseLoadDataResult = await purchaseDirectUseCase.execute(purchaseDirectParameter).future(
            parameter: apiRequestManager.addRequestToCancellationPart("purchase-direct").value
          );
          _productDetailMainMenuDelegate!.onBack();
          if (purchaseDirectResponseLoadDataResult.isSuccess) {
            _productDetailMainMenuDelegate!.onBuyDirectlyRequestProcessSuccessCallback(purchaseDirectResponseLoadDataResult.resultIfSuccess!);
          } else {
            _productDetailMainMenuDelegate!.onShowBuyDirectlyRequestProcessFailedCallback(purchaseDirectResponseLoadDataResult.resultIfFailed);
          }
        }
      }
    }
  }

  void shareProduct(String? shareCode) async {
    if (_productDetailMainMenuDelegate != null) {
      _productDetailMainMenuDelegate!.onUnfocusAllWidget();
      _productDetailMainMenuDelegate!.onShowShareProductRequestProcessLoadingCallback();
      ShareProductParameter shareProductParameter = ShareProductParameter(shareCode: shareCode.toEmptyStringNonNull);
      LoadDataResult<ShareProductResponse> shareProductResponseLoadDataResult = await shareProductUseCase.execute(shareProductParameter).future(
        parameter: apiRequestManager.addRequestToCancellationPart("share-product").value
      );
      _productDetailMainMenuDelegate!.onBack();
      if (shareProductResponseLoadDataResult.isSuccess) {
        _productDetailMainMenuDelegate!.onShareProductRequestProcessSuccessCallback(shareProductResponseLoadDataResult.resultIfSuccess!);
      } else {
        _productDetailMainMenuDelegate!.onShowShareProductRequestProcessFailedCallback(shareProductResponseLoadDataResult.resultIfFailed);
      }
    }
  }
}

class ProductDetailMainMenuDelegate {
  OnObserveLoadProductDelegate onObserveLoadProductDelegate;
  OnUnfocusAllWidget onUnfocusAllWidget;
  _OnGetSupportCart onGetSupportCart;
  _OnGetSelectedPaymentMethodSettlingId onGetSelectedPaymentMethodSettlingId;
  _OnGetSelectedCouponId onGetSelectedCouponId;
  _OnShowAddToCartRequestProcessLoadingCallback onShowAddToCartRequestProcessLoadingCallback;
  _OnAddToCartRequestProcessSuccessCallback onAddToCartRequestProcessSuccessCallback;
  _OnShowAddToCartRequestProcessFailedCallback onShowAddToCartRequestProcessFailedCallback;
  _OnShowBuyDirectlyRequestProcessLoadingCallback onShowBuyDirectlyRequestProcessLoadingCallback;
  _OnBuyDirectlyRequestProcessSuccessCallback onBuyDirectlyRequestProcessSuccessCallback;
  _OnShowBuyDirectlyRequestProcessFailedCallback onShowBuyDirectlyRequestProcessFailedCallback;
  _OnShowShareProductRequestProcessLoadingCallback onShowShareProductRequestProcessLoadingCallback;
  _OnShareProductRequestProcessSuccessCallback onShareProductRequestProcessSuccessCallback;
  _OnShowShareProductRequestProcessFailedCallback onShowShareProductRequestProcessFailedCallback;
  ListItemControllerState Function(_OnObserveLoadShortProductDiscussionParameter) onObserveLoadShortProductDiscussionDirectly;
  void Function() onBack;
  Future<bool> Function() onCheckingLogin;

  ProductDetailMainMenuDelegate({
    required this.onObserveLoadProductDelegate,
    required this.onUnfocusAllWidget,
    required this.onGetSupportCart,
    required this.onGetSelectedPaymentMethodSettlingId,
    required this.onGetSelectedCouponId,
    required this.onShowAddToCartRequestProcessLoadingCallback,
    required this.onAddToCartRequestProcessSuccessCallback,
    required this.onShowAddToCartRequestProcessFailedCallback,
    required this.onShowBuyDirectlyRequestProcessLoadingCallback,
    required this.onBuyDirectlyRequestProcessSuccessCallback,
    required this.onShowBuyDirectlyRequestProcessFailedCallback,
    required this.onShowShareProductRequestProcessLoadingCallback,
    required this.onShareProductRequestProcessSuccessCallback,
    required this.onShowShareProductRequestProcessFailedCallback,
    required this.onObserveLoadShortProductDiscussionDirectly,
    required this.onBack,
    required this.onCheckingLogin
  });
}

class _OnObserveLoadShortProductDiscussionParameter {
  ProductDiscussion? successResultProductDiscussion;
  ListItemControllerState? Function() onGetDefaultListItemControllerState;
  RepeatableDynamicItemCarouselAdditionalParameter repeatableDynamicItemCarouselAdditionalParameter;

  _OnObserveLoadShortProductDiscussionParameter({
    required this.successResultProductDiscussion,
    required this.onGetDefaultListItemControllerState,
    required this.repeatableDynamicItemCarouselAdditionalParameter
  });
}