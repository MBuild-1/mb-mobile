import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';

import '../../controller/product_brand_detail_controller.dart';
import '../../domain/entity/product/productbrand/product_brand_detail.dart';
import '../../domain/entity/product/productbrand/product_brand_detail_parameter.dart';
import '../../domain/usecase/get_product_brand_detail_use_case.dart';
import '../../misc/additionalloadingindicatorchecker/product_brand_detail_additional_paging_result_parameter_checker.dart';
import '../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/product_detail_brand_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/productlistitemcontrollerstate/vertical_product_list_item_controller_state.dart';
import '../../misc/controllerstate/paging_controller_state.dart';
import '../../misc/error/message_error.dart';
import '../../misc/getextended/get_extended.dart';
import '../../misc/getextended/get_restorable_route_future.dart';
import '../../misc/injector.dart';
import '../../misc/load_data_result.dart';
import '../../misc/manager/controller_manager.dart';
import '../../misc/paging/modified_paging_controller.dart';
import '../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/paging/pagingresult/paging_result.dart';
import '../widget/modified_paged_list_view.dart';
import '../widget/modifiedappbar/default_search_app_bar.dart';
import 'getx_page.dart';
import 'product_detail_page.dart';

class ProductBrandDetailPage  extends RestorableGetxPage<_ProductBrandDetailPageRestoration> {
  late final ControllerMember<ProductBrandDetailController> _productBrandDetailController = ControllerMember<ProductBrandDetailController>().addToControllerManager(controllerManager);

  final String productBrandId;

  ProductBrandDetailPage({Key? key, required this.productBrandId}) : super(key: key, pageRestorationId: () => "product-brand-detail-page");

  @override
  void onSetController() {
    _productBrandDetailController.controller = GetExtended.put<ProductBrandDetailController>(
      ProductBrandDetailController(controllerManager, Injector.locator<GetProductBrandDetailUseCase>()), tag: pageName
    );
  }

  @override
  _ProductBrandDetailPageRestoration createPageRestoration() => _ProductBrandDetailPageRestoration();

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      body: _StatefulProductBrandDetailControllerMediatorWidget(
        productBrandId: productBrandId,
        productBrandDetailController: _productBrandDetailController.controller,
      ),
    );
  }
}

class _ProductBrandDetailPageRestoration extends MixableGetxPageRestoration with ProductDetailPageRestorationMixin {
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

class ProductBrandDetailPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  final String productBrandId;

  ProductBrandDetailPageGetPageBuilderAssistant({
    required this.productBrandId
  });

  @override
  GetPageBuilder get pageBuilder => (() => ProductBrandDetailPage(productBrandId: productBrandId));

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(ProductBrandDetailPage(productBrandId: productBrandId)));
}

mixin ProductBrandDetailPageRestorationMixin on MixableGetxPageRestoration {
  late ProductBrandDetailPageRestorableRouteFuture productBrandDetailPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    productBrandDetailPageRestorableRouteFuture = ProductBrandDetailPageRestorableRouteFuture(restorationId: restorationIdWithPageName('product-brand-detail-route'));
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    productBrandDetailPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    productBrandDetailPageRestorableRouteFuture.dispose();
  }
}

class ProductBrandDetailPageRestorableRouteFuture extends GetRestorableRouteFuture {
  late RestorableRouteFuture<void> _pageRoute;

  ProductBrandDetailPageRestorableRouteFuture({required String restorationId}) : super(restorationId: restorationId) {
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
      GetxPageBuilder.buildRestorableGetxPageBuilder(ProductBrandDetailPageGetPageBuilderAssistant(productBrandId: arguments)),
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

class _StatefulProductBrandDetailControllerMediatorWidget extends StatefulWidget {
  final ProductBrandDetailController productBrandDetailController;
  final String productBrandId;

  const _StatefulProductBrandDetailControllerMediatorWidget({
    required this.productBrandDetailController,
    required this.productBrandId
  });

  @override
  State<_StatefulProductBrandDetailControllerMediatorWidget> createState() => _StatefulProductBrandDetailControllerMediatorWidgetState();
}

class _StatefulProductBrandDetailControllerMediatorWidgetState extends State<_StatefulProductBrandDetailControllerMediatorWidget> {
  late final ModifiedPagingController<int, ListItemControllerState> _productBrandDetailListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _productBrandDetailListItemPagingControllerState;

  @override
  void initState() {
    super.initState();
    _productBrandDetailListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.productBrandDetailController.apiRequestManager,
      additionalPagingResultParameterChecker: Injector.locator<ProductBrandDetailAdditionalPagingResultParameterChecker>()
    );
    _productBrandDetailListItemPagingControllerState = PagingControllerState(
      pagingController: _productBrandDetailListItemPagingController,
      isPagingControllerExist: false
    );
    _productBrandDetailListItemPagingControllerState.pagingController.addPageRequestListenerForLoadDataResult(
      listener: _productBrandDetailListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _productBrandDetailListItemPagingControllerState.isPagingControllerExist = true;
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _productBrandDetailListItemPagingControllerStateListener(int pageKey) async {
    LoadDataResult<ProductBrandDetail> productBrandDetailLoadDataResult = await widget.productBrandDetailController.getProductBrandDetail(
      ProductBrandDetailParameter(productBrandId: widget.productBrandId)
    );
    return productBrandDetailLoadDataResult.map((productBrandDetail) {
      return PagingDataResult<ListItemControllerState>(
        page: 1,
        totalPage: 1,
        totalItem: 1,
        itemList: [
          ProductDetailBrandListItemControllerState(productBrand: productBrandDetail),
          ...productBrandDetail.shortProductList.map<ListItemControllerState>((product) {
            return VerticalProductListItemControllerState(
              productAppearanceData: product
            );
          }).toList()
        ]
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultSearchAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
                pagingControllerState: _productBrandDetailListItemPagingControllerState,
                onProvidePagedChildBuilderDelegate: (pagingControllerState) => ListItemPagingControllerStatePagedChildBuilderDelegate<int>(
                  pagingControllerState: pagingControllerState!
                ),
                pullToRefresh: true
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