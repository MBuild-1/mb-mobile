import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/home_controller.dart';
import '../../domain/usecase/get_most_discount_product_from_cached_product_list.dart';
import '../../domain/usecase/get_product_detail.dart';
import '../../domain/usecase/get_product_list.dart';
import '../../misc/additionalloadingindicatorchecker/home_paging_result_parameter_checker.dart';
import '../../misc/constant.dart';
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
import 'product_page.dart';

class HomePage extends RestorableGetxPage<_HomePageRestoration> {
  late final ControllerMember<HomeController> _homeController = ControllerMember<HomeController>().addToControllerManager(controllerManager);

  HomePage({Key? key}) : super(key: key, pageRestorationId: () => "home-page");

  @override
  void onSetController() {
    _homeController.controller = GetExtended.put<HomeController>(
      HomeController(
        controllerManager,
        Injector.locator<GetProductDetail>(),
        Injector.locator<GetProductList>(),
        Injector.locator<GetMostDiscountProductFromCachedProductList>(),
        Injector.locator<HomePagingResultParameterChecker>()
      ),
      tag: pageName
    );
  }

  @override
  // ignore: library_private_types_in_public_api
  _HomePageRestoration createPageRestoration() => _HomePageRestoration();

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      appBar: ModifiedAppBar(
        title: SizedBox(
          height: 30,
          width: 30,
          child: Image.asset(Constant.imageLogoSuperIndo),
        ),
        titleInterceptor: (context, title) => Row(
          children: [
            title ?? Container(),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RxConsumer<PagingControllerState<int, ListItemControllerState>>(
                rxValue: _homeController.controller.homeListItemPagingControllerStateRx,
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

class HomePageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  @override
  GetPageBuilder get pageBuilder => (() => HomePage());

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(HomePage()));
}

class _HomePageRestoration extends MixableGetxPageRestoration with ProductPageRestorationMixin, ProductDetailPageRestorationMixin {
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

mixin HomePageRestorationMixin on MixableGetxPageRestoration {
  late HomePageRestorableRouteFuture homePageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    homePageRestorableRouteFuture = HomePageRestorableRouteFuture(restorationId: restorationIdWithPageName('home-route'));
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    homePageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    homePageRestorableRouteFuture.dispose();
  }
}

class HomePageRestorableRouteFuture extends GetRestorableRouteFuture {
  late RestorableRouteFuture<void> _pageRoute;

  HomePageRestorableRouteFuture({
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
      GetxPageBuilder.buildRestorableGetxPageBuilder(HomePageGetPageBuilderAssistant())
    );
  }

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