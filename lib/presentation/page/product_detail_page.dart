import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/product_detail_controller.dart';
import '../../domain/usecase/get_product_detail.dart';
import '../../misc/additionalloadingindicatorchecker/product_detail_paging_result_parameter_checker.dart';
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

class ProductDetailPage extends RestorableGetxPage<_ProductDetailPageRestoration> {
  final String productDetailEndpoint;

  late final ControllerMember<ProductDetailController> _productDetailController = ControllerMember<ProductDetailController>().addToControllerManager(controllerManager);

  ProductDetailPage({Key? key, required this.productDetailEndpoint}) : super(key: key, pageRestorationId: () => "product-detail-page");

  @override
  void onSetController() {
    _productDetailController.controller = GetExtended.put<ProductDetailController>(
      ProductDetailController(
        controllerManager,
        Injector.locator<GetProductDetail>(),
        Injector.locator<ProductDetailPagingResultParameterChecker>()
      ),
      tag: pageName
    );
  }

  @override
  // ignore: library_private_types_in_public_api
  _ProductDetailPageRestoration createPageRestoration() => _ProductDetailPageRestoration();

  @override
  Widget buildPage(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _productDetailController.controller.initProductDetail(productDetailEndpoint);
    });
    return Scaffold(
      appBar: ModifiedAppBar(
        title: Text("Product Detail".tr),
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
                rxValue: _productDetailController.controller.productDetailListItemPagingControllerStateRx,
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

class ProductDetailPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  final String productDetailEndpoint;

  ProductDetailPageGetPageBuilderAssistant({required this.productDetailEndpoint});

  @override
  GetPageBuilder get pageBuilder => (() => ProductDetailPage(productDetailEndpoint: productDetailEndpoint));

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(ProductDetailPage(productDetailEndpoint: productDetailEndpoint)));
}

class _ProductDetailPageRestoration extends MixableGetxPageRestoration {
  @override
  void initState() {
    super.initState();
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
  }
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

  ProductDetailPageRestorableRouteFuture({
    required String restorationId,
  }) : super(restorationId: restorationId) {
    _pageRoute = RestorableRouteFuture<bool?>(
      onPresent: (NavigatorState navigator, Object? arguments) {
        return navigator.restorablePush(_pageRouteBuilder, arguments: arguments);
      },
    );
  }

  static Route<void>? _getRoute([Object? arguments]) {
    if (arguments is! String) {
      throw Exception("Arguments must be a string");
    }
    return GetExtended.toWithGetPageRouteReturnValue<bool?>(
      GetxPageBuilder.buildRestorableGetxPageBuilder(ProductDetailPageGetPageBuilderAssistant(productDetailEndpoint: arguments))
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