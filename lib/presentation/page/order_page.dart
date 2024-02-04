import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:masterbagasi/presentation/page/web_viewer_page.dart';

import '../../controller/order_controller.dart';
import '../../domain/entity/order/arrived_order_request.dart';
import '../../domain/entity/order/combined_order.dart';
import '../../domain/entity/order/order_paging_parameter.dart';
import '../../domain/usecase/arrived_order_use_case.dart';
import '../../domain/usecase/get_order_paging_use_case.dart';
import '../../misc/constant.dart';
import '../../misc/controllercontentdelegate/repurchase_controller_content_delegate.dart';
import '../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/orderlistitemcontrollerstate/order_container_list_item_controller_state.dart';
import '../../misc/controllerstate/paging_controller_state.dart';
import '../../misc/dialog_helper.dart';
import '../../misc/error/message_error.dart';
import '../../misc/error_helper.dart';
import '../../misc/errorprovider/error_provider.dart';
import '../../misc/getextended/get_extended.dart';
import '../../misc/getextended/get_restorable_route_future.dart';
import '../../misc/injector.dart';
import '../../misc/itemtypelistsubinterceptor/order_item_type_list_sub_interceptor.dart';
import '../../misc/list_item_controller_state_helper.dart';
import '../../misc/load_data_result.dart';
import '../../misc/main_route_observer.dart';
import '../../misc/manager/controller_manager.dart';
import '../../misc/multi_language_string.dart';
import '../../misc/paging/modified_paging_controller.dart';
import '../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/paging/pagingresult/paging_result.dart';
import '../../misc/routeargument/order_route_argument.dart';
import '../../misc/temp_order_detail_back_result_data_helper.dart';
import '../widget/colorful_chip_tab_bar.dart';
import '../widget/modified_paged_list_view.dart';
import '../widget/modified_scaffold.dart';
import '../widget/modifiedappbar/modified_app_bar.dart';
import 'getx_page.dart';
import 'order_detail_page.dart';

class OrderPage extends RestorableGetxPage<_OrderPageRestoration> {
  late final ControllerMember<OrderController> _orderPageController = ControllerMember<OrderController>().addToControllerManager(controllerManager);

  final _StatefulOrderControllerMediatorWidgetDelegate _statefulOrderControllerMediatorWidgetDelegate = _StatefulOrderControllerMediatorWidgetDelegate();

  OrderPage({Key? key}) : super(key: key, pageRestorationId: () => "order-page");

  @override
  void onSetController() {
    _orderPageController.controller = GetExtended.put<OrderController>(
      OrderController(
        controllerManager,
        Injector.locator<GetOrderPagingUseCase>(),
        Injector.locator<ArrivedOrderUseCase>(),
        Injector.locator<RepurchaseControllerContentDelegate>()
      ),
      tag: pageName
    );
  }

  @override
  _OrderPageRestoration createPageRestoration() => _OrderPageRestoration(
    onCompleteOrderDetailPage: (result) {
      bool removeOrder(String resultString) {
        if (resultString.isNotEmptyString) {
          Map<String, dynamic> resultFromStorageMap = json.decode(resultString) as Map<String, dynamic>;
          if (resultFromStorageMap.containsKey("combined_order_id")) {
            String combinedOrderId = resultFromStorageMap["combined_order_id"];
            if (_statefulOrderControllerMediatorWidgetDelegate.onRemoveOrder != null) {
              _statefulOrderControllerMediatorWidgetDelegate.onRemoveOrder!(combinedOrderId);
              return true;
            }
          }
        }
        return false;
      }
      bool willRemoveOrder = false;
      if (result != null) {
        willRemoveOrder = removeOrder(result.toEmptyStringNonNull);
      } else {
        String resultFromStorage = TempOrderDetailBackResultDataHelper.getTempOrderDetailBackResult().result;
        willRemoveOrder = removeOrder(resultFromStorage);
      }
      if (willRemoveOrder) {
        TempOrderDetailBackResultDataHelper.deleteTempOrderDetailBackResult().future();
      }
    },
  );

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulOrderControllerMediatorWidget(
      orderController: _orderPageController.controller,
      statefulOrderControllerMediatorWidgetDelegate: _statefulOrderControllerMediatorWidgetDelegate
    );
  }
}

class _OrderPageRestoration extends ExtendedMixableGetxPageRestoration with WebViewerPageRestorationMixin, OrderDetailPageRestorationMixin {
  final RouteCompletionCallback<String?>? _onCompleteOrderDetailPage;

  _OrderPageRestoration({
    RouteCompletionCallback<String?>? onCompleteOrderDetailPage
  }) : _onCompleteOrderDetailPage = onCompleteOrderDetailPage;

  @override
  // ignore: unnecessary_overrides
  void initState() {
    onCompleteOrderDetailPage = _onCompleteOrderDetailPage;
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

class OrderPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  @override
  GetPageBuilder get pageBuilder => (() => OrderPage());

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(OrderPage()));
}

mixin OrderPageRestorationMixin on MixableGetxPageRestoration {
  late OrderPageRestorableRouteFuture orderPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    orderPageRestorableRouteFuture = OrderPageRestorableRouteFuture(restorationId: restorationIdWithPageName('order-route'));
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    orderPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    orderPageRestorableRouteFuture.dispose();
  }
}

class OrderPageRestorableRouteFuture extends GetRestorableRouteFuture {
  late RestorableRouteFuture<void> _pageRoute;

  OrderPageRestorableRouteFuture({required String restorationId}) : super(restorationId: restorationId) {
    _pageRoute = RestorableRouteFuture<void>(
      onPresent: (NavigatorState navigator, Object? arguments) {
        return navigator.restorablePush(_pageRouteBuilder, arguments: arguments);
      },
    );
  }

  static Route<void>? _getRoute([Object? arguments]) {
    return GetExtended.toWithGetPageRouteReturnValue<void>(
      GetxPageBuilder.buildRestorableGetxPageBuilder(OrderPageGetPageBuilderAssistant()),
      arguments: OrderRouteArgument()
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

class _StatefulOrderControllerMediatorWidgetDelegate {
  void Function(String)? onRemoveOrder;
}

class _StatefulOrderControllerMediatorWidget extends StatefulWidget {
  final OrderController orderController;
  final _StatefulOrderControllerMediatorWidgetDelegate statefulOrderControllerMediatorWidgetDelegate;

  const _StatefulOrderControllerMediatorWidget({
    required this.orderController,
    required this.statefulOrderControllerMediatorWidgetDelegate
  });

  @override
  State<_StatefulOrderControllerMediatorWidget> createState() => _StatefulOrderControllerMediatorWidgetState();
}

class _StatefulOrderControllerMediatorWidgetState extends State<_StatefulOrderControllerMediatorWidget> {
  late final ScrollController _orderScrollController;
  late final ModifiedPagingController<int, ListItemControllerState> _orderListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _orderListItemPagingControllerState;
  late ColorfulChipTabBarController _orderTabColorfulChipTabBarController;
  late List<ColorfulChipTabBarData> _orderColorfulChipTabBarDataList;
  String _status = "";

  final ValueNotifier<dynamic> _fillerErrorValueNotifier = ValueNotifier(null);
  final DefaultOrderContainerInterceptingActionListItemControllerState _defaultOrderContainerInterceptingActionListItemControllerState = DefaultOrderContainerInterceptingActionListItemControllerState();

  @override
  void initState() {
    super.initState();
    _orderScrollController = ScrollController();
    _orderListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.orderController.apiRequestManager,
      fillerErrorValueNotifier: _fillerErrorValueNotifier
    );
    _orderListItemPagingControllerState = PagingControllerState(
      pagingController: _orderListItemPagingController,
      scrollController: _orderScrollController,
      isPagingControllerExist: false
    );
    _orderListItemPagingControllerState.pagingController.addPageRequestListenerWithItemListForLoadDataResult(
      listener: _orderListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _orderListItemPagingControllerState.isPagingControllerExist = true;
    _orderTabColorfulChipTabBarController = ColorfulChipTabBarController(0);
    _orderColorfulChipTabBarDataList = <ColorfulChipTabBarData>[
      ColorfulChipTabBarData(
        color: Constant.colorMain,
        title: "Semua",
        data: ""
      ),
      ColorfulChipTabBarData(
        color: Constant.colorMain,
        title: "Pesanan Diproses",
        data: "Pesanan Diproses"
      ),
      ColorfulChipTabBarData(
        color: Constant.colorMain,
        title: "Siap Dikirim",
        data: "Siap Dikirim"
      ),
      ColorfulChipTabBarData(
        color: Constant.colorMain,
        title: "Sedang Dikirim",
        data: "Sedang Dikirim"
      ),
      ColorfulChipTabBarData(
        color: Constant.colorMain,
        title: "Sampai Tujuan",
        data: "Sampai Tujuan"
      )
    ];
    _orderTabColorfulChipTabBarController.addListener(() {
      _status = (_orderColorfulChipTabBarDataList[_orderTabColorfulChipTabBarController.value].data as String).toEmptyStringNonNull;
      _orderListItemPagingController.resetToDesiredPageKey(1);
    });
    MainRouteObserver.onRefreshOrderList = _orderListItemPagingController.refresh;
    widget.statefulOrderControllerMediatorWidgetDelegate.onRemoveOrder = (combinedOrderId) {
      var onRemoveOrder = _defaultOrderContainerInterceptingActionListItemControllerState.onRemoveOrder;
      if (onRemoveOrder != null) {
        onRemoveOrder(combinedOrderId);
      }
    };
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _orderListItemPagingControllerStateListener(int pageKey, List<ListItemControllerState>? orderListItemControllerStateList) async {
    List<ListItemControllerState> resultListItemControllerState = [];
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fillerErrorValueNotifier.value = null;
    });
    if (pageKey == 1) {
      resultListItemControllerState = [
        OrderContainerListItemControllerState(
          orderList: [],
          onOrderTap: (order) {},
          onConfirmArrived: (order) => DialogHelper.showPromptConfirmArrived(context, () {
            widget.orderController.arrivedOrder(
              ArrivedOrderParameter(
                combinedOrderId: order.id
              )
            );
          }),
          onBuyAgainTap: (order) => widget.orderController.repurchaseControllerContentDelegate.repurchase(order.id),
          onUpdateState: () => setState(() {}),
          orderTabColorfulChipTabBarController: _orderTabColorfulChipTabBarController,
          orderColorfulChipTabBarDataList: _orderColorfulChipTabBarDataList,
          errorProvider: Injector.locator<ErrorProvider>(),
          orderContainerStateStorageListItemControllerState: DefaultOrderContainerStateStorageListItemControllerState(),
          orderContainerInterceptingActionListItemControllerState: _defaultOrderContainerInterceptingActionListItemControllerState
        )
      ];
      return SuccessLoadDataResult<PagingDataResult<ListItemControllerState>>(
        value: PagingDataResult<ListItemControllerState>(
          itemList: resultListItemControllerState,
          page: 1,
          totalPage: 2,
          totalItem: 0
        )
      );
    } else {
      int effectivePageKey = pageKey - 1;
      LoadDataResult<PagingDataResult<CombinedOrder>> orderPagingLoadDataResult = await widget.orderController.getOrderPaging(
        OrderPagingParameter(page: effectivePageKey, status: _status)
      );
      if (orderPagingLoadDataResult.isSuccess && effectivePageKey == 1) {
        List itemList = orderPagingLoadDataResult.resultIfSuccess!.itemList;
        if (itemList.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            _fillerErrorValueNotifier.value = FailedLoadDataResult.throwException(() {
              throw ErrorHelper.generateMultiLanguageDioError(
                MultiLanguageMessageError(
                  title: MultiLanguageString({
                    Constant.textEnUsLanguageKey: "Cart Item Is Empty",
                    Constant.textInIdLanguageKey: "Order Kosong",
                  }),
                  message: MultiLanguageString({
                    Constant.textEnUsLanguageKey: "For now, cart Item is empty.",
                    Constant.textInIdLanguageKey: "Untuk sekarang, ordernya kosong.",
                  }),
                )
              );
            })!.e;
          });
        }
      }
      return orderPagingLoadDataResult.map<PagingResult<ListItemControllerState>>((orderPaging) {
        if (ListItemControllerStateHelper.checkListItemControllerStateList(orderListItemControllerStateList)) {
          OrderContainerListItemControllerState orderContainerListItemControllerState = ListItemControllerStateHelper.parsePageKeyedListItemControllerState(orderListItemControllerStateList![0]) as OrderContainerListItemControllerState;
          orderContainerListItemControllerState.orderList.addAll(orderPaging.itemList);
        }
        return PagingDataResult<ListItemControllerState>(
          itemList: resultListItemControllerState,
          page: orderPaging.page,
          totalPage: orderPaging.totalPage,
          totalItem: orderPaging.totalItem
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.orderController.repurchaseControllerContentDelegate.setRepurchaseDelegate(
      Injector.locator<RepurchaseDelegateFactory>().generateRepurchaseDelegate(
        onGetBuildContext: () => context,
        onGetErrorProvider: () => Injector.locator<ErrorProvider>()
      )
    );
    widget.orderController.setOrderDelegate(
      OrderDelegate(
        onUnfocusAllWidget: () => FocusScope.of(context).unfocus(),
        onBack: () => Get.back(),
        onShowArrivedOrderProcessLoadingCallback: () async => DialogHelper.showLoadingDialog(context),
        onArrivedOrderProcessSuccessCallback: (arrivedOrderResponse) async {
          int index = 0;
          for (int i = 0; i < _orderColorfulChipTabBarDataList.length; i++) {
            ColorfulChipTabBarData colorfulChipTabBarData = _orderColorfulChipTabBarDataList[i];
            if (colorfulChipTabBarData.data is String) {
              String dataString = colorfulChipTabBarData.data as String;
              if (dataString.toLowerCase() == "sampai tujuan") {
                index = i;
                break;
              }
            }
          }
          _orderTabColorfulChipTabBarController.value = index;
        },
        onShowArrivedOrderProcessFailedCallback: (e) async => DialogHelper.showFailedModalBottomDialogFromErrorProvider(
          context: context,
          errorProvider: Injector.locator<ErrorProvider>(),
          e: e
        ),
      )
    );
    return ModifiedScaffold(
      appBar: ModifiedAppBar(
        titleInterceptor: (context, title) => Row(
          children: [
            Text("Transaction".tr),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
                pagingControllerState: _orderListItemPagingControllerState,
                onProvidePagedChildBuilderDelegate: (pagingControllerState) => ListItemPagingControllerStatePagedChildBuilderDelegate<int>(
                  pagingControllerState: pagingControllerState!
                ),
                onGetErrorProvider: () => Injector.locator<ErrorProvider>(),
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
    MainRouteObserver.onRefreshOrderList = null;
    super.dispose();
  }
}