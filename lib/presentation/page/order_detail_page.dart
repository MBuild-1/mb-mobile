import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/navigator_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:masterbagasi/presentation/page/web_viewer_page.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../../controller/order_detail_controller.dart';
import '../../domain/entity/address/shipper_address.dart';
import '../../domain/entity/order/arrived_order_request.dart';
import '../../domain/entity/order/modifywarehouseinorder/modifywarehouseinorderparameter/remove_warehouse_in_order_parameter.dart';
import '../../domain/entity/order/modifywarehouseinorder/modifywarehouseinorderresponse/modify_warehouse_in_order_response.dart';
import '../../domain/entity/order/order.dart';
import '../../domain/entity/order/order_based_id_parameter.dart';
import '../../domain/entity/order/ordertransaction/ordertransactionresponse/order_transaction_response.dart';
import '../../domain/entity/payment/payment_method.dart';
import '../../domain/entity/payment/shippingpayment/shipping_payment_parameter.dart';
import '../../domain/entity/summaryvalue/summary_value.dart';
import '../../domain/usecase/add_warehouse_in_order_use_case.dart';
import '../../domain/usecase/get_order_based_id_use_case.dart';
import '../../domain/usecase/order_transaction_use_case.dart';
import '../../domain/usecase/shipper_address_use_case.dart';
import '../../domain/usecase/shipping_payment_use_case.dart';
import '../../misc/additionalsummarywidgetparameter/order_transaction_additional_summary_widget_parameter.dart';
import '../../misc/constant.dart';
import '../../misc/controllercontentdelegate/arrived_order_controller_content_delegate.dart';
import '../../misc/controllercontentdelegate/repurchase_controller_content_delegate.dart';
import '../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/load_data_result_dynamic_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/orderlistitemcontrollerstate/order_detail_container_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/orderlistitemcontrollerstate/order_shipper_address_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/orderlistitemcontrollerstate/order_transaction_list_item_controller_state.dart';
import '../../misc/controllerstate/paging_controller_state.dart';
import '../../misc/countdown/configuration/orderdetail/order_detail_configure_countdown_component.dart';
import '../../misc/countdown/configuration/orderdetail/orderdetailsummaryvaluesource/order_detail_summary_value_source.dart';
import '../../misc/countdown/configuration/orderdetail/orderdetailsummaryvaluesource/payment_instruction_order_detail_summary_value_source.dart';
import '../../misc/countdown/countdown_component.dart';
import '../../misc/countdown/countdown_component_data.dart';
import '../../misc/countdown/countdown_component_delegate.dart';
import '../../misc/countdown/countdown_manager.dart';
import '../../misc/countdown/get_countdown_component_data_action.dart';
import '../../misc/date_util.dart';
import '../../misc/dialog_helper.dart';
import '../../misc/entityandlistitemcontrollerstatemediator/horizontal_component_entity_parameterized_entity_and_list_item_controller_state_mediator.dart';
import '../../misc/error/message_error.dart';
import '../../misc/errorprovider/error_provider.dart';
import '../../misc/getextended/get_extended.dart';
import '../../misc/getextended/get_restorable_route_future.dart';
import '../../misc/http_client.dart';
import '../../misc/injector.dart';
import '../../misc/load_data_result.dart';
import '../../misc/main_route_observer.dart';
import '../../misc/manager/controller_manager.dart';
import '../../misc/multi_language_string.dart';
import '../../misc/navigation_helper.dart';
import '../../misc/page_restoration_helper.dart';
import '../../misc/paging/modified_paging_controller.dart';
import '../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/paging/pagingresult/paging_result.dart';
import '../../misc/parameterizedcomponententityandlistitemcontrollerstatemediatorparameter/horizontal_dynamic_item_carousel_parametered_component_entity_and_list_item_controller_state_mediator_parameter.dart';
import '../../misc/pusher_helper.dart';
import '../../misc/routeargument/order_detail_route_argument.dart';
import '../../misc/shipper_address_process_additional_parameter.dart';
import '../../misc/string_util.dart';
import '../../misc/temp_order_detail_back_result_data_helper.dart';
import '../../misc/toast_helper.dart';
import '../../misc/widgetbindingobserver/payment_widget_binding_observer.dart';
import '../widget/button/custombutton/sized_outline_gradient_button.dart';
import '../widget/colorful_chip_tab_bar.dart';
import '../widget/countdown_indicator.dart';
import '../widget/modified_paged_list_view.dart';
import '../widget/modified_scaffold.dart';
import '../widget/modifiedappbar/modified_app_bar.dart';
import 'coupon_page.dart';
import 'getx_page.dart';
import 'modaldialogpage/modify_warehouse_in_order_modal_dialog_page.dart';
import 'modaldialogpage/payment_instruction_modal_dialog_page.dart';
import 'modaldialogpage/payment_parameter_modal_dialog_page.dart';
import 'order_chat_page.dart';
import 'payment_instruction_page.dart';
import 'payment_method_page.dart';
import 'pdf_viewer_page.dart';

class OrderDetailPage extends RestorableGetxPage<_OrderDetailPageRestoration> {
  late final ControllerMember<OrderDetailController> _orderDetailController = ControllerMember<OrderDetailController>().addToControllerManager(controllerManager);

  final OrderDetailPageParameter orderDetailPageParameter;
  final _StatefulDeliveryControllerMediatorWidgetDelegate _statefulDeliveryControllerMediatorWidgetDelegate = _StatefulDeliveryControllerMediatorWidgetDelegate();

  OrderDetailPage({
    Key? key,
    required this.orderDetailPageParameter
  }) : super(key: key, pageRestorationId: () => "order-detail-page");

  @override
  void onSetController() {
    _orderDetailController.controller = GetExtended.put<OrderDetailController>(
      OrderDetailController(
        controllerManager,
        Injector.locator<GetOrderBasedIdUseCase>(),
        Injector.locator<ModifyWarehouseInOrderUseCase>(),
        Injector.locator<OrderTransactionUseCase>(),
        Injector.locator<ShippingPaymentUseCase>(),
        Injector.locator<ShipperAddressUseCase>(),
        Injector.locator<RepurchaseControllerContentDelegate>(),
        Injector.locator<ArrivedOrderControllerContentDelegate>()
      ),
      tag: pageName
    );
  }

  @override
  _OrderDetailPageRestoration createPageRestoration() => _OrderDetailPageRestoration(
    onCompleteSelectPaymentMethod: (result) {
      if (result != null) {
        if (_statefulDeliveryControllerMediatorWidgetDelegate.onRefreshPaymentMethod != null) {
          _statefulDeliveryControllerMediatorWidgetDelegate.onRefreshPaymentMethod!(result.toPaymentMethodPageResponse().paymentMethod);
        }
      }
    },
    onCompleteSelectCoupon: (result) {
      if (result != null) {
        if (_statefulDeliveryControllerMediatorWidgetDelegate.onRefreshCouponId != null) {
          _statefulDeliveryControllerMediatorWidgetDelegate.onRefreshCouponId!(result);
        }
      }
    }
  );

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulOrderDetailControllerMediatorWidget(
      orderDetailController: _orderDetailController.controller,
      orderDetailPageParameter: orderDetailPageParameter,
      statefulDeliveryControllerMediatorWidgetDelegate: _statefulDeliveryControllerMediatorWidgetDelegate
    );
  }
}

class _OrderDetailPageRestoration extends ExtendedMixableGetxPageRestoration with WebViewerPageRestorationMixin, OrderChatPageRestorationMixin, PdfViewerPageRestorationMixin, PaymentInstructionPageRestorationMixin, PaymentMethodPageRestorationMixin, CouponPageRestorationMixin {
  final RouteCompletionCallback<String?>? _onCompleteSelectPaymentMethod;
  final RouteCompletionCallback<String?>? _onCompleteSelectCoupon;

  _OrderDetailPageRestoration({
    RouteCompletionCallback<String?>? onCompleteSelectPaymentMethod,
    RouteCompletionCallback<String?>? onCompleteSelectCoupon
  }) : _onCompleteSelectPaymentMethod = onCompleteSelectPaymentMethod,
      _onCompleteSelectCoupon = onCompleteSelectCoupon;

  @override
  // ignore: unnecessary_overrides
  void initState() {
    onCompleteSelectPaymentMethod = _onCompleteSelectPaymentMethod;
    onCompleteSelectCoupon = _onCompleteSelectCoupon;
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

class OrderDetailPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  final OrderDetailPageParameter orderDetailPageParameter;

  OrderDetailPageGetPageBuilderAssistant({
    required this.orderDetailPageParameter
  });

  @override
  GetPageBuilder get pageBuilder => (() => OrderDetailPage(orderDetailPageParameter: orderDetailPageParameter));

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(OrderDetailPage(orderDetailPageParameter: orderDetailPageParameter)));
}

mixin OrderDetailPageRestorationMixin on MixableGetxPageRestoration {
  RouteCompletionCallback<String?>? onCompleteOrderDetailPage;

  late OrderDetailPageRestorableRouteFuture orderDetailPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    orderDetailPageRestorableRouteFuture = OrderDetailPageRestorableRouteFuture(
      restorationId: restorationIdWithPageName('order-detail-route'),
      onComplete: onCompleteOrderDetailPage
    );
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    orderDetailPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    orderDetailPageRestorableRouteFuture.dispose();
  }
}

class OrderDetailPageRestorableRouteFuture extends GetRestorableRouteFuture {
  final RouteCompletionCallback<String?>? onComplete;

  late RestorableRouteFuture<String?> _pageRoute;

  OrderDetailPageRestorableRouteFuture({
    required String restorationId,
    this.onComplete
  }) : super(restorationId: restorationId) {
    _pageRoute = RestorableRouteFuture<String?>(
      onPresent: (NavigatorState navigator, Object? arguments) {
        return navigator.restorablePush(_pageRouteBuilder, arguments: arguments);
      },
      onComplete: onComplete
    );
  }

  static Route<String?>? _getRoute([Object? arguments]) {
    if (arguments is! String) {
      throw Exception("Arguments must be a string");
    }
    OrderDetailPageParameter? orderDetailPageParameter;
    try {
      orderDetailPageParameter = arguments.toOrderDetailPageParameter();
    } catch (e) {
      bool handlingError = false;
      if (e is MessageError) {
        if (e.title.toLowerCase() == Constant.textErrorTitleWhenParsingOrderParameterJson.toLowerCase()) {
          orderDetailPageParameter = DefaultOrderDetailPageParameter(
            combinedOrderId: arguments
          );
          handlingError = true;
        }
      }
      if (!handlingError) {
        if (orderDetailPageParameter == null) {
          rethrow;
        }
      }
    }
    return GetExtended.toWithGetPageRouteReturnValue<String?>(
      GetxPageBuilder.buildRestorableGetxPageBuilder(
        OrderDetailPageGetPageBuilderAssistant(
          orderDetailPageParameter: orderDetailPageParameter!
        ),
      ),
      arguments: OrderDetailRouteArgument()
    );
  }

  @pragma('vm:entry-point')
  static Route<String?> _pageRouteBuilder(BuildContext context, Object? arguments) {
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

class _StatefulDeliveryControllerMediatorWidgetDelegate {
  void Function(PaymentMethod)? onRefreshPaymentMethod;
  void Function(String)? onRefreshCouponId;
}

class _StatefulOrderDetailControllerMediatorWidget extends StatefulWidget {
  final OrderDetailController orderDetailController;
  final OrderDetailPageParameter orderDetailPageParameter;
  final _StatefulDeliveryControllerMediatorWidgetDelegate statefulDeliveryControllerMediatorWidgetDelegate;

  const _StatefulOrderDetailControllerMediatorWidget({
    required this.orderDetailController,
    required this.orderDetailPageParameter,
    required this.statefulDeliveryControllerMediatorWidgetDelegate
  });

  @override
  State<_StatefulOrderDetailControllerMediatorWidget> createState() => _StatefulOrderDetailControllerMediatorWidgetState();
}

class _StatefulOrderDetailControllerMediatorWidgetState extends State<_StatefulOrderDetailControllerMediatorWidget> {
  late final ScrollController _orderDetailScrollController;
  late final ModifiedPagingController<int, ListItemControllerState> _orderDetailListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _orderDetailListItemPagingControllerState;
  String? _combinedOrderId;
  void Function(ModifyWarehouseInOrderResponse)? _closeWithResultModifyWarehouseInOrderModalDialogPage;
  void Function(Exception)? _errorModifyWarehouseInOrder;
  double? _orderDetailScrollOffset;
  final List<BaseLoadDataResultDynamicListItemControllerState> _dynamicItemLoadDataResultDynamicListItemControllerStateList = [];
  final CountdownManager _countdownManager = CountdownManager(countdownComponentList: []);
  LoadDataResult<_LoadOrderDetailResponse> _loadOrderDetailResponseLoadDataResult = NoLoadDataResult<_LoadOrderDetailResponse>();
  late final OrderTransactionAdditionalSummaryWidgetParameter _orderTransactionAdditionalSummaryWidgetParameter;
  late final ShipperAddressProcessAdditionalParameter _shipperAddressProcessAdditionalParameter;
  PaymentWidgetBindingObserver? _paymentWidgetBindingObserver;
  bool _isCheckingOrderTransaction = false;
  final PusherChannelsFlutter _pusher = PusherChannelsFlutter.getInstance();
  final PaymentParameterModalDialogPageDelegate _repurchasePaymentParameterModalDialogPageDelegate = PaymentParameterModalDialogPageDelegate();
  final PaymentParameterModalDialogPageDelegate _payOrderShippingPaymentParameterModalDialogPageDelegate = PaymentParameterModalDialogPageDelegate();
  OrderDetailPaymentMethodType? _orderDetailPaymentMethodType;

  @override
  void initState() {
    super.initState();
    _orderDetailScrollController = ScrollController();
    _orderDetailListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.orderDetailController.apiRequestManager,
    );
    _orderDetailListItemPagingControllerState = PagingControllerState(
      pagingController: _orderDetailListItemPagingController,
      scrollController: _orderDetailScrollController,
      isPagingControllerExist: false
    );
    _orderDetailListItemPagingControllerState.pagingController.addPageRequestListenerWithItemListForLoadDataResult(
      listener: _orderDetailListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _orderDetailListItemPagingControllerState.isPagingControllerExist = true;
    _orderTransactionAdditionalSummaryWidgetParameter = OrderTransactionAdditionalSummaryWidgetParameter(
      onRefreshOrderDetail: _refreshOrderDetail,
      orderTransactionResponseLoadDataResult: NoLoadDataResult<OrderTransactionResponse>(),
      paymentInstructionModalDialogPageDelegate: PaymentInstructionModalDialogPageDelegate(),
      onGetErrorProvider: () => Injector.locator<ErrorProvider>(),
      onSuccess: () {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          ToastHelper.showToast("Payment Success".tr);
          _orderDetailScrollController.jumpTo(0);
        });
      }
    );
    _shipperAddressProcessAdditionalParameter = ShipperAddressProcessAdditionalParameter(
      shipperAddressLoadDataResult: NoLoadDataResult<ShipperAddress>()
    );
    _paymentWidgetBindingObserver = PaymentWidgetBindingObserver(
      checkOrderTransactionWhileResuming: _refreshOrderDetail
    );
    widget.statefulDeliveryControllerMediatorWidgetDelegate.onRefreshPaymentMethod = (paymentMethod) {
      if (_orderDetailPaymentMethodType == OrderDetailPaymentMethodType.repurchase) {
        _repurchasePaymentParameterModalDialogPageDelegate.onUpdatePaymentMethod(paymentMethod);
      } else if (_orderDetailPaymentMethodType == OrderDetailPaymentMethodType.shippingPayment) {
        _payOrderShippingPaymentParameterModalDialogPageDelegate.onUpdatePaymentMethod(paymentMethod);
      }
      _orderDetailPaymentMethodType = null;
    };
    widget.statefulDeliveryControllerMediatorWidgetDelegate.onRefreshCouponId = (couponId) {
      _repurchasePaymentParameterModalDialogPageDelegate.onUpdateCoupon(couponId);
    };
    WidgetsBinding.instance.addObserver(_paymentWidgetBindingObserver!);
    MainRouteObserver.onRefreshOrderDetailAfterDeliveryReview = _refreshOrderDetail;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      OrderDetailPageParameter orderDetailPageParameter = widget.orderDetailPageParameter;
      if (orderDetailPageParameter is RedirectToShippingPaymentOrderDetailPageParameter) {
        _payOrderShipping();
      }
    });
  }

  Future<LoadDataResult<_LoadOrderDetailResponse>> _loadOrderDetail() async {
    _countdownManager.dispose();
    _dynamicItemLoadDataResultDynamicListItemControllerStateList.clear();
    HorizontalComponentEntityParameterizedEntityAndListItemControllerStateMediator componentEntityMediator = Injector.locator<HorizontalComponentEntityParameterizedEntityAndListItemControllerStateMediator>();
    HorizontalDynamicItemCarouselParameterizedEntityAndListItemControllerStateMediatorParameter carouselParameterizedEntityMediator = HorizontalDynamicItemCarouselParameterizedEntityAndListItemControllerStateMediatorParameter(
      onSetState: () => setState(() {}),
      dynamicItemLoadDataResultDynamicListItemControllerStateList: _dynamicItemLoadDataResultDynamicListItemControllerStateList
    );
    double? tempScrollOffset;
    if (_orderDetailScrollOffset != null) {
      tempScrollOffset = _orderDetailScrollOffset;
      _orderDetailScrollOffset = null;
    }
    LoadDataResult<Order> orderDetailLoadDataResult = await widget.orderDetailController.getOrderBasedId(
      OrderBasedIdParameter(orderId: widget.orderDetailPageParameter.combinedOrderId)
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (orderDetailLoadDataResult.isSuccess) {
        _combinedOrderId = orderDetailLoadDataResult.resultIfSuccess!.combinedOrder.id;
        setState(() {});
        if (tempScrollOffset != null) {
          _orderDetailScrollController.jumpTo(tempScrollOffset);
        }
      }
    });
    if (orderDetailLoadDataResult.isSuccess) {
      Order orderDetail = orderDetailLoadDataResult.resultIfSuccess!;
      String orderId = orderDetail.combinedOrder.orderProduct.orderId;
      try {
        await PusherHelper.unsubscribeTransactionSuccessPusherChannel(
          pusherChannelsFlutter: _pusher,
          orderId: orderId
        );
      } catch (e) {
        // No action something
      }
      await PusherHelper.subscribeTransactionSuccessPusherChannel(
        pusherChannelsFlutter: _pusher,
        onEvent: _onEvent,
        orderId: orderId,
      );
    }
    return orderDetailLoadDataResult.map<_LoadOrderDetailResponse>((orderDetail) {
      ListItemControllerState orderTransactionListItemControllerState = componentEntityMediator.mapWithParameter(
        () {
          late String orderId;
          if (orderDetail.combinedOrder.orderShipping != null) {
            orderId = orderDetail.combinedOrder.orderShipping!.orderId;
          } else {
            orderId = orderDetail.combinedOrder.orderProduct.orderId;
          }
          return widget.orderDetailController.getOrderTransactionSection(orderId);
        }(),
        parameter: carouselParameterizedEntityMediator
      );
      ListItemControllerState shipperAddressListItemControllerState = componentEntityMediator.mapWithParameter(
        widget.orderDetailController.getShipperAddressSection(),
        parameter: carouselParameterizedEntityMediator
      );
      return _LoadOrderDetailResponse(
        order: orderDetail,
        orderTransactionListItemControllerState: orderTransactionListItemControllerState,
        shipperAddressListItemControllerState: shipperAddressListItemControllerState
      );
    });
  }

  Future<void> _refreshOrderDetail() async {
    if (!_isCheckingOrderTransaction) {
      _isCheckingOrderTransaction = true;
      DialogHelper.showLoadingDialog(context);
      LoadDataResult<_LoadOrderDetailResponse> loadOrderDetailResponseLoadDataResult = await _loadOrderDetail();
      if (loadOrderDetailResponseLoadDataResult.isSuccess && _loadOrderDetailResponseLoadDataResult.isSuccess) {
        _LoadOrderDetailResponse oldLoadOrderDetailResponse = _loadOrderDetailResponseLoadDataResult.resultIfSuccess!;
        _LoadOrderDetailResponse newLoadOrderDetailResponse = loadOrderDetailResponseLoadDataResult.resultIfSuccess!;
        oldLoadOrderDetailResponse.merge(newLoadOrderDetailResponse);
        setState(() {});
        _orderTransactionAdditionalSummaryWidgetParameter.paymentInstructionModalDialogPageDelegate.onRefresh();
      }
      Get.back();
      _isCheckingOrderTransaction = false;
    }
  }

  dynamic _onEvent(dynamic event) {
    if (event is PusherEvent) {
      if (event.data is Map<String, dynamic>) {
        Map<String, dynamic> dataMap = event.data;
        if (dataMap.isNotEmpty) {
          _refreshOrderDetail();
        }
      }
    }
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _orderDetailListItemPagingControllerStateListener(int pageKey, List<ListItemControllerState>? orderDetailListItemControllerStateList) async {
    _loadOrderDetailResponseLoadDataResult = await _loadOrderDetail();
    return _loadOrderDetailResponseLoadDataResult.map<PagingResult<ListItemControllerState>>((loadOrderDetailResponse) {
      return PagingDataResult<ListItemControllerState>(
        itemList: <ListItemControllerState>[
          OrderDetailContainerListItemControllerState(
            order: () => loadOrderDetailResponse.order,
            onModifyWarehouseInOrder: (modifyWarehouseInOrderParameter) async {
              _closeWithResultModifyWarehouseInOrderModalDialogPage = null;
              _errorModifyWarehouseInOrder = null;
              if (modifyWarehouseInOrderParameter is RemoveWarehouseInOrderParameter) {
                widget.orderDetailController.modifyWarehouseInOrder(modifyWarehouseInOrderParameter);
                return;
              }
              dynamic result = await DialogHelper.showModalDialogPage<ModifyWarehouseInOrderResponse, ModifyWarehouseInOrderModalDialogPageParameter>(
                context: context,
                modalDialogPageBuilder: (context, parameter) => ModifyWarehouseInOrderModalDialogPage(
                  modifyWarehouseInOrderModalDialogPageParameter: parameter!,
                ),
                parameter: ModifyWarehouseInOrderModalDialogPageParameter(
                  modifyWarehouseInOrderParameter: modifyWarehouseInOrderParameter,
                  modifyWarehouseInOrderAction: ModifyWarehouseInOrderAction(
                    submitModifyWarehouse: (modifyWarehouseInOrderParameter, modifyWarehouseInOrderActionFurther) {
                      _closeWithResultModifyWarehouseInOrderModalDialogPage = modifyWarehouseInOrderActionFurther.closeWithResult;
                      _errorModifyWarehouseInOrder = modifyWarehouseInOrderActionFurther.showErrorDialog;
                      widget.orderDetailController.modifyWarehouseInOrder(modifyWarehouseInOrderParameter);
                    }
                  )
                )
              );
              if (result is ModifyWarehouseInOrderResponse) {
                _saveLastScrollOffsetAndRefresh();
              }
            },
            onBuyAgainTap: (order) {
              widget.orderDetailController.repurchaseControllerContentDelegate.repurchase(order.id);
            },
            onUpdateState: () => setState(() {}),
            onShowOrderListIsClosedDialog: () => DialogHelper.showOrderListIsClosed(context),
            onOpenOrderInvoice: (combinedOrder) {
              Dio dio = Injector.locator<Dio>();
              PageRestorationHelper.toPdfViewerPage(
                context, <String, dynamic>{
                  Constant.textUrlKey: "${dio.options.baseUrl}user/order/base64/${combinedOrder.id}?type=invoice",
                  Constant.textHeaderKey: () {
                    if (dio is GetCommonOptions) {
                      return (dio as GetCommonOptions).optionsWithTokenHeader.headers ?? <String, dynamic>{};
                    }
                    return <String, dynamic>{};
                  }(),
                  Constant.textFileNameKey: "${combinedOrder.orderCode}.pdf"
                }
              );
            },
            onPayOrderShipping: _payOrderShipping,
            orderTransactionListItemControllerState: () => loadOrderDetailResponse.orderTransactionListItemControllerState,
            shipperAddressListItemControllerState: () => loadOrderDetailResponse.shipperAddressListItemControllerState,
            errorProvider: () => Injector.locator<ErrorProvider>(),
            onConfirmArrived: (order) => DialogHelper.showPromptConfirmArrived(
              context, () {
                widget.orderDetailController.arrivedOrderControllerContentDelegate.arrivedOrder(
                  ArrivedOrderParameter(
                    combinedOrderId: order.id
                  )
                );
              }
            ),
          )
        ],
        page: 1,
        totalPage: 1,
        totalItem: 1
      );
    });
  }

  void _saveLastScrollOffsetAndRefresh() {
    _orderDetailScrollOffset = _orderDetailScrollController.offset;
    _orderDetailListItemPagingController.refresh();
  }

  void _toPaymentMethodPage(OrderDetailPaymentMethodType? orderDetailPaymentMethodType, String? paymentMethodSettlingId) {
    _orderDetailPaymentMethodType = orderDetailPaymentMethodType;
    PageRestorationHelper.toPaymentMethodPage(context, paymentMethodSettlingId);
  }

  void _payOrderShipping() {
    DialogHelper.showModalBottomDialogPage<int, int>(
      context: context,
      modalDialogPageBuilder: (context, parameter) => PaymentParameterModalDialogPage(
        paymentParameterModalDialogPageParameter: PaymentParameterModalDialogPageParameter(
          paymentParameterModalDialogPageDelegate: _payOrderShippingPaymentParameterModalDialogPageDelegate,
          onGotoSelectPaymentMethodPage: (paymentMethodSettlingId) {
            _toPaymentMethodPage(OrderDetailPaymentMethodType.shippingPayment, paymentMethodSettlingId);
          },
          onProcessPaymentParameter: (paymentMethodSettlingId, couponId) {
            widget.orderDetailController.shippingPayment(
              ShippingPaymentParameter(
                settlingId: paymentMethodSettlingId!,
                combinedOrderId: widget.orderDetailPageParameter.combinedOrderId,
                expire: 7
              )
            );
          },
          titleLabel: () => "Second Payment".tr,
          buttonLabel: () => "Pay".tr
        )
      ),
      parameter: 1
    );
  }

  @override
  Widget build(BuildContext context) {
    widget.orderDetailController.repurchaseControllerContentDelegate.setRepurchaseDelegate(
      Injector.locator<RepurchaseDelegateFactory>().generateRepurchaseDelegate(
        onGetBuildContext: () => context,
        onGetErrorProvider: () => Injector.locator<ErrorProvider>(),
        onBeginRepurchase: (repurchaseAction) {
          DialogHelper.showModalBottomDialogPage<int, int>(
            context: context,
            modalDialogPageBuilder: (context, parameter) => PaymentParameterModalDialogPage(
              paymentParameterModalDialogPageParameter: PaymentParameterModalDialogPageParameter(
                paymentParameterModalDialogPageDelegate: _repurchasePaymentParameterModalDialogPageDelegate,
                onGotoSelectPaymentMethodPage: (paymentMethodSettlingId) {
                  _toPaymentMethodPage(OrderDetailPaymentMethodType.repurchase, paymentMethodSettlingId);
                },
                onGotoSelectCouponPage: (couponId) {
                  PageRestorationHelper.toCouponPage(context, couponId);
                },
                onProcessPaymentParameter: (paymentMethodSettlingId, couponId) {
                  repurchaseAction.onStartRepurchase(paymentMethodSettlingId, couponId);
                },
                titleLabel: () => "Buy Again".tr,
                buttonLabel: () => "Buy Again".tr
              )
            ),
            parameter: 1
          );
        }
      )
    );
    widget.orderDetailController.arrivedOrderControllerContentDelegate.setArrivedOrderDelegate(
      Injector.locator<ArrivedOrderDelegateFactory>().generateArrivedOrderDelegate(
        onGetBuildContext: () => context,
        onGetErrorProvider: () => Injector.locator<ErrorProvider>(),
        onArrivedOrderProcessSuccessCallback: (arrivedOrderResponse) async {
          _refreshOrderDetail();
          if (MainRouteObserver.onRefreshOrderList != null) {
            MainRouteObserver.onRefreshOrderList!();
          }
        },
      )
    );
    widget.orderDetailController.setOrderDetailDelegate(
      OrderDetailDelegate(
        onUnfocusAllWidget: () => FocusScope.of(context).unfocus(),
        onOrderDetailBack: () => Get.back(),
        onShowModifyWarehouseInOrderRequestProcessLoadingCallback: () async => DialogHelper.showLoadingDialog(context),
        onShowModifyWarehouseInOrderRequestProcessFailedCallback: (e) async {
          if (_errorModifyWarehouseInOrder != null) {
            _errorModifyWarehouseInOrder!(e);
          } else {
            DialogHelper.showFailedModalBottomDialogFromErrorProvider(
              context: context,
              errorProvider: Injector.locator<ErrorProvider>(),
              e: e
            );
          }
        },
        onModifyWarehouseInOrderRequestProcessSuccessCallback: (modifyWarehouseInOrderResponse) async {
          if (_closeWithResultModifyWarehouseInOrderModalDialogPage != null) {
            _closeWithResultModifyWarehouseInOrderModalDialogPage!(modifyWarehouseInOrderResponse);
          } else {
            _saveLastScrollOffsetAndRefresh();
          }
        },
        onShowShippingPaymentRequestProcessLoadingCallback: () async => DialogHelper.showLoadingDialog(context),
        onShowShippingPaymentRequestProcessFailedCallback: (e) async {
          DialogHelper.showFailedModalBottomDialogFromErrorProvider(
            context: context,
            errorProvider: Injector.locator<ErrorProvider>(),
            e: e
          );
        },
        onShippingPaymentRequestProcessSuccessCallback: (shippingPaymentResponse) async {
          // Close payment parameter modal dialog page
          Get.back();

          _refreshOrderDetail();
          if (MainRouteObserver.onRefreshOrderList != null) {
            MainRouteObserver.onRefreshOrderList!();
          }
        },
        onObserveOrderTransactionDirectly: (onObserveOrderTransactionDirectlyParameter) {
          return OrderTransactionListItemControllerState(
            orderTransactionResponseLoadDataResult: onObserveOrderTransactionDirectlyParameter.orderTransactionResponseLoadDataResult,
            orderTransactionAdditionalSummaryWidgetParameter: () => _orderTransactionAdditionalSummaryWidgetParameter,
            errorProvider: () => Injector.locator<ErrorProvider>()
          );
        },
        onObserveShipperAddressDirectly: (onObserveShipperAddressDirectlyParameter) {
          return OrderShipperAddressListItemControllerState(
            shipperAddressLoadDataResult: onObserveShipperAddressDirectlyParameter.shipperAddressLoadDataResult,
            errorProvider: () => Injector.locator<ErrorProvider>()
          );
        },
        onGetErrorProvider: () => Injector.locator<ErrorProvider>(),
        onGetCountdownComponentDataAction: () {
          return GetCountdownComponentDataAction(
            onConfigureCountdownComponentToSummaryValue: (configureCountdownComponent) {
              if (configureCountdownComponent is OrderDetailConfigureCountdownComponent) {
                OrderDetailSummaryValueSource orderDetailSummaryValueSource = configureCountdownComponent.orderDetailSummaryValueSource;
                SummaryValue summaryValue = orderDetailSummaryValueSource.orderDetailSummaryValue;
                dynamic lastValue = summaryValue.value;
                summaryValue.type = "countdown_component";
                if (lastValue is Map<String, dynamic>) {
                  dynamic tagString = lastValue["tag_string"];
                  if (orderDetailSummaryValueSource is PaymentInstructionOrderDetailSummaryValueSource) {
                    List<SummaryValue> orderTransactionSummaryValueList = orderDetailSummaryValueSource.orderTransactionSummaryValueList;
                    for (var orderTransactionSummaryValue in orderTransactionSummaryValueList) {
                      dynamic orderTransactionSummaryValueContent = orderTransactionSummaryValue.value;
                      if (orderTransactionSummaryValueContent is DefaultCountdownComponentDelegate) {
                        dynamic orderTransactionSummaryValueContentTag = orderTransactionSummaryValueContent.tag;
                        if (orderTransactionSummaryValueContentTag is DefaultCountdownComponentDelegateTagData) {
                          if (orderTransactionSummaryValueContentTag.tagString == "expired_remaining") {
                            summaryValue.value = orderTransactionSummaryValue.value;
                          }
                        }
                      }
                    }
                  } else {
                    DateTime localExpiryDateTime = DateUtil.convertUtcOffset(
                      configureCountdownComponent.orderTransactionResponse.expiryDateTime,
                      DateTime.now().timeZoneOffset.inHours,
                      oldUtcOffset: 0
                    );
                    int countdownValue = () {
                      late int value;
                      if (tagString == "expired_remaining") {
                        value = localExpiryDateTime.difference(DateTime.now()).inMilliseconds;
                      } else {
                        value = lastValue["value"] as int;
                      }
                      if (value < 0) {
                        value = 0;
                      }
                      return value;
                    }();
                    dynamic tag = DefaultCountdownComponentDelegateTagData(
                      tagString: tagString,
                      paymentStepType: configureCountdownComponent.orderTransactionResponse.paymentStepType,
                      countdownValue: countdownValue,
                      expiredDateTime: localExpiryDateTime,
                      onRefresh: _refreshOrderDetail
                    );
                    configureCountdownComponent.countdownComponentData.milliseconds = countdownValue;
                    summaryValue.value = DefaultCountdownComponentDelegate(tag: tag);
                  }
                } else {
                  configureCountdownComponent.countdownComponentData.milliseconds = lastValue as int;
                  summaryValue.value = DefaultCountdownComponentDelegate();
                }
              }
            },
            onGetCountdownComponentDataAndDelegateList: (countdownComponentDataAndDelegateList) {
              _countdownManager.dispose();
              List<CountdownComponent> countdownComponentList = _countdownManager.countdownComponentList;
              for (var countdownComponentDataAndDelegate in countdownComponentDataAndDelegateList) {
                countdownComponentList.add(
                  CountdownComponent(
                    countdownComponentData: CountdownComponentData(
                      milliseconds: () {
                        CountdownComponentDelegate countdownComponentDelegate = countdownComponentDataAndDelegate.countdownComponentDelegate;
                        if (countdownComponentDelegate is DefaultCountdownComponentDelegate) {
                          dynamic tag = countdownComponentDelegate.tag;
                          if (tag is DefaultCountdownComponentDelegateTagData) {
                            return tag.countdownValue;
                          }
                        }
                        return countdownComponentDataAndDelegate.countdownComponentData.milliseconds;
                      }()
                    ),
                    onInstantiateTimer: (countdownComponentData) {
                      CountdownComponentDelegate countdownComponentDelegate = countdownComponentDataAndDelegate.countdownComponentDelegate;
                      if (countdownComponentDelegate is DefaultCountdownComponentDelegate) {
                        countdownComponentDelegate.countdownComponentData = () => countdownComponentData;
                      }
                      void onUpdateStateCountdown(CountdownComponentData countdownComponentData) {
                        countdownComponentDelegate.onUpdateState(countdownComponentData);
                      }
                      onUpdateStateCountdown(countdownComponentData);
                      return Timer.periodic(
                        const Duration(milliseconds: 100),
                        (timer) {
                          countdownComponentData.milliseconds -= 100;
                          countdownComponentData.checkLastAndCurrentDurationStringEquality(() {
                            onUpdateStateCountdown(countdownComponentData);
                          });
                          if (countdownComponentData.milliseconds <= 0) {
                            timer.cancel();
                            if (countdownComponentDelegate is DefaultCountdownComponentDelegate) {
                              dynamic tag = countdownComponentDelegate.tag;
                              if (tag is DefaultCountdownComponentDelegateTagData) {
                                if (tag.paymentStepType == "first_payment") {
                                  if (tag.tagString == "expired_remaining") {
                                    ToastHelper.showToast(
                                      MultiLanguageString({
                                        Constant.textInIdLanguageKey: "Pembayaran Anda sudah expired.",
                                        Constant.textEnUsLanguageKey: "Your payment is expired."
                                      }).toEmptyStringNonNull
                                    );
                                    TempOrderDetailBackResultDataHelper.saveTempOrderDetailBackResult(
                                      json.encode(
                                        <String, dynamic>{
                                          "combined_order_id": widget.orderDetailPageParameter.combinedOrderId,
                                          "status": "expired"
                                        }
                                      )
                                    ).future().then((value) {
                                      NavigationHelper.navigationBackFromOrderDetailToOrder(context);
                                    });
                                  }
                                }
                              }
                            }
                          }
                        }
                      );
                    }
                  )
                );
              }
            }
          );
        },
        orderTransactionAdditionalSummaryWidgetParameter: () => _orderTransactionAdditionalSummaryWidgetParameter,
        shipperAddressProcessAdditionalParameter: () => _shipperAddressProcessAdditionalParameter
      )
    );
    return ModifiedScaffold(
      appBar: ModifiedAppBar(
        titleInterceptor: (context, title) => Row(
          children: [
            Text("Transaction Detail".tr),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
                pagingControllerState: _orderDetailListItemPagingControllerState,
                onProvidePagedChildBuilderDelegate: (pagingControllerState) => ListItemPagingControllerStatePagedChildBuilderDelegate<int>(
                  pagingControllerState: pagingControllerState!
                ),
                pullToRefresh: true
              ),
            ),
            if (_combinedOrderId.isNotEmptyString) ...[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedOutlineGradientButton(
                        text: '',
                        width: double.infinity,
                        outlineGradientButtonType: OutlineGradientButtonType.solid,
                        onPressed: () => PageRestorationHelper.toOrderChatPage(_combinedOrderId!, context),
                        childInterceptor: (style) => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.chat, size: 16, color: Colors.white),
                            const SizedBox(width: 10),
                            Text(
                              "Order Chat".tr,
                              style: style,
                            )
                          ],
                        )
                      ),
                    ),
                  ],
                )
              )
            ]
          ]
        )
      ),
    );
  }

  @override
  void dispose() {
    if (_paymentWidgetBindingObserver != null) {
      WidgetsBinding.instance.removeObserver(_paymentWidgetBindingObserver!);
      _paymentWidgetBindingObserver = null;
    }
    _countdownManager.dispose();
    PusherHelper.unsubscribeTransactionSuccessPusherChannel(
      pusherChannelsFlutter: _pusher,
      orderId: widget.orderDetailPageParameter.combinedOrderId
    );
    MainRouteObserver.onRefreshOrderDetailAfterDeliveryReview = null;
    super.dispose();
  }
}

class _LoadOrderDetailResponse {
  Order order;
  ListItemControllerState orderTransactionListItemControllerState;
  ListItemControllerState shipperAddressListItemControllerState;

  _LoadOrderDetailResponse({
    required this.order,
    required this.orderTransactionListItemControllerState,
    required this.shipperAddressListItemControllerState
  });
}

extension on _LoadOrderDetailResponse {
  void merge(_LoadOrderDetailResponse newLoadOrderDetailResponse) {
    order = newLoadOrderDetailResponse.order;
    orderTransactionListItemControllerState = newLoadOrderDetailResponse.orderTransactionListItemControllerState;
    shipperAddressListItemControllerState = newLoadOrderDetailResponse.shipperAddressListItemControllerState;
  }
}

enum OrderDetailPaymentMethodType {
  shippingPayment, repurchase
}

abstract class OrderDetailPageParameter {
  String combinedOrderId;

  OrderDetailPageParameter({
    required this.combinedOrderId
  });
}

class DefaultOrderDetailPageParameter extends OrderDetailPageParameter {
  DefaultOrderDetailPageParameter({
    required super.combinedOrderId
  });
}

class RedirectToShippingPaymentOrderDetailPageParameter extends OrderDetailPageParameter {
  RedirectToShippingPaymentOrderDetailPageParameter({
    required super.combinedOrderId
  });
}

extension OrderDetailPageParameterExt on OrderDetailPageParameter {
  String toJsonString() => StringUtil.encodeJson(
    () {
      if (this is DefaultOrderDetailPageParameter) {
        DefaultOrderDetailPageParameter defaultOrderDetailPageParameter = this as DefaultOrderDetailPageParameter;
        return <String, dynamic>{
          "type": "default",
          "combined_order_id": defaultOrderDetailPageParameter.combinedOrderId
        };
      } else if (this is RedirectToShippingPaymentOrderDetailPageParameter) {
        RedirectToShippingPaymentOrderDetailPageParameter redirectToShippingPaymentOrderDetailPageParameter = this as RedirectToShippingPaymentOrderDetailPageParameter;
        return <String, dynamic>{
          "type": "redirect_to_shipping_payment",
          "combined_order_id": redirectToShippingPaymentOrderDetailPageParameter.combinedOrderId
        };
      }
      throw MessageError(title: "OrderDetailPageParameter is not suitable");
    }()
  );
}

extension OrderDetailPageParameterStringExt on String {
  OrderDetailPageParameter toOrderDetailPageParameter() {
    Map<String, dynamic> result = {};
    try {
      result = StringUtil.decodeJson(this);
    } catch (e) {
      throw MessageError(title: Constant.textErrorTitleWhenParsingOrderParameterJson);
    }
    if (result.containsKey("type")) {
      String type = result["type"];
      if (type == "default") {
        return DefaultOrderDetailPageParameter(
          combinedOrderId: result["combined_order_id"]
        );
      } else if (type == "redirect_to_shipping_payment") {
        return RedirectToShippingPaymentOrderDetailPageParameter(
          combinedOrderId: result["combined_order_id"],
        );
      }
      throw MessageError(title: "\"type\" field is not suitable");
    } else {
      throw MessageError(title: "\"type\" field is missing");
    }
  }
}