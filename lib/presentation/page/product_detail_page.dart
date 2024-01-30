import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../../controller/product_detail_controller.dart';
import '../../domain/entity/address/address.dart';
import '../../domain/entity/cart/support_cart.dart';
import '../../domain/entity/product/product.dart';
import '../../domain/entity/product/product_detail.dart';
import '../../domain/entity/product/product_detail_by_slug_parameter.dart';
import '../../domain/entity/product/product_detail_get_other_from_this_brand_parameter.dart';
import '../../domain/entity/product/product_detail_get_other_in_this_category_parameter.dart';
import '../../domain/entity/product/product_detail_parameter.dart';
import '../../domain/entity/product/productdiscussion/product_discussion.dart';
import '../../domain/entity/product/productentry/product_entry.dart';
import '../../domain/entity/product/productvariant/product_variant.dart';
import '../../domain/entity/search/store_search_last_seen_history_parameter.dart';
import '../../domain/entity/search/storesearchlastseenhistoryparametervalue/product_entry_store_search_last_seen_history_parameter_value.dart';
import '../../domain/entity/wishlist/support_wishlist.dart';
import '../../domain/usecase/add_to_cart_use_case.dart';
import '../../domain/usecase/get_product_category_list_use_case.dart';
import '../../domain/usecase/get_product_detail_by_slug_use_case.dart';
import '../../domain/usecase/get_product_detail_from_your_search_product_entry_list_use_case.dart';
import '../../domain/usecase/get_product_detail_other_chosen_for_you_product_entry_list_use_case.dart';
import '../../domain/usecase/get_product_detail_other_from_this_brand_product_entry_list_use_case.dart';
import '../../domain/usecase/get_product_detail_other_in_this_category_product_entry_list_use_case.dart';
import '../../domain/usecase/get_product_detail_other_interested_product_brand_list_use_case.dart';
import '../../domain/usecase/get_product_detail_use_case.dart';
import '../../domain/usecase/get_product_discussion_use_case.dart';
import '../../domain/usecase/purchase_direct_use_case.dart';
import '../../domain/usecase/share_product_use_case.dart';
import '../../domain/usecase/store_search_last_seen_history_use_case.dart';
import '../../misc/additionalloadingindicatorchecker/product_detail_additional_paging_result_parameter_checker.dart';
import '../../misc/carouselbackground/asset_carousel_background.dart';
import '../../misc/carouselbackground/carousel_background.dart';
import '../../misc/constant.dart';
import '../../misc/controllercontentdelegate/product_brand_favorite_controller_content_delegate.dart';
import '../../misc/controllercontentdelegate/wishlist_and_cart_controller_content_delegate.dart';
import '../../misc/controllerstate/listitemcontrollerstate/builder_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/colorful_chip_tab_bar_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/compound_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/load_data_result_dynamic_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/product_detail_brand_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/product_detail_image_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/product_detail_short_header_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/productdiscussionlistitemcontrollerstate/product_discussion_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/productdiscussionlistitemcontrollerstate/short_product_discussion_container_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/title_and_description_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import '../../misc/controllerstate/paging_controller_state.dart';
import '../../misc/dialog_helper.dart';
import '../../misc/entityandlistitemcontrollerstatemediator/horizontal_component_entity_parameterized_entity_and_list_item_controller_state_mediator.dart';
import '../../misc/error/message_error.dart';
import '../../misc/errorprovider/error_provider.dart';
import '../../misc/getextended/get_extended.dart';
import '../../misc/getextended/get_restorable_route_future.dart';
import '../../misc/injector.dart';
import '../../misc/load_data_result.dart';
import '../../misc/login_helper.dart';
import '../../misc/main_route_observer.dart';
import '../../misc/manager/controller_manager.dart';
import '../../misc/multi_language_string.dart';
import '../../misc/navigation_helper.dart';
import '../../misc/on_observe_load_product_delegate.dart';
import '../../misc/page_restoration_helper.dart';
import '../../misc/paging/modified_paging_controller.dart';
import '../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/paging/pagingresult/paging_result.dart';
import '../../misc/parameterizedcomponententityandlistitemcontrollerstatemediatorparameter/carousel_background_parameterized_entity_and_list_item_controller_state_mediator_parameter.dart';
import '../../misc/parameterizedcomponententityandlistitemcontrollerstatemediatorparameter/cart_delegate_parameterized_entity_and_list_item_controllere_state_mediator_parameter.dart';
import '../../misc/parameterizedcomponententityandlistitemcontrollerstatemediatorparameter/compound_parameterized_entity_and_list_item_controller_state_mediator.dart';
import '../../misc/parameterizedcomponententityandlistitemcontrollerstatemediatorparameter/horizontal_dynamic_item_carousel_parametered_component_entity_and_list_item_controller_state_mediator_parameter.dart';
import '../../misc/parameterizedcomponententityandlistitemcontrollerstatemediatorparameter/product_brand_parameterized_entity_and_list_item_controller_state_mediator_parameter.dart';
import '../../misc/parameterizedcomponententityandlistitemcontrollerstatemediatorparameter/wishlist_delegate_parameterized_entity_and_list_item_controller_state_mediator_parameter.dart';
import '../../misc/product_brand_item_type.dart';
import '../../misc/product_helper.dart';
import '../../misc/routeargument/product_detail_route_argument.dart';
import '../../misc/string_util.dart';
import '../../misc/toast_helper.dart';
import '../notifier/component_notifier.dart';
import '../notifier/notification_notifier.dart';
import '../notifier/product_notifier.dart';
import '../widget/button/custombutton/sized_outline_gradient_button.dart';
import '../widget/colorful_chip_tab_bar.dart';
import '../widget/modified_divider.dart';
import '../widget/modified_paged_list_view.dart';
import '../widget/modified_scaffold.dart';
import '../widget/modifiedappbar/default_search_app_bar.dart';
import '../widget/tap_area.dart';
import '../widget/titleanddescriptionitem/title_and_description_item.dart';
import 'address_page.dart';
import 'getx_page.dart';
import 'login_page.dart';
import 'modaldialogpage/select_address_modal_dialog_page.dart';
import 'product_brand_page.dart';
import 'product_chat_page.dart';
import 'product_discussion_page.dart';
import 'product_entry_page.dart';
import 'search_page.dart';

class ProductDetailPage extends RestorableGetxPage<_ProductDetailPageRestoration> {
  late final ControllerMember<ProductDetailController> _productDetailController = ControllerMember<ProductDetailController>().addToControllerManager(controllerManager);

  final SelectAddressModalDialogPageActionDelegate _selectAddressModalDialogPageActionDelegate = SelectAddressModalDialogPageActionDelegate();
  final _StatefulProductDetailControllerMediatorWidgetDelegate _statefulProductDetailControllerMediatorWidgetDelegate = _StatefulProductDetailControllerMediatorWidgetDelegate();
  final ProductDetailPageParameter productDetailPageParameter;

  ProductDetailPage({
    Key? key,
    required this.productDetailPageParameter
  }) : super(key: key, pageRestorationId: () => "product-detail-page");

  @override
  void onSetController() {
    _productDetailController.controller = GetExtended.put<ProductDetailController>(
      ProductDetailController(
        controllerManager,
        Injector.locator<GetProductDetailUseCase>(),
        Injector.locator<GetProductDetailBySlugUseCase>(),
        Injector.locator<GetProductDetailOtherChosenForYouProductEntryListUseCase>(),
        Injector.locator<GetProductDetailOtherFromThisBrandProductEntryListUseCase>(),
        Injector.locator<GetProductDetailOtherInThisCategoryProductEntryListUseCase>(),
        Injector.locator<GetProductDetailFromYourSearchProductEntryListUseCase>(),
        Injector.locator<GetProductDetailOtherInterestedProductBrandListUseCase>(),
        Injector.locator<PurchaseDirectUseCase>(),
        Injector.locator<AddToCartUseCase>(),
        Injector.locator<GetProductDiscussionUseCase>(),
        Injector.locator<StoreSearchLastSeenHistoryUseCase>(),
        Injector.locator<ShareProductUseCase>(),
        Injector.locator<WishlistAndCartControllerContentDelegate>(),
        Injector.locator<ProductBrandFavoriteControllerContentDelegate>()
      ),
      tag: pageName
    );
  }

  @override
  _ProductDetailPageRestoration createPageRestoration() => _ProductDetailPageRestoration(
    onCompleteAddressPage: (result) {
      if (result != null) {
        if (result) {
          int step = _statefulProductDetailControllerMediatorWidgetDelegate._selectAddressBecauseAddressIsEmptyWhileInBuyDirectlyProcessStep;
          if (step == 1) {
            _statefulProductDetailControllerMediatorWidgetDelegate._selectAddressBecauseAddressIsEmptyWhileInBuyDirectlyProcessStep = 2;
          }
          _selectAddressModalDialogPageActionDelegate.refresh();
        }
      }
    },
  );

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulProductDetailControllerMediatorWidget(
      productDetailPageParameter: productDetailPageParameter,
      productDetailController: _productDetailController.controller,
      pageName: pageName,
      selectAddressModalDialogPageActionDelegate: _selectAddressModalDialogPageActionDelegate,
      statefulProductDetailControllerMediatorWidgetDelegate: _statefulProductDetailControllerMediatorWidgetDelegate,
    );
  }
}

class _ProductDetailPageRestoration extends ExtendedMixableGetxPageRestoration with ProductDetailPageRestorationMixin, ProductEntryPageRestorationMixin, SearchPageRestorationMixin, ProductChatPageRestorationMixin, LoginPageRestorationMixin, ProductBrandPageRestorationMixin, ProductDiscussionPageRestorationMixin, AddressPageRestorationMixin {
  final RouteCompletionCallback<bool?>? _onCompleteAddressPage;

  _ProductDetailPageRestoration({
    RouteCompletionCallback<bool?>? onCompleteAddressPage
  }) : _onCompleteAddressPage = onCompleteAddressPage;

  @override
  // ignore: unnecessary_overrides
  void initState() {
    onCompleteSelectAddress = _onCompleteAddressPage;
    super.initState();
  }

  @override
  // ignore: unnecessary_overrides
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  // ignore: unnecessary_overrides
  void dispose() {
    super.dispose();
  }
}

class ProductDetailPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  final ProductDetailPageParameter productDetailPageParameter;

  ProductDetailPageGetPageBuilderAssistant({
    required this.productDetailPageParameter
  });

  @override
  GetPageBuilder get pageBuilder => (() => ProductDetailPage(
    productDetailPageParameter: productDetailPageParameter,
  ));

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(
    ProductDetailPage(
      productDetailPageParameter: productDetailPageParameter
    )
  ));
}

mixin ProductDetailPageRestorationMixin on MixableGetxPageRestoration {
  late ProductDetailPageRestorableRouteFuture productDetailPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    productDetailPageRestorableRouteFuture = ProductDetailPageRestorableRouteFuture(restorationId: restorationIdWithPageName('product-detail-route'));
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    productDetailPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    productDetailPageRestorableRouteFuture.dispose();
  }
}

class ProductDetailPageRestorableRouteFuture extends GetRestorableRouteFuture {
  late RestorableRouteFuture<void> _pageRoute;

  ProductDetailPageRestorableRouteFuture({required String restorationId}) : super(restorationId: restorationId) {
    _pageRoute = RestorableRouteFuture<void>(
      onPresent: (NavigatorState navigator, Object? arguments) {
        return navigator.restorablePush(_pageRouteBuilder, arguments: arguments);
      },
    );
  }

  static Route<void>? _getRoute([Object? arguments]) {
    if (arguments is! String) {
      throw MessageError(message: "Arguments must be a String");
    }
    ProductDetailPageParameter productDetailPageParameter = arguments.toProductDetailPageParameter();
    return GetExtended.toWithGetPageRouteReturnValue<void>(
      GetxPageBuilder.buildRestorableGetxPageBuilder(
        ProductDetailPageGetPageBuilderAssistant(
          productDetailPageParameter: productDetailPageParameter
        )
      ),
      arguments: ProductDetailRouteArgument()
    );
  }

  @pragma('vm:entry-point')
  static Route<void> _pageRouteBuilder(BuildContext context, Object? arguments) {
    return _getRoute(arguments)!;
  }

  @override
  bool checkBeforePresent([Object? arguments]) => _getRoute(arguments) != null;

  @override
  void presentIfCheckIsPassed([Object? arguments]) => _pageRoute.present(arguments);

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    restorator.registerForRestoration(_pageRoute, restorationId);
  }

  @override
  void dispose() {
    _pageRoute.dispose();
  }
}

class _StatefulProductDetailControllerMediatorWidget extends StatefulWidget {
  final ProductDetailController productDetailController;
  final SelectAddressModalDialogPageActionDelegate selectAddressModalDialogPageActionDelegate;
  final _StatefulProductDetailControllerMediatorWidgetDelegate statefulProductDetailControllerMediatorWidgetDelegate;
  final ProductDetailPageParameter productDetailPageParameter;
  final String pageName;

  const _StatefulProductDetailControllerMediatorWidget({
    required this.productDetailController,
    required this.selectAddressModalDialogPageActionDelegate,
    required this.statefulProductDetailControllerMediatorWidgetDelegate,
    required this.productDetailPageParameter,
    required this.pageName
  });

  @override
  State<_StatefulProductDetailControllerMediatorWidget> createState() => _StatefulProductDetailControllerMediatorWidgetState();
}

class _StatefulProductDetailControllerMediatorWidgetDelegate {
  int _selectAddressBecauseAddressIsEmptyWhileInBuyDirectlyProcessStep = 0;
}

class _StatefulProductDetailControllerMediatorWidgetState extends State<_StatefulProductDetailControllerMediatorWidget> {
  late final ScrollController _productDetailScrollController;
  late final ModifiedPagingController<int, ListItemControllerState> _productDetailListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _productDetailListItemPagingControllerState;
  final List<LoadDataResultDynamicListItemControllerState> _dynamicItemLoadDataResultDynamicListItemControllerStateList = [];
  late ColorfulChipTabBarController _productVariantColorfulChipTabBarController;
  LoadDataResult<ProductDetail> _productDetailLoadDataResult = NoLoadDataResult<ProductDetail>();
  Timer? _timer;
  bool _startTimer = false;
  String _productId = "";

  @override
  void initState() {
    super.initState();
    _productDetailScrollController = ScrollController();
    _productDetailListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.productDetailController.apiRequestManager,
      additionalPagingResultParameterChecker: Injector.locator<ProductDetailAdditionalPagingResultParameterChecker>()
    );
    _productDetailListItemPagingControllerState = PagingControllerState(
      pagingController: _productDetailListItemPagingController,
      scrollController: _productDetailScrollController,
      isPagingControllerExist: false
    );
    _productDetailListItemPagingControllerState.pagingController.addPageRequestListenerForLoadDataResult(
      listener: _productDetailListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _productDetailListItemPagingControllerState.isPagingControllerExist = true;
    _productVariantColorfulChipTabBarController = ColorfulChipTabBarController(0);
    _productVariantColorfulChipTabBarController.addListener(() => setState(() {}));
    MainRouteObserver.onScrollUpIfInProductDetail[getRouteMapKey(widget.pageName)] = () {
      _productDetailScrollController.jumpTo(0.0);
    };
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _productDetailListItemPagingControllerStateListener(int pageKey) async {
    HorizontalComponentEntityParameterizedEntityAndListItemControllerStateMediator componentEntityMediator = Injector.locator<HorizontalComponentEntityParameterizedEntityAndListItemControllerStateMediator>();
    HorizontalDynamicItemCarouselParameterizedEntityAndListItemControllerStateMediatorParameter carouselParameterizedEntityMediator = HorizontalDynamicItemCarouselParameterizedEntityAndListItemControllerStateMediatorParameter(
      onSetState: () => setState(() {}),
      dynamicItemLoadDataResultDynamicListItemControllerStateList: _dynamicItemLoadDataResultDynamicListItemControllerStateList
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _productDetailLoadDataResult = IsLoadingLoadDataResult<ProductDetail>();
      setState(() {});
    });
    LoadDataResult<ProductDetail> productDetailLoadDataResult = await () {
      ProductDetailPageParameter productDetailPageParameter = widget.productDetailPageParameter;
      if (productDetailPageParameter is DefaultProductDetailPageParameter) {
        return widget.productDetailController.getProductDetail(
          ProductDetailParameter(
            productId: productDetailPageParameter.productId
          )
        );
      } else if (productDetailPageParameter is SlugProductDetailPageParameter) {
        return widget.productDetailController.getProductDetailBySlug(
          ProductDetailBySlugParameter(
            slug: productDetailPageParameter.slug
          )
        );
      }
      throw MessageError(title: "ProductDetailPageParameter is not suitable");
    }();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _productDetailLoadDataResult = productDetailLoadDataResult;
      setState(() {});
    });
    return productDetailLoadDataResult.map((productDetail) {
      _productId = productDetail.productId;
      ListItemControllerState otherFromThisBrandListItemControllerState = componentEntityMediator.mapWithParameter(
        widget.productDetailController.getOtherFromThisBrand(
          ProductDetailGetOtherFromThisBrandParameter(
            brandSlug: productDetail.productBrand.slug
          )
        ),
        parameter: carouselParameterizedEntityMediator
      );
      ListItemControllerState shortProductDiscussionListItemControllerState = componentEntityMediator.mapWithParameter(
        widget.productDetailController.getShortProductDiscussion(),
        parameter: carouselParameterizedEntityMediator
      );
      ListItemControllerState otherChosenForYouListItemControllerState = componentEntityMediator.mapWithParameter(
        widget.productDetailController.getOtherChosenForYou(),
        parameter: carouselParameterizedEntityMediator
      );
      ListItemControllerState otherFromYourSearchListItemControllerState = componentEntityMediator.mapWithParameter(
        widget.productDetailController.getOtherFromYourSearch(),
        parameter: carouselParameterizedEntityMediator
      );
      ListItemControllerState otherInterestedProductBrandListItemControllerState = componentEntityMediator.mapWithParameter(
        widget.productDetailController.getOtherInterestedProductBrand(),
        parameter: carouselParameterizedEntityMediator
      );
      ListItemControllerState otherInThisCategoryListItemControllerState = componentEntityMediator.mapWithParameter(
        widget.productDetailController.getOtherInThisCategory(
          ProductDetailGetOtherInThisCategoryParameter(
            categorySlug: productDetail.productCategory.slug
          )
        ),
        parameter: carouselParameterizedEntityMediator
      );
      int a = 0;
      int selectedProductVariantIndex = -1;
      List<ProductEntry> productEntryList = productDetail.productEntry;
      if (widget.productDetailPageParameter is DefaultProductDetailPageParameter) {
        var defaultProductDetailPageParameter = widget.productDetailPageParameter as DefaultProductDetailPageParameter;
        for (ProductEntry productEntry in productEntryList) {
          List<ProductVariant> productVariantList = productEntry.productVariantList;
          if (productVariantList.isNotEmpty) {
            ProductVariant firstProductVariant = productVariantList.first;
            if (firstProductVariant.productEntryId == defaultProductDetailPageParameter.productEntryId) {
              if (selectedProductVariantIndex == -1) {
                selectedProductVariantIndex = a;
                break;
              }
            }
          } else {
            if (productEntry.id == defaultProductDetailPageParameter.productEntryId) {
              if (selectedProductVariantIndex == -1) {
                selectedProductVariantIndex = a;
                break;
              }
            }
          }
          a++;
        }
      }
      if (selectedProductVariantIndex == -1) {
        selectedProductVariantIndex = 0;
      }
      _productVariantColorfulChipTabBarController.value = selectedProductVariantIndex;
      if (!_startTimer) {
        _startTimer = true;
        _timer = Timer(
          const Duration(seconds: 5),
          () {
            int productEntryIndex = _productVariantColorfulChipTabBarController.value;
            ProductEntry? selectedProductEntry = ProductHelper.getSelectedProductEntry(
              productEntryList, productEntryIndex
            );
            if (selectedProductEntry != null) {
              widget.productDetailController.storeSearchLastSeenHistoryResponse(
                StoreSearchLastSeenHistoryParameter(
                  storeSearchLastSeenHistoryParameterValue: ProductEntryStoreSearchLastSeenHistoryParameterValue(
                    productEntryId: selectedProductEntry.productEntryId
                  )
                )
              );
            }
          }
        );
      }
      return PagingDataResult<ListItemControllerState>(
        page: 1,
        totalPage: 1,
        totalItem: 1,
        itemList: [
          BuilderListItemControllerState(
            buildListItemControllerState: () => CompoundListItemControllerState(
              listItemControllerState: [
                ProductDetailImageListItemControllerState(
                  productEntryList: productDetail.productEntry,
                  onGetProductEntryIndex: () {
                    return _productVariantColorfulChipTabBarController.value;
                  }
                ),
                ProductDetailShortHeaderListItemControllerState(
                  productDetail: productDetail,
                  onGetProductEntryIndex: () {
                    return _productVariantColorfulChipTabBarController.value;
                  },
                  onShareProduct: widget.productDetailController.shareProduct,
                  onAddWishlist: (productAppearanceData) => widget.productDetailController.wishlistAndCartControllerContentDelegate.addToWishlist(
                    productAppearanceData as SupportWishlist, () {
                      Completer<bool> checkingLoginCompleter = Completer<bool>();
                      LoginHelper.checkingLogin(
                        context,
                        () => checkingLoginCompleter.complete(true),
                        resultIfHasNotBeenLogin: () => checkingLoginCompleter.complete(false),
                        showLoginPageWhenHasCallbackIfHasNotBeenLogin: true
                      );
                      return checkingLoginCompleter.future;
                    }
                  ),
                  onRemoveWishlist: (productAppearanceData) => widget.productDetailController.wishlistAndCartControllerContentDelegate.removeFromWishlist(
                    productAppearanceData as SupportWishlist, () {
                      Completer<bool> checkingLoginCompleter = Completer<bool>();
                      LoginHelper.checkingLogin(
                        context,
                        () => checkingLoginCompleter.complete(true),
                        resultIfHasNotBeenLogin: () => checkingLoginCompleter.complete(false),
                        showLoginPageWhenHasCallbackIfHasNotBeenLogin: true
                      );
                      return checkingLoginCompleter.future;
                    }
                  ),
                ),
                VirtualSpacingListItemControllerState(height: 2.h),
                PaddingContainerListItemControllerState(
                  padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
                  paddingChildListItemControllerState: TitleAndDescriptionListItemControllerState(
                    title: productDetail.name,
                    verticalSpace: 5,
                    titleAndDescriptionItemInterceptor: (padding, title, titleWidget, description, descriptionWidget, titleAndDescriptionWidget, titleAndDescriptionWidgetList) {
                      if (titleWidget != null) {
                        if (titleWidget is Text) {
                          titleAndDescriptionWidgetList.first = Text(title.toStringNonNull, style: titleWidget.style?.copyWith(fontWeight: FontWeight.normal));
                        }
                      }
                      return titleAndDescriptionWidget;
                    }
                  ),
                ),
                if (productEntryList.isNotEmpty)
                  CompoundListItemControllerState(
                    listItemControllerState: [
                      BuilderListItemControllerState(
                        buildListItemControllerState: () {
                          List<ColorfulChipTabBarData> colorfulChipTabBarDataList = [];
                          List<ProductEntry> productEntryList = productDetail.productEntry;
                          for (ProductEntry productEntry in productEntryList) {
                            List<ProductVariant> productVariantList = productEntry.productVariantList;
                            if (productVariantList.isNotEmpty) {
                              ProductVariant firstProductVariant = productVariantList.first;
                              String productVariantDescription = "";
                              int j = 0;
                              for (ProductVariant productVariant in productVariantList) {
                                productVariantDescription += "${(j > 0 ? ", " : "")}${productVariant.type} (${productVariant.name})";
                                j++;
                              }
                              colorfulChipTabBarDataList.add(
                                ColorfulChipTabBarData(
                                  title: productVariantDescription,
                                  color: Theme.of(context).colorScheme.primary,
                                  data: firstProductVariant.productEntryId
                                )
                              );
                            } else {
                              colorfulChipTabBarDataList.add(
                                ColorfulChipTabBarData(
                                  title: productEntry.sustension,
                                  color: Theme.of(context).colorScheme.primary,
                                  data: productEntry.productEntryId
                                )
                              );
                            }
                          }
                          return CompoundListItemControllerState(
                            listItemControllerState: [
                              if (colorfulChipTabBarDataList.isNotEmpty)
                                ...[
                                  VirtualSpacingListItemControllerState(height: 2.5.h),
                                  PaddingContainerListItemControllerState(
                                    padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
                                    paddingChildListItemControllerState: TitleAndDescriptionListItemControllerState(
                                      title: "Select Variant".tr,
                                      description: null,
                                      verticalSpace: 25,
                                      titleAndDescriptionItemInterceptor: (padding, title, titleWidget, description, descriptionWidget, titleAndDescriptionWidget, titleAndDescriptionWidgetList) {
                                        titleAndDescriptionWidgetList.first = Text(title.toStringNonNull, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold));
                                        return titleAndDescriptionWidget;
                                      }
                                    )
                                  ),
                                  VirtualSpacingListItemControllerState(height: 10.0),
                                  ColorfulChipTabBarListItemControllerState(
                                    colorfulChipTabBarController: _productVariantColorfulChipTabBarController,
                                    colorfulChipTabBarDataList: colorfulChipTabBarDataList,
                                  ),
                                ]
                            ],
                          );
                        }
                      ),
                    ]
                  ),
                VirtualSpacingListItemControllerState(height: 3.h),
                PaddingContainerListItemControllerState(
                  padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
                  paddingChildListItemControllerState: TitleAndDescriptionListItemControllerState(
                    title: "Product Detail".tr,
                    description: productDetail.description,
                    verticalSpace: 7.0,
                    titleAndDescriptionItemInterceptor: (padding, title, titleWidget, description, descriptionWidget, titleAndDescriptionWidget, titleAndDescriptionWidgetList) {
                      ProductEntry? _selectedProductEntry = ProductHelper.getSelectedProductEntry(
                        productDetail.productEntry, _productVariantColorfulChipTabBarController.value
                      );
                      bool hasSelectedProductEntry = _selectedProductEntry != null;
                      List<Map<String, dynamic>> productDetailContentMap = [
                        if (productDetail.productCertificationList.isNotEmpty) {
                          "title": "Certification".tr,
                          "description": productDetail.productCertificationList.first.name,
                        },
                        {
                          "title": "Category".tr,
                          "description": productDetail.productCategory.name,
                          "on_tap": () => PageRestorationHelper.toProductEntryPage(
                            context,
                            ProductEntryPageParameter(
                              productEntryParameterMap: {
                                "category": productDetail.productCategory.slug
                              }
                            )
                          )
                        },
                        {
                          "title": "Province".tr,
                          "description": (productDetail.province?.name).toStringNonNull,
                          "on_tap": () => PageRestorationHelper.toProductEntryPage(
                            context,
                            ProductEntryPageParameter(
                              productEntryParameterMap: {
                                "province": (productDetail.province?.name).toEmptyStringNonNull,
                                "province_id": (productDetail.province?.id).toEmptyStringNonNull
                              }
                            )
                          )
                        },
                        {
                          "title": "Brand".tr,
                          "description": productDetail.productBrand.name,
                          "on_tap": () => PageRestorationHelper.toProductEntryPage(
                            context,
                            ProductEntryPageParameter(
                              productEntryParameterMap: {
                                "brand_id": productDetail.productBrand.id,
                                "brand": productDetail.productBrand.slug
                              }
                            )
                          )
                        },
                        if (hasSelectedProductEntry) ...[
                          {"title": "SKU".tr, "description": _selectedProductEntry.sku},
                          {"title": "Sustension".tr, "description": _selectedProductEntry.sustension}
                        ]
                      ];
                      titleAndDescriptionWidgetList.first = Text(title.toStringNonNull, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold));
                      titleAndDescriptionWidgetList.last = Column(
                        children: productDetailContentMap.mapIndexed(
                          (index, productDetailContentListValue) {
                            List<Widget> columnResult = [
                              TapArea(
                                onTap: productDetailContentListValue["on_tap"],
                                child: Column(
                                  children: [
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(productDetailContentListValue["title"]),
                                        ),
                                        Expanded(
                                          child: Text(productDetailContentListValue["description"]),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                  ]
                                ),
                              ),
                              const ModifiedDivider(),
                            ];
                            return Column(
                              children: columnResult,
                            );
                          }
                        ).toList(),
                      );
                      return titleAndDescriptionWidget;
                    }
                  ),
                ),
                VirtualSpacingListItemControllerState(height: 3.h),
                PaddingContainerListItemControllerState(
                  padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
                  paddingChildListItemControllerState: TitleAndDescriptionListItemControllerState(
                    title: "Product Description".tr,
                    description: productDetail.description,
                    verticalSpace: 12,
                    titleAndDescriptionItemInterceptor: (padding, title, titleWidget, description, descriptionWidget, titleAndDescriptionWidget, titleAndDescriptionWidgetList) {
                      titleAndDescriptionWidgetList.first = Text(title.toStringNonNull, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold));
                      return titleAndDescriptionWidget;
                    }
                  ),
                ),
                VirtualSpacingListItemControllerState(height: 3.h),
                otherInThisCategoryListItemControllerState,
                VirtualSpacingListItemControllerState(height: 4.h),
                ProductDetailBrandListItemControllerState(
                  productBrand: productDetail.productBrand,
                  onTapProductBrand: (productBrand) => PageRestorationHelper.toProductEntryPage(
                    context,
                    ProductEntryPageParameter(
                      productEntryParameterMap: {
                        "brand_id": productBrand.id,
                        "brand": productBrand.slug
                      }
                    )
                  ),
                  onAddToFavoriteProductBrand: (productBrand) {
                    widget.productDetailController.productBrandFavoriteControllerContentDelegate.addToFavoriteProductBrand(
                      productBrand, () {
                        Completer<bool> checkingLoginCompleter = Completer<bool>();
                        LoginHelper.checkingLogin(
                          context,
                          () => checkingLoginCompleter.complete(true),
                          resultIfHasNotBeenLogin: () => checkingLoginCompleter.complete(false),
                          showLoginPageWhenHasCallbackIfHasNotBeenLogin: true
                        );
                        return checkingLoginCompleter.future;
                      }
                    );
                  },
                  onRemoveFromFavoriteProductBrand: (favoriteProductBrand) {
                    widget.productDetailController.productBrandFavoriteControllerContentDelegate.removeFromFavoriteProductBrandBasedProductBrand(
                      favoriteProductBrand, () {
                        Completer<bool> checkingLoginCompleter = Completer<bool>();
                        LoginHelper.checkingLogin(
                          context,
                          () => checkingLoginCompleter.complete(true),
                          resultIfHasNotBeenLogin: () => checkingLoginCompleter.complete(false),
                          showLoginPageWhenHasCallbackIfHasNotBeenLogin: true
                        );
                        return checkingLoginCompleter.future;
                      }
                    );
                  },
                ),
                VirtualSpacingListItemControllerState(height: 4.h),
                otherFromThisBrandListItemControllerState,
                VirtualSpacingListItemControllerState(height: 4.h),
                shortProductDiscussionListItemControllerState,
                VirtualSpacingListItemControllerState(height: 4.h),
                otherChosenForYouListItemControllerState,
                VirtualSpacingListItemControllerState(height: 4.h),
                otherFromYourSearchListItemControllerState,
                VirtualSpacingListItemControllerState(height: 4.h),
                otherInterestedProductBrandListItemControllerState,
                VirtualSpacingListItemControllerState(height: 4.h),
              ]
            )
          )
        ]
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    OnObserveLoadProductDelegateFactory onObserveLoadProductDelegateFactory = Injector.locator<OnObserveLoadProductDelegateFactory>()
      ..onInjectLoadProductEntryCarouselParameterizedEntity = (
        () => CompoundParameterizedEntityAndListItemControllerStateMediatorParameter(
          parameterizedEntityAndListItemControllerStateMediatorParameterList: [
            WishlistDelegateParameterizedEntityAndListItemControllerStateMediatorParameter(
              onAddToWishlist: (data) async => widget.productDetailController.wishlistAndCartControllerContentDelegate.addToWishlist(
                data, () {
                  Completer<bool> checkingLoginCompleter = Completer<bool>();
                  LoginHelper.checkingLogin(
                    context,
                    () => checkingLoginCompleter.complete(true),
                    resultIfHasNotBeenLogin: () => checkingLoginCompleter.complete(false),
                    showLoginPageWhenHasCallbackIfHasNotBeenLogin: true
                  );
                  return checkingLoginCompleter.future;
                }
              ),
              onRemoveFromWishlist: (data) async => widget.productDetailController.wishlistAndCartControllerContentDelegate.removeFromWishlist(
                data, () {
                  Completer<bool> checkingLoginCompleter = Completer<bool>();
                  LoginHelper.checkingLogin(
                    context,
                    () => checkingLoginCompleter.complete(true),
                    resultIfHasNotBeenLogin: () => checkingLoginCompleter.complete(false),
                    showLoginPageWhenHasCallbackIfHasNotBeenLogin: true
                  );
                  return checkingLoginCompleter.future;
                }
              ),
            ),
            CartDelegateParameterizedEntityAndListItemControllerStateMediatorParameter(
              onAddCart: (data) async => widget.productDetailController.wishlistAndCartControllerContentDelegate.addToCart(
                data, () {
                  Completer<bool> checkingLoginCompleter = Completer<bool>();
                  LoginHelper.checkingLogin(
                    context, () => checkingLoginCompleter.complete(true),
                    resultIfHasNotBeenLogin: () => checkingLoginCompleter.complete(false),
                    showLoginPageWhenHasCallbackIfHasNotBeenLogin: true
                  );
                  return checkingLoginCompleter.future;
                }
              ),
            )
          ]
        )
      )
      ..onInjectLoadProductBundleCarouselParameterizedEntity = (
        () => CompoundParameterizedEntityAndListItemControllerStateMediatorParameter(
          parameterizedEntityAndListItemControllerStateMediatorParameterList: [
            WishlistDelegateParameterizedEntityAndListItemControllerStateMediatorParameter(
              onAddToWishlist: (data) async => widget.productDetailController.wishlistAndCartControllerContentDelegate.addToWishlist(
                data, () {
                  Completer<bool> checkingLoginCompleter = Completer<bool>();
                  LoginHelper.checkingLogin(
                    context,
                    () => checkingLoginCompleter.complete(true),
                    resultIfHasNotBeenLogin: () => checkingLoginCompleter.complete(false),
                    showLoginPageWhenHasCallbackIfHasNotBeenLogin: true
                  );
                  return checkingLoginCompleter.future;
                }
              ),
              onRemoveFromWishlist: (data) async => widget.productDetailController.wishlistAndCartControllerContentDelegate.removeFromWishlist(
                data, () {
                  Completer<bool> checkingLoginCompleter = Completer<bool>();
                  LoginHelper.checkingLogin(
                    context,
                    () => checkingLoginCompleter.complete(true),
                    resultIfHasNotBeenLogin: () => checkingLoginCompleter.complete(false),
                    showLoginPageWhenHasCallbackIfHasNotBeenLogin: true
                  );
                  return checkingLoginCompleter.future;
                }
              ),
            ),
            CartDelegateParameterizedEntityAndListItemControllerStateMediatorParameter(
              onAddCart: (data) async => widget.productDetailController.wishlistAndCartControllerContentDelegate.addToCart(
                data, () {
                  Completer<bool> checkingLoginCompleter = Completer<bool>();
                  LoginHelper.checkingLogin(
                    context,
                    () => checkingLoginCompleter.complete(true),
                    resultIfHasNotBeenLogin: () => checkingLoginCompleter.complete(false),
                    showLoginPageWhenHasCallbackIfHasNotBeenLogin: true
                  );
                  return checkingLoginCompleter.future;
                }
              ),
            )
          ]
        )
      )
      ..onInjectLoadProductBrandCarouselParameterizedEntity = (
        () => ProductBrandParameterizedEntityAndListItemControllerStateMediatorParameter(
          productBrandItemType: ProductBrandItemType.imageAndBackground
        )
      )
      ..onInjectCarouselParameterizedEntity = (
        (data) {
          Widget moreTapArea({
            void Function()? onTap,
            TextStyle Function(TextStyle)? onInterceptTextStyle
          }) {
            TextStyle textStyle = TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 12
            );
            return TapArea(
              onTap: onTap,
              child: Text(
                "More".tr,
                style: onInterceptTextStyle != null ? onInterceptTextStyle(textStyle) : textStyle
              ),
            );
          }
          Widget titleArea({
            required Widget title,
            void Function()? onTapMore,
            TextStyle Function(TextStyle)? onInterceptTextStyle
          }) {
            return Row(
              children: [
                Expanded(child: title),
                const SizedBox(width: 10),
                moreTapArea(
                  onTap: onTapMore,
                  onInterceptTextStyle: onInterceptTextStyle
                )
              ],
            );
          }
          CarouselBackground? carouselBackground;
          TitleInterceptor? titleInterceptor;
          if (data == Constant.carouselKeyProductDetailOtherFromThisBrand) {
            titleInterceptor = (text, style) => titleArea(
              title: Text(text.toStringNonNull, style: style),
              onTapMore: () {
                if (_productDetailLoadDataResult.isSuccess) {
                  ProductDetail productDetail = _productDetailLoadDataResult.resultIfSuccess!;
                  PageRestorationHelper.toProductEntryPage(
                    context,
                    ProductEntryPageParameter(
                      productEntryParameterMap: {
                        "brand_id": productDetail.productBrand.id,
                        "brand": productDetail.productBrand.slug
                      }
                    )
                  );
                }
              },
            );
          } else if (data == Constant.carouselKeyProductDetailOtherChosenForYou) {
            titleInterceptor = (text, style) => titleArea(
              title: Text(text.toStringNonNull, style: style),
              onTapMore: () => PageRestorationHelper.toProductEntryPage(
                context,
                ProductEntryPageParameter(
                  productEntryParameterMap: {
                    "fyp": true,
                    "name": Constant.multiLanguageStringOtherChosenForYou.value
                  }
                )
              ),
            );
          } else if (data == Constant.carouselKeyProductDetailOtherInThisCategory) {
            titleInterceptor = (text, style) => titleArea(
              title: Text(text.toStringNonNull, style: style),
              onTapMore: () {
                if (_productDetailLoadDataResult.isSuccess) {
                  ProductDetail productDetail = _productDetailLoadDataResult.resultIfSuccess!;
                  PageRestorationHelper.toProductEntryPage(
                    context,
                    ProductEntryPageParameter(
                      productEntryParameterMap: {
                        "category": productDetail.productCategory.slug,
                        "name": Constant.multiLanguageStringOtherInThisCategory.value
                      }
                    )
                  );
                }
              },
            );
          } else if (data == Constant.carouselKeyProductDetailFromYourSearch) {
            titleInterceptor = (text, style) => titleArea(
              title: Text(text.toStringNonNull, style: style),
              onTapMore: () => PageRestorationHelper.toProductEntryPage(
                context,
                ProductEntryPageParameter(
                  productEntryParameterMap: {
                    "fyp": true,
                    "name": Constant.multiLanguageStringFromYourSearch.value
                  }
                )
              ),
            );
          } else if (data == Constant.carouselKeyProductDetailOtherInterestedBrand) {
            titleInterceptor = (text, style) => titleArea(
              title: Text(text.toStringNonNull, style: style),
              onTapMore: () => PageRestorationHelper.toProductBrandPage(
                context, ProductBrandPageParameter(
                  productBrandPageType: ProductBrandPageType.defaultProductDetail
                )
              )
            );
          }
          return CarouselParameterizedEntityAndListItemControllerStateMediatorParameter(
            carouselBackground: carouselBackground,
            titleInterceptor: titleInterceptor
          );
        }
      );
    widget.productDetailController.setProductDetailMainMenuDelegate(
      ProductDetailMainMenuDelegate(
        onUnfocusAllWidget: () => FocusScope.of(context).unfocus(),
        onObserveLoadProductDelegate: onObserveLoadProductDelegateFactory.generateOnObserveLoadProductDelegate(),
        onGetSupportCart: () {
          if (_productDetailLoadDataResult.isSuccess) {
            ProductDetail productDetail = _productDetailLoadDataResult.resultIfSuccess!;
            int productEntryIndex = _productVariantColorfulChipTabBarController.value;
            ProductEntry? productEntry = ProductHelper.getSelectedProductEntry(
              productDetail.productEntry, productEntryIndex
            );
            return productEntry;
          }
          return null;
        },
        onObserveLoadShortProductDiscussionDirectly: (onObserveLoadShortProductDiscussionParameter) {
          ProductDiscussion productDiscussion = onObserveLoadShortProductDiscussionParameter.productDiscussionSuccessLoadDataResult.resultIfSuccess!;
          return ShortProductDiscussionContainerListItemControllerState(
            productDiscussionListItemValue: ProductDiscussionListItemValue(
              isExpanded: true,
              productDiscussionDetailListItemValue: productDiscussion.toProductDiscussionDetailListItemValue()
            ),
            onGetErrorProvider: () => Injector.locator<ErrorProvider>(),
            onUpdateState: () => setState(() {}),
            onTapMore: (productDiscussion) {
              PageRestorationHelper.toProductDiscussionPage(
                context, ProductDiscussionPageParameter(
                  productId: _productId,
                  bundleId: null,
                  discussionProductId: null
                )
              );
            },
            onGotoReplyProductDiscussionPage: (productDiscussionDialog) {
              PageRestorationHelper.toProductDiscussionPage(
                context, ProductDiscussionPageParameter(
                  productId: _productId,
                  bundleId: null,
                  discussionProductId: productDiscussionDialog.id
                )
              );
            }
          );
        },
        onShowAddToCartRequestProcessLoadingCallback: () async => DialogHelper.showLoadingDialog(context),
        onShowAddToCartRequestProcessFailedCallback: (e) async => DialogHelper.showFailedModalBottomDialogFromErrorProvider(
          context: context,
          errorProvider: Injector.locator<ErrorProvider>(),
          e: e
        ),
        onAddToCartRequestProcessSuccessCallback: () async {
          ToastHelper.showToast("${"Success add to cart".tr}.");
        },
        onShowBuyDirectlyRequestProcessLoadingCallback: () async => DialogHelper.showLoadingDialog(context),
        onShowBuyDirectlyRequestProcessFailedCallback: (e) async {
          if (e is DioError) {
            dynamic message = e.response?.data["meta"]["message"];
            if (message is String) {
              if (message.toLowerCase().contains("you need to add your address")) {
                ToastHelper.showToast(
                  MultiLanguageString({
                    Constant.textEnUsLanguageKey: "Address is empty. Please add new address first.",
                    Constant.textInIdLanguageKey: "Alamatnya kosong. Silahkan mengisi alamat baru terlebih dahulu."
                  }).toEmptyStringNonNull
                );
                DialogHelper.showModalBottomDialogPage<bool, String>(
                  context: context,
                  modalDialogPageBuilder: (context, parameter) => SelectAddressModalDialogPage(
                    onGotoAddAddress: () {
                      widget.statefulProductDetailControllerMediatorWidgetDelegate._selectAddressBecauseAddressIsEmptyWhileInBuyDirectlyProcessStep = 1;
                      PageRestorationHelper.toAddressPage(context);
                    },
                    selectAddressModalDialogPageActionDelegate: widget.selectAddressModalDialogPageActionDelegate,
                    onFinishLoadingAddress: (addressListLoadDataResult) async {
                      if (widget.statefulProductDetailControllerMediatorWidgetDelegate._selectAddressBecauseAddressIsEmptyWhileInBuyDirectlyProcessStep == 2) {
                        if (addressListLoadDataResult.isSuccess) {
                          List<Address> addressList = addressListLoadDataResult.resultIfSuccess!;
                          if (addressList.isNotEmpty) {
                            ToastHelper.showToast(
                              MultiLanguageString({
                                Constant.textEnUsLanguageKey: "Success add address. Please wait for buy directly process.",
                                Constant.textInIdLanguageKey: "Sukses menambahkan alamat. Silahkan menunggu untuk proses beli langsung."
                              }).toEmptyStringNonNull
                            );
                            widget.productDetailController.buyDirectly();
                          }
                        }
                      }
                    },
                  )
                );
                return;
              }
            }
          }
          DialogHelper.showFailedModalBottomDialogFromErrorProvider(
            context: context,
            errorProvider: Injector.locator<ErrorProvider>(),
            e: e
          );
        },
        onBuyDirectlyRequestProcessSuccessCallback: (order) async {
          NavigationHelper.navigationAfterPurchaseProcess(context, order);
        },
        onShowShareProductRequestProcessLoadingCallback: () async => DialogHelper.showLoadingDialog(context),
        onShowShareProductRequestProcessFailedCallback: (e) async => DialogHelper.showFailedModalBottomDialogFromErrorProvider(
          context: context,
          errorProvider: Injector.locator<ErrorProvider>(),
          e: e
        ),
        onShareProductRequestProcessSuccessCallback: (shareProductResponse) async => Share.share(shareProductResponse.link),
        onBack: () => Get.back(),
        onCheckingLogin: () {
          Completer<bool> checkingLoginCompleter = Completer<bool>();
          LoginHelper.checkingLogin(
            context,
            () => checkingLoginCompleter.complete(true),
            resultIfHasNotBeenLogin: () => checkingLoginCompleter.complete(false),
            showLoginPageWhenHasCallbackIfHasNotBeenLogin: true
          );
          return checkingLoginCompleter.future;
        }
      )
    );
    widget.productDetailController.wishlistAndCartControllerContentDelegate.setWishlistAndCartDelegate(
      Injector.locator<WishlistAndCartDelegateFactory>().generateWishlistAndCartDelegate(
        onGetBuildContext: () => context,
        onGetErrorProvider: () => Injector.locator<ErrorProvider>(),
        onAddToWishlistRequestProcessSuccessCallback: () async => context.read<ComponentNotifier>().updateWishlist(),
        onRemoveFromWishlistRequestProcessSuccessCallback: (wishlist) async => context.read<ComponentNotifier>().updateWishlist(),
        onAddCartRequestProcessSuccessCallback: () async {
          context.read<ComponentNotifier>().updateCart();
          context.read<NotificationNotifier>().loadCartLoadDataResult();
          context.read<ProductNotifier>().loadCartList();
          ToastHelper.showToast("${"Success add to cart".tr}.");
        },
      )
    );
    widget.productDetailController.productBrandFavoriteControllerContentDelegate.setProductBrandFavoriteDelegate(
      Injector.locator<ProductBrandFavoriteDelegateFactory>().generateProductBrandFavoriteDelegate(
        onGetBuildContext: () => context,
        onGetErrorProvider: () => Injector.locator<ErrorProvider>(),
        onAddToFavoriteProductBrandRequestProcessSuccessCallback: () async {
          context.read<ComponentNotifier>().updateFavorite();
        },
        onRemoveFromFavoriteProductBrandRequestProcessSuccessCallback: (favoriteProductBrand) async {
          context.read<ComponentNotifier>().updateFavorite();
        }
      ),
    );
    return ModifiedScaffold(
      appBar: DefaultSearchAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
                pagingControllerState: _productDetailListItemPagingControllerState,
                onProvidePagedChildBuilderDelegate: (pagingControllerState) => ListItemPagingControllerStatePagedChildBuilderDelegate<int>(
                  pagingControllerState: pagingControllerState!
                ),
                pullToRefresh: true
              ),
            ),
            if (_productDetailLoadDataResult.isSuccess)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 50,
                      child: SizedOutlineGradientButton(
                        text: '',
                        width: double.infinity,
                        height: 36,
                        outlineGradientButtonType: OutlineGradientButtonType.outline,
                        onPressed: () => PageRestorationHelper.toProductChatPage(_productId, context),
                        child: const Icon(Icons.chat, size: 16)
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedOutlineGradientButton(
                        width: double.infinity,
                        height: 36,
                        outlineGradientButtonType: OutlineGradientButtonType.outline,
                        onPressed: () => LoginHelper.checkingLogin(context, () {
                          widget.productDetailController.buyDirectly();
                        }),
                        text: "Buy Directly".tr,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedOutlineGradientButton(
                        width: double.infinity,
                        height: 36,
                        outlineGradientButtonType: OutlineGradientButtonType.solid,
                        onPressed: () {
                          LoginHelper.checkingLogin(context, () {
                            widget.productDetailController.addToCart();
                          });
                        },
                        text: "+ ${"Cart".tr}",
                      ),
                    ),
                  ],
                )
              )
          ]
        )
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    MainRouteObserver.onScrollUpIfInProductDetail[getRouteMapKey(widget.pageName)] = null;
    _productDetailScrollController.dispose();
    _productDetailListItemPagingController.dispose();
    super.dispose();
  }
}

abstract class ProductDetailPageParameter {}

class DefaultProductDetailPageParameter extends ProductDetailPageParameter {
  String productId;
  String productEntryId;

  DefaultProductDetailPageParameter({
    required this.productId,
    required this.productEntryId
  });
}

class SlugProductDetailPageParameter extends ProductDetailPageParameter {
  String slug;

  SlugProductDetailPageParameter({
    required this.slug
  });
}

extension ProductDetailPageParameterExt on ProductDetailPageParameter {
  String toEncodeBase64String() => StringUtil.encodeBase64StringFromJson(
    () {
      if (this is SlugProductDetailPageParameter) {
        SlugProductDetailPageParameter slugProductDetailPageParameter = this as SlugProductDetailPageParameter;
        return <String, dynamic>{
          "product_slug": slugProductDetailPageParameter.slug
        };
      } else {
        DefaultProductDetailPageParameter defaultProductDetailPageParameter = this as DefaultProductDetailPageParameter;
        return <String, dynamic>{
          "product_id": defaultProductDetailPageParameter.productId,
          "product_entry_id": defaultProductDetailPageParameter.productEntryId,
        };
      }
    }()
  );
}

extension ProductDetailPageParameterStringExt on String {
  ProductDetailPageParameter toProductDetailPageParameter() {
    Map<String, dynamic> result = StringUtil.decodeBase64StringToJson(this);
    if (result.containsKey("product_slug")) {
      return SlugProductDetailPageParameter(
        slug: result["product_slug"]
      );
    } else {
      return DefaultProductDetailPageParameter(
        productId: result["product_id"],
        productEntryId: result["product_entry_id"],
      );
    }
  }
}