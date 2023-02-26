import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/product_controller.dart';
import '../../domain/usecase/get_product_detail.dart';
import '../../domain/usecase/get_product_list.dart';
import '../../misc/additionalloadingindicatorchecker/product_paging_result_parameter_checker.dart';
import '../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../misc/controllerstate/paging_controller_state.dart';
import '../../misc/getextended/get_extended.dart';
import '../../misc/getextended/get_restorable_route_future.dart';
import '../../misc/injector.dart';
import '../../misc/manager/controller_manager.dart';
import '../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../widget/modified_paged_list_view.dart';
import '../widget/modifiedappbar/modified_app_bar.dart';
import '../widget/rx_consumer.dart';
import 'getx_page.dart';
import 'product_detail_page.dart';

class ProductPage extends RestorableGetxPage<_ProductPageRestoration> {
  late final ControllerMember<ProductController> _productController = ControllerMember<ProductController>().addToControllerManager(controllerManager);

  ProductPage({Key? key}) : super(key: key, pageRestorationId: () => "product-page");

  @override
  void onSetController() {
    _productController.controller = GetExtended.put<ProductController>(
      ProductController(
        controllerManager,
        Injector.locator<GetProductDetail>(),
        Injector.locator<GetProductList>(),
        Injector.locator<ProductPagingResultParameterChecker>()
      ),
      tag: pageName
    );
  }

  @override
  // ignore: library_private_types_in_public_api
  _ProductPageRestoration createPageRestoration() => _ProductPageRestoration();

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      appBar: ModifiedAppBar(
        title: Text("Product".tr),
        titleInterceptor: (context, title) => Row(
          children: [
            Expanded(
              child: title ?? Container()
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RxConsumer<PagingControllerState<int, ListItemControllerState>>(
                rxValue: _productController.controller.productListItemPagingControllerStateRx,
                onConsumeValue: (context, value) => ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
                  pagingControllerState: value,
                  onProvidePagedChildBuilderDelegate: (pagingControllerState) => ListItemPagingControllerStatePagedChildBuilderDelegate<int>(
                    pagingControllerState: pagingControllerState!
                  ),
                  pullToRefresh: true
                ),
              ),
            ),
          ]
        )
      ),
    );
  }
}

class ProductPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  @override
  GetPageBuilder get pageBuilder => (() => ProductPage());

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(ProductPage()));
}

class _ProductPageRestoration extends MixableGetxPageRestoration with ProductDetailPageRestorationMixin {
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

mixin ProductPageRestorationMixin on MixableGetxPageRestoration {
  late ProductPageRestorableRouteFuture productPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    productPageRestorableRouteFuture = ProductPageRestorableRouteFuture(restorationId: restorationIdWithPageName('product-route'));
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    productPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    productPageRestorableRouteFuture.dispose();
  }
}

class ProductPageRestorableRouteFuture extends GetRestorableRouteFuture {
  late RestorableRouteFuture<void> _pageRoute;

  ProductPageRestorableRouteFuture({
    required String restorationId,
  }) : super(restorationId: restorationId) {
    _pageRoute = RestorableRouteFuture<bool?>(
      onPresent: (NavigatorState navigator, Object? arguments) {
        return navigator.restorablePush(_pageRouteBuilder, arguments: arguments);
      },
    );
  }

  static Route<void>? _getRoute([Object? arguments]) {
    return GetExtended.toWithGetPageRouteReturnValue<bool?>(
      GetxPageBuilder.buildRestorableGetxPageBuilder(ProductPageGetPageBuilderAssistant())
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