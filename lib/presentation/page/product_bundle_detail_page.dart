import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';
import 'package:provider/provider.dart';

import '../../controller/product_bundle_detail_controller.dart';
import '../../domain/entity/product/productbundle/product_bundle_detail.dart';
import '../../domain/entity/product/productbundle/product_bundle_detail_by_slug_parameter.dart';
import '../../domain/entity/product/productbundle/product_bundle_detail_parameter.dart';
import '../../domain/usecase/get_product_bundle_detail_by_slug_use_case.dart';
import '../../domain/usecase/get_product_bundle_detail_use_case.dart';
import '../../misc/additionalloadingindicatorchecker/product_bundle_detail_additional_paging_result_parameter_checker.dart';
import '../../misc/constant.dart';
import '../../misc/controllercontentdelegate/wishlist_and_cart_controller_content_delegate.dart';
import '../../misc/controllerstate/listitemcontrollerstate/builder_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/compound_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/product_bundle_header_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/productlistitemcontrollerstate/vertical_product_list_item_controller_state.dart';
import '../../misc/controllerstate/paging_controller_state.dart';
import '../../misc/error/message_error.dart';
import '../../misc/error_helper.dart';
import '../../misc/errorprovider/error_provider.dart';
import '../../misc/getextended/get_extended.dart';
import '../../misc/getextended/get_restorable_route_future.dart';
import '../../misc/injector.dart';
import '../../misc/load_data_result.dart';
import '../../misc/login_helper.dart';
import '../../misc/manager/controller_manager.dart';
import '../../misc/multi_language_string.dart';
import '../../misc/paging/modified_paging_controller.dart';
import '../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/paging/pagingresult/paging_result.dart';
import '../../misc/string_util.dart';
import '../notifier/component_notifier.dart';
import '../notifier/notification_notifier.dart';
import '../notifier/product_notifier.dart';
import '../widget/modified_paged_list_view.dart';
import '../widget/modified_scaffold.dart';
import '../widget/modifiedappbar/default_search_app_bar.dart';
import 'getx_page.dart';
import 'product_detail_page.dart';
import 'search_page.dart';

class ProductBundleDetailPage extends RestorableGetxPage<_ProductBundleDetailPageRestoration> {
  late final ControllerMember<ProductBundleDetailController> _productBundleDetailController = ControllerMember<ProductBundleDetailController>().addToControllerManager(controllerManager);

  final ProductBundleDetailPageParameter productBundleDetailPageParameter;

  ProductBundleDetailPage({
    Key? key,
    required this.productBundleDetailPageParameter
  }) : super(key: key, pageRestorationId: () => "product-bundle-detail-page");

  @override
  void onSetController() {
    _productBundleDetailController.controller = GetExtended.put<ProductBundleDetailController>(
      ProductBundleDetailController(
        controllerManager,
        Injector.locator<GetProductBundleDetailUseCase>(),
        Injector.locator<GetProductBundleDetailBySlugUseCase>(),
        Injector.locator<WishlistAndCartControllerContentDelegate>()
      ), tag: pageName
    );
  }

  @override
  _ProductBundleDetailPageRestoration createPageRestoration() => _ProductBundleDetailPageRestoration();

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulProductBundleDetailControllerMediatorWidget(
      productBundleDetailPageParameter: productBundleDetailPageParameter,
      productBundleDetailController: _productBundleDetailController.controller,
    );
  }
}

class _ProductBundleDetailPageRestoration extends ExtendedMixableGetxPageRestoration with ProductDetailPageRestorationMixin, ProductBundleDetailPageRestorationMixin, SearchPageRestorationMixin {
  @override
  // ignore: unnecessary_overrides
  void initState() {
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

class ProductBundleDetailPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  final ProductBundleDetailPageParameter productBundleDetailPageParameter;

  ProductBundleDetailPageGetPageBuilderAssistant({
    required this.productBundleDetailPageParameter
  });

  @override
  GetPageBuilder get pageBuilder => (() => ProductBundleDetailPage(productBundleDetailPageParameter: productBundleDetailPageParameter));

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(ProductBundleDetailPage(productBundleDetailPageParameter: productBundleDetailPageParameter)));
}

mixin ProductBundleDetailPageRestorationMixin on MixableGetxPageRestoration {
  late ProductBundleDetailPageRestorableRouteFuture productBundleDetailPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    productBundleDetailPageRestorableRouteFuture = ProductBundleDetailPageRestorableRouteFuture(restorationId: restorationIdWithPageName('product-brand-detail-route'));
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    productBundleDetailPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    productBundleDetailPageRestorableRouteFuture.dispose();
  }
}

class ProductBundleDetailPageRestorableRouteFuture extends GetRestorableRouteFuture {
  late RestorableRouteFuture<void> _pageRoute;

  ProductBundleDetailPageRestorableRouteFuture({required String restorationId}) : super(restorationId: restorationId) {
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
    ProductBundleDetailPageParameter productBundleDetailPageParameter = arguments.toProductBundleDetailPageParameter();
    return GetExtended.toWithGetPageRouteReturnValue<void>(
      GetxPageBuilder.buildRestorableGetxPageBuilder(
        ProductBundleDetailPageGetPageBuilderAssistant(
          productBundleDetailPageParameter: productBundleDetailPageParameter
        )
      ),
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

class _StatefulProductBundleDetailControllerMediatorWidget extends StatefulWidget {
  final ProductBundleDetailController productBundleDetailController;
  final ProductBundleDetailPageParameter productBundleDetailPageParameter;

  const _StatefulProductBundleDetailControllerMediatorWidget({
    required this.productBundleDetailController,
    required this.productBundleDetailPageParameter
  });

  @override
  State<_StatefulProductBundleDetailControllerMediatorWidget> createState() => _StatefulProductBundleDetailControllerMediatorWidgetState();
}

class _StatefulProductBundleDetailControllerMediatorWidgetState extends State<_StatefulProductBundleDetailControllerMediatorWidget> {
  late final ModifiedPagingController<int, ListItemControllerState> _productBundleDetailListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _productBundleDetailListItemPagingControllerState;

  final ValueNotifier<dynamic> _fillerErrorValueNotifier = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    _productBundleDetailListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.productBundleDetailController.apiRequestManager,
      additionalPagingResultParameterChecker: Injector.locator<ProductBundleDetailAdditionalPagingResultParameterChecker>(),
      fillerErrorValueNotifier: _fillerErrorValueNotifier
    );
    _productBundleDetailListItemPagingControllerState = PagingControllerState(
      pagingController: _productBundleDetailListItemPagingController,
      isPagingControllerExist: false
    );
    _productBundleDetailListItemPagingControllerState.pagingController.addPageRequestListenerForLoadDataResult(
      listener: _productBundleDetailListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _productBundleDetailListItemPagingControllerState.isPagingControllerExist = true;
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _productBundleDetailListItemPagingControllerStateListener(int pageKey) async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fillerErrorValueNotifier.value = null;
    });
    LoadDataResult<ProductBundleDetail> productBundleDetailLoadDataResult = await () {
      ProductBundleDetailPageParameter productBundleDetailPageParameter = widget.productBundleDetailPageParameter;
      if (productBundleDetailPageParameter is DefaultProductBundleDetailPageParameter) {
        return widget.productBundleDetailController.getProductBundleDetail(
          ProductBundleDetailParameter(productBundleId: productBundleDetailPageParameter.productBundleId)
        );
      } else if (productBundleDetailPageParameter is SlugProductBundleDetailPageParameter) {
        return widget.productBundleDetailController.getProductBundleDetailBySlug(
          ProductBundleDetailBySlugParameter(productBundleSlug: productBundleDetailPageParameter.slug)
        );
      }
      throw MessageError(title: "Subclass of ProductBundleDetailPageParameter is not suitable");
    }();
    if (productBundleDetailLoadDataResult.isSuccess && pageKey == 1) {
      List itemList = productBundleDetailLoadDataResult.resultIfSuccess!.productEntryList;
      if (itemList.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          _fillerErrorValueNotifier.value = FailedLoadDataResult.throwException(() {
            throw ErrorHelper.generateMultiLanguageDioError(
              MultiLanguageMessageError(
                title: MultiLanguageString({
                  Constant.textEnUsLanguageKey: "Product Is Empty",
                  Constant.textInIdLanguageKey: "Produk Kosong",
                }),
                message: MultiLanguageString({
                  Constant.textEnUsLanguageKey: "For now, product is empty in this product bundle.",
                  Constant.textInIdLanguageKey: "Untuk sekarang, produk kosong di bundel produk ini.",
                }),
              )
            );
          })!.e;
        });
      }
    }
    return productBundleDetailLoadDataResult.map((productBundleDetail) {
      return PagingDataResult<ListItemControllerState>(
        page: 1,
        totalPage: 1,
        totalItem: 1,
        itemList: [
          BuilderListItemControllerState(
            buildListItemControllerState: () => CompoundListItemControllerState(
              listItemControllerState: [
                PaddingContainerListItemControllerState(
                  padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
                  paddingChildListItemControllerState: ProductBundleHeaderListItemControllerState(
                    productBundle: productBundleDetail,
                    onAddWishlist: (productBundleOutput) => widget.productBundleDetailController.wishlistAndCartControllerContentDelegate.addToWishlist(
                      productBundleOutput, () {
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
                    onRemoveWishlist: (productBundleOutput) => widget.productBundleDetailController.wishlistAndCartControllerContentDelegate.removeFromWishlist(
                      productBundleOutput, () {
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
                    onAddCart: (productBundleOutput) => widget.productBundleDetailController.wishlistAndCartControllerContentDelegate.addToCart(
                      productBundleOutput, () {
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
                ),
                ...productBundleDetail.productEntryList.map<ListItemControllerState>((product) {
                  return VerticalProductListItemControllerState(
                    productAppearanceData: product,
                    onRemoveWishlist: (productBundleId) {},
                    onAddWishlist: (productBundleId) {}
                  );
                }).toList()
              ]
            )
          )
        ]
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    widget.productBundleDetailController.wishlistAndCartControllerContentDelegate.setWishlistAndCartDelegate(
      Injector.locator<WishlistAndCartDelegateFactory>().generateWishlistAndCartDelegate(
        onGetBuildContext: () => context,
        onGetErrorProvider: () => Injector.locator<ErrorProvider>(),
        onAddToWishlistRequestProcessSuccessCallback: () async => context.read<ComponentNotifier>().updateWishlist(),
        onRemoveFromWishlistRequestProcessSuccessCallback: (wishlist) async => context.read<ComponentNotifier>().updateWishlist(),
        onAddCartRequestProcessSuccessCallback: () async {
          context.read<ComponentNotifier>().updateCart();
          context.read<NotificationNotifier>().loadCartLoadDataResult();
          context.read<ProductNotifier>().loadCartList();
        },
      )
    );
    return ModifiedScaffold(
      appBar: DefaultSearchAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
                pagingControllerState: _productBundleDetailListItemPagingControllerState,
                onProvidePagedChildBuilderDelegate: (pagingControllerState) => ListItemPagingControllerStatePagedChildBuilderDelegate<int>(
                  pagingControllerState: pagingControllerState!
                ),
                pullToRefresh: true,
                onGetErrorProvider: () => Injector.locator<ErrorProvider>(),
              ),
            ),
          ]
        )
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

abstract class ProductBundleDetailPageParameter {}

class DefaultProductBundleDetailPageParameter extends ProductBundleDetailPageParameter {
  final String productBundleId;

  DefaultProductBundleDetailPageParameter({
    required this.productBundleId
  });
}

class SlugProductBundleDetailPageParameter extends ProductBundleDetailPageParameter {
  String slug;

  SlugProductBundleDetailPageParameter({
    required this.slug
  });
}

extension ProductBundleDetailPageParameterExt on ProductBundleDetailPageParameter {
  String toEncodeBase64String() => StringUtil.encodeBase64StringFromJson(
    () {
      if (this is SlugProductBundleDetailPageParameter) {
        SlugProductBundleDetailPageParameter slugProductBundleDetailPageParameter = this as SlugProductBundleDetailPageParameter;
        return <String, dynamic>{
          "product_bundle_slug": slugProductBundleDetailPageParameter.slug
        };
      } else {
        DefaultProductBundleDetailPageParameter defaultProductBundleDetailPageParameter = this as DefaultProductBundleDetailPageParameter;
        return <String, dynamic>{
          "product_bundle_id": defaultProductBundleDetailPageParameter.productBundleId
        };
      }
    }()
  );
}

extension ProductBundleDetailPageParameterStringExt on String {
  ProductBundleDetailPageParameter toProductBundleDetailPageParameter() {
    Map<String, dynamic> result = StringUtil.decodeBase64StringToJson(this);
    if (result.containsKey("product_bundle_slug")) {
      return SlugProductBundleDetailPageParameter(
        slug: result["product_bundle_slug"]
      );
    } else {
      return DefaultProductBundleDetailPageParameter(
        productBundleId: result["product_bundle_id"]
      );
    }
  }
}