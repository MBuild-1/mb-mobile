import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';
import 'package:masterbagasi/misc/ext/paging_ext.dart';
import '../../controller/coupon_controller.dart';
import '../../domain/entity/coupon/coupon.dart';
import '../../domain/entity/coupon/coupon_paging_parameter.dart';
import '../../domain/usecase/get_coupon_paging_use_case.dart';
import '../../misc/additionalloadingindicatorchecker/coupon_additional_paging_result_parameter_checker.dart';
import '../../misc/constant.dart';
import '../../misc/controllerstate/listitemcontrollerstate/compound_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/couponlistitemcontrollerstate/vertical_coupon_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import '../../misc/controllerstate/paging_controller_state.dart';
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

class CouponPage extends RestorableGetxPage<_CouponPageRestoration> {
  late final ControllerMember<CouponController> _couponController = ControllerMember<CouponController>().addToControllerManager(controllerManager);

  CouponPage({Key? key}) : super(key: key, pageRestorationId: () => "coupon-page");

  @override
  void onSetController() {
    _couponController.controller = GetExtended.put<CouponController>(
      CouponController(
        controllerManager,
        Injector.locator<GetCouponPagingUseCase>()
      ),
      tag: pageName
    );
  }

  @override
  _CouponPageRestoration createPageRestoration() => _CouponPageRestoration();

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      body: _StatefulCouponControllerMediatorWidget(
        couponController: _couponController.controller,
      ),
    );
  }
}

class _CouponPageRestoration extends MixableGetxPageRestoration with CouponPageRestorationMixin {
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

class CouponPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  CouponPageGetPageBuilderAssistant();

  @override
  GetPageBuilder get pageBuilder => (() => CouponPage());

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(CouponPage()));
}

mixin CouponPageRestorationMixin on MixableGetxPageRestoration {
  late CouponPageRestorableRouteFuture couponPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    couponPageRestorableRouteFuture = CouponPageRestorableRouteFuture(restorationId: restorationIdWithPageName('coupon-route'));
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    couponPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    couponPageRestorableRouteFuture.dispose();
  }
}

class CouponPageRestorableRouteFuture extends GetRestorableRouteFuture {
  late RestorableRouteFuture<void> _pageRoute;

  CouponPageRestorableRouteFuture({required String restorationId}) : super(restorationId: restorationId) {
    _pageRoute = RestorableRouteFuture<void>(
      onPresent: (NavigatorState navigator, Object? arguments) {
        return navigator.restorablePush(_pageRouteBuilder, arguments: arguments);
      },
    );
  }

  static Route<void>? _getRoute([Object? arguments]) {
    return GetExtended.toWithGetPageRouteReturnValue<void>(
      GetxPageBuilder.buildRestorableGetxPageBuilder(CouponPageGetPageBuilderAssistant()),
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

class _StatefulCouponControllerMediatorWidget extends StatefulWidget {
  final CouponController couponController;

  const _StatefulCouponControllerMediatorWidget({
    required this.couponController,
  });

  @override
  State<_StatefulCouponControllerMediatorWidget> createState() => _StatefulCouponControllerMediatorWidgetState();
}

class _StatefulCouponControllerMediatorWidgetState extends State<_StatefulCouponControllerMediatorWidget> {
  late final ModifiedPagingController<int, ListItemControllerState> _couponListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _couponListItemPagingControllerState;

  @override
  void initState() {
    super.initState();
    _couponListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.couponController.apiRequestManager,
      additionalPagingResultParameterChecker: Injector.locator<CouponAdditionalPagingResultParameterChecker>()
    );
    _couponListItemPagingControllerState = PagingControllerState(
      pagingController: _couponListItemPagingController,
      isPagingControllerExist: false
    );
    _couponListItemPagingControllerState.pagingController.addPageRequestListenerForLoadDataResult(
      listener: _couponListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _couponListItemPagingControllerState.isPagingControllerExist = true;
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _couponListItemPagingControllerStateListener(int pageKey) async {
    LoadDataResult<PagingDataResult<Coupon>> couponPagingLoadDataResult = await widget.couponController.getCouponPaging(
      CouponPagingParameter(page: pageKey)
    );
    return couponPagingLoadDataResult.map((couponPaging) {
      List<ListItemControllerState> couponListItemControllerState = couponPaging.itemList.mapIndexed<ListItemControllerState>(
        (index, coupon) => CompoundListItemControllerState(
          listItemControllerState: [
            VirtualSpacingListItemControllerState(height: Constant.paddingListItem),
            PaddingContainerListItemControllerState(
              padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
              paddingChildListItemControllerState: VerticalCouponListItemControllerState(
                coupon: coupon,
                onSelectCoupon: (selectedCoupon) {}
              )
            ),
            if (index == couponPaging.itemList.length - 1)
              VirtualSpacingListItemControllerState(height: Constant.paddingListItem),
          ]
        )
      ).toList();
      return couponPaging.map(
        (coupon) => CompoundListItemControllerState(
          listItemControllerState: couponListItemControllerState
        )
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
                pagingControllerState: _couponListItemPagingControllerState,
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