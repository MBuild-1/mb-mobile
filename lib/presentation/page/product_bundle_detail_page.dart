import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';
import 'package:provider/provider.dart';

import '../../controller/product_bundle_detail_controller.dart';
import '../../domain/entity/product/productbundle/product_bundle_detail.dart';
import '../../domain/entity/product/productbundle/product_bundle_detail_parameter.dart';
import '../../domain/usecase/get_product_bundle_detail_use_case.dart';
import '../../misc/additionalloadingindicatorchecker/product_bundle_detail_additional_paging_result_parameter_checker.dart';
import '../../misc/constant.dart';
import '../../misc/controllercontentdelegate/wishlist_and_cart_controller_content_delegate.dart';
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
import '../../misc/manager/controller_manager.dart';
import '../../misc/multi_language_string.dart';
import '../../misc/paging/modified_paging_controller.dart';
import '../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/paging/pagingresult/paging_result.dart';
import '../notifier/component_notifier.dart';
import '../notifier/notification_notifier.dart';
import '../widget/modified_paged_list_view.dart';
import '../widget/modifiedappbar/default_search_app_bar.dart';
import 'getx_page.dart';
import 'product_detail_page.dart';
import 'search_page.dart';

class ProductBundleDetailPage extends RestorableGetxPage<_ProductBundleDetailPageRestoration> {
  late final ControllerMember<ProductBundleDetailController> _productBundleDetailController = ControllerMember<ProductBundleDetailController>().addToControllerManager(controllerManager);

  final String productBundleId;

  ProductBundleDetailPage({Key? key, required this.productBundleId}) : super(key: key, pageRestorationId: () => "product-bundle-detail-page");

  @override
  void onSetController() {
    _productBundleDetailController.controller = GetExtended.put<ProductBundleDetailController>(
      ProductBundleDetailController(
        controllerManager,
        Injector.locator<GetProductBundleDetailUseCase>(),
        Injector.locator<WishlistAndCartControllerContentDelegate>()
      ), tag: pageName
    );
  }

  @override
  _ProductBundleDetailPageRestoration createPageRestoration() => _ProductBundleDetailPageRestoration();

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      body: _StatefulProductBundleDetailControllerMediatorWidget(
        productBundleId: productBundleId,
        productBundleDetailController: _productBundleDetailController.controller,
      ),
    );
  }
}

class _ProductBundleDetailPageRestoration extends MixableGetxPageRestoration with ProductDetailPageRestorationMixin, ProductBundleDetailPageRestorationMixin, SearchPageRestorationMixin {
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
  final String productBundleId;

  ProductBundleDetailPageGetPageBuilderAssistant({
    required this.productBundleId
  });

  @override
  GetPageBuilder get pageBuilder => (() => ProductBundleDetailPage(productBundleId: productBundleId));

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(ProductBundleDetailPage(productBundleId: productBundleId)));
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
    return GetExtended.toWithGetPageRouteReturnValue<void>(
      GetxPageBuilder.buildRestorableGetxPageBuilder(ProductBundleDetailPageGetPageBuilderAssistant(productBundleId: arguments)),
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
  final String productBundleId;

  const _StatefulProductBundleDetailControllerMediatorWidget({
    required this.productBundleDetailController,
    required this.productBundleId
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
    LoadDataResult<ProductBundleDetail> productBundleDetailLoadDataResult = await widget.productBundleDetailController.getProductBundleDetail(
      ProductBundleDetailParameter(productBundleId: widget.productBundleId)
    );
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
          PaddingContainerListItemControllerState(
            padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
            paddingChildListItemControllerState: ProductBundleHeaderListItemControllerState(
              productBundle: productBundleDetail,
              onAddWishlist: (productBundleOutput) => widget.productBundleDetailController.wishlistAndCartControllerContentDelegate.addToWishlist(productBundleOutput),
              onRemoveWishlist: (productBundleOutput) => widget.productBundleDetailController.wishlistAndCartControllerContentDelegate.removeFromWishlist(productBundleOutput),
              onAddCart: (productBundleOutput) => widget.productBundleDetailController.wishlistAndCartControllerContentDelegate.addToCart(productBundleOutput),
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
        }
      )
    );
    return Scaffold(
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