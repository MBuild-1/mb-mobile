import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../domain/entity/componententity/dynamic_item_carousel_directly_component_entity.dart';
import '../domain/entity/componententity/i_dynamic_item_carousel_directly_component_entity.dart';
import '../domain/entity/order/modifywarehouseinorder/modifywarehouseinorderparameter/modify_warehouse_in_order_parameter.dart';
import '../domain/entity/order/modifywarehouseinorder/modifywarehouseinorderresponse/modify_warehouse_in_order_response.dart';
import '../domain/entity/order/order.dart';
import '../domain/entity/order/order_based_id_parameter.dart';
import '../domain/entity/order/ordertransaction/order_transaction_parameter.dart';
import '../domain/entity/order/ordertransaction/ordertransactionresponse/order_transaction_response.dart';
import '../domain/entity/payment/paymentinstruction/payment_instruction_response.dart';
import '../domain/entity/payment/paymentinstruction/paymentinstructiontransactionsummary/payment_instruction_transaction_summary.dart';
import '../domain/entity/summaryvalue/summary_value.dart';
import '../domain/usecase/add_warehouse_in_order_use_case.dart';
import '../domain/usecase/get_order_based_id_use_case.dart';
import '../domain/usecase/order_transaction_use_case.dart';
import '../misc/additionalsummarywidgetparameter/order_transaction_additional_summary_widget_parameter.dart';
import '../misc/controllercontentdelegate/repurchase_controller_content_delegate.dart';
import '../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../misc/countdown/configuration/orderdetail/order_detail_configure_countdown_component.dart';
import '../misc/countdown/configuration/orderdetail/orderdetailsummaryvaluesource/main_order_detail_summary_value_source.dart';
import '../misc/countdown/configuration/orderdetail/orderdetailsummaryvaluesource/payment_instruction_order_detail_summary_value_source.dart';
import '../misc/countdown/countdown_component_data.dart';
import '../misc/countdown/countdown_component_data_and_delegate.dart';
import '../misc/countdown/countdown_component_delegate.dart';
import '../misc/countdown/get_countdown_component_data_action.dart';
import '../misc/error/message_error.dart';
import '../misc/errorprovider/error_provider.dart';
import '../misc/load_data_result.dart';
import '../misc/multi_language_string.dart';
import '../misc/typedef.dart';
import 'base_getx_controller.dart';

typedef _OnOrderDetailBack = void Function();
typedef _OnShowModifyWarehouseInOrderRequestProcessLoadingCallback = Future<void> Function();
typedef _OnModifyWarehouseInOrderRequestProcessSuccessCallback = Future<void> Function(ModifyWarehouseInOrderResponse);
typedef _OnShowModifyWarehouseInOrderRequestProcessFailedCallback = Future<void> Function(dynamic e);

class OrderDetailController extends BaseGetxController {
  final GetOrderBasedIdUseCase getOrderBasedIdUseCase;
  final ModifyWarehouseInOrderUseCase modifyWarehouseInOrderUseCase;
  final OrderTransactionUseCase orderTransactionUseCase;
  final RepurchaseControllerContentDelegate repurchaseControllerContentDelegate;
  OrderDetailDelegate? _orderDetailDelegate;

  OrderDetailController(
    super.controllerManager,
    this.getOrderBasedIdUseCase,
    this.modifyWarehouseInOrderUseCase,
    this.orderTransactionUseCase,
    this.repurchaseControllerContentDelegate
  ) {
    repurchaseControllerContentDelegate.setApiRequestManager(
      () => apiRequestManager
    );
  }

  void modifyWarehouseInOrder(ModifyWarehouseInOrderParameter modifyWarehouseInOrderParameter) async {
    if (_orderDetailDelegate != null) {
      _orderDetailDelegate!.onShowModifyWarehouseInOrderRequestProcessLoadingCallback();
      LoadDataResult<ModifyWarehouseInOrderResponse> modifyWarehouseInOrderResponseLoadDataResult = await modifyWarehouseInOrderUseCase.execute(
        modifyWarehouseInOrderParameter
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart("modify-warehouse-in-order").value
      );
      if (modifyWarehouseInOrderResponseLoadDataResult.isFailedBecauseCancellation) {
        return;
      }
      _orderDetailDelegate!.onOrderDetailBack();
      if (modifyWarehouseInOrderResponseLoadDataResult.isSuccess) {
        _orderDetailDelegate!.onModifyWarehouseInOrderRequestProcessSuccessCallback(modifyWarehouseInOrderResponseLoadDataResult.resultIfSuccess!);
      } else {
        _orderDetailDelegate!.onShowModifyWarehouseInOrderRequestProcessFailedCallback(modifyWarehouseInOrderResponseLoadDataResult.resultIfFailed);
      }
    }
  }

  IDynamicItemCarouselDirectlyComponentEntity getOrderTransactionSection(String orderId) {
    return DynamicItemCarouselDirectlyComponentEntity(
      title: MultiLanguageString("Payment".tr),
      onDynamicItemAction: (title, description, observer) async {
        void updateOrderTransactionResponseLoadDataResult(LoadDataResult<OrderTransactionResponse> orderTransactionResponseLoadDataResult) {
          observer(title, description, orderTransactionResponseLoadDataResult);
          if (_orderDetailDelegate != null) {
            OrderTransactionAdditionalSummaryWidgetParameter orderTransactionAdditionalSummaryWidgetParameter = _orderDetailDelegate!.orderTransactionAdditionalSummaryWidgetParameter();
            orderTransactionAdditionalSummaryWidgetParameter.orderTransactionResponseLoadDataResult = orderTransactionResponseLoadDataResult;
          }
        }
        updateOrderTransactionResponseLoadDataResult(IsLoadingLoadDataResult<OrderTransactionResponse>());
        LoadDataResult<OrderTransactionResponse> orderTransactionResponsePagingDataResult = await orderTransactionUseCase.execute(
          OrderTransactionParameter(orderId: orderId)
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPart("delivery-review-list").value
        );
        if (orderTransactionResponsePagingDataResult.isFailedBecauseCancellation) {
          return;
        }
        if (orderTransactionResponsePagingDataResult.isSuccess) {
          if (_orderDetailDelegate != null) {
            OrderTransactionResponse orderTransactionResponse = orderTransactionResponsePagingDataResult.resultIfSuccess!;
            GetCountdownComponentDataAction getCountdownComponentDataAction = _orderDetailDelegate!.onGetCountdownComponentDataAction();
            List<CountdownComponentDataAndDelegate> countdownComponentDataAndDelegateList = [];
            List<SummaryValue> orderTransactionSummaryValueList = orderTransactionResponse.orderTransactionSummary.orderTransactionSummaryValueList;
            for (var summaryValue in orderTransactionResponse.orderTransactionSummary.orderTransactionSummaryValueList) {
              String summaryValueType = summaryValue.type;
              if (summaryValueType == "countdown") {
                CountdownComponentData countdownComponentData = CountdownComponentData(milliseconds: 0);
                OrderDetailConfigureCountdownComponent orderDetailConfigureCountdownComponent = OrderDetailConfigureCountdownComponent(
                  orderTransactionResponse: orderTransactionResponse,
                  orderDetailSummaryValueSource: MainOrderDetailSummaryValueSource(
                    orderDetailSummaryValue: summaryValue,
                    orderTransactionSummaryValueList: orderTransactionSummaryValueList
                  ),
                  countdownComponentData: countdownComponentData
                );
                getCountdownComponentDataAction.onConfigureCountdownComponentToSummaryValue(orderDetailConfigureCountdownComponent);
                countdownComponentDataAndDelegateList.add(
                  CountdownComponentDataAndDelegate(
                    countdownComponentData: countdownComponentData,
                    countdownComponentDelegate: summaryValue.value as CountdownComponentDelegate
                  )
                );
              }
            }
            List<SummaryValue> paymentInstructionTransactionSummaryValueList = orderTransactionResponse.paymentInstructionTransactionSummary.paymentInstructionTransactionSummaryValueList;
            for (var summaryValue in orderTransactionResponse.paymentInstructionTransactionSummary.paymentInstructionTransactionSummaryValueList) {
              String summaryValueType = summaryValue.type;
              if (summaryValueType == "countdown") {
                CountdownComponentData countdownComponentData = CountdownComponentData(milliseconds: 0);
                OrderDetailConfigureCountdownComponent orderDetailConfigureCountdownComponent = OrderDetailConfigureCountdownComponent(
                  orderTransactionResponse: orderTransactionResponse,
                  orderDetailSummaryValueSource: PaymentInstructionOrderDetailSummaryValueSource(
                    orderDetailSummaryValue: summaryValue,
                    orderTransactionSummaryValueList: orderTransactionSummaryValueList,
                    paymentTransactionOrderTransactionSummaryValueList: paymentInstructionTransactionSummaryValueList
                  ),
                  countdownComponentData: countdownComponentData
                );
                getCountdownComponentDataAction.onConfigureCountdownComponentToSummaryValue(orderDetailConfigureCountdownComponent);
              }
            }
            getCountdownComponentDataAction.onGetCountdownComponentDataAndDelegateList(countdownComponentDataAndDelegateList);
          }
          orderTransactionResponsePagingDataResult.resultIfSuccess!;
        }
        updateOrderTransactionResponseLoadDataResult(orderTransactionResponsePagingDataResult);
      },
      observeDynamicItemActionStateDirectly: (title, description, itemLoadDataResult, errorProvider) {
        LoadDataResult<OrderTransactionResponse> orderTransactionResponseLoadDataResult = itemLoadDataResult.castFromDynamic<OrderTransactionResponse>();
        if (_orderDetailDelegate != null) {
          return _orderDetailDelegate!.onObserveOrderTransactionDirectly(
            _OnObserveOrderTransactionDirectlyParameter(
              orderTransactionResponseLoadDataResult: orderTransactionResponseLoadDataResult
            )
          );
        } else {
          throw MessageError(title: "Order detail delegate must be not null");
        }
      },
    );
  }

  Future<LoadDataResult<Order>> getOrderBasedId(OrderBasedIdParameter orderBasedIdParameter) {
    return getOrderBasedIdUseCase.execute(orderBasedIdParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("order-detail").value
    );
  }

  OrderDetailController setOrderDetailDelegate(OrderDetailDelegate orderDetailDelegate) {
    _orderDetailDelegate = orderDetailDelegate;
    return this;
  }
}

class OrderDetailDelegate {
  OnUnfocusAllWidget onUnfocusAllWidget;
  _OnOrderDetailBack onOrderDetailBack;
  _OnShowModifyWarehouseInOrderRequestProcessLoadingCallback onShowModifyWarehouseInOrderRequestProcessLoadingCallback;
  _OnModifyWarehouseInOrderRequestProcessSuccessCallback onModifyWarehouseInOrderRequestProcessSuccessCallback;
  _OnShowModifyWarehouseInOrderRequestProcessFailedCallback onShowModifyWarehouseInOrderRequestProcessFailedCallback;
  ListItemControllerState Function(_OnObserveOrderTransactionDirectlyParameter) onObserveOrderTransactionDirectly;
  GetCountdownComponentDataAction Function() onGetCountdownComponentDataAction;
  ErrorProvider Function() onGetErrorProvider;
  OrderTransactionAdditionalSummaryWidgetParameter Function() orderTransactionAdditionalSummaryWidgetParameter;

  OrderDetailDelegate({
    required this.onUnfocusAllWidget,
    required this.onOrderDetailBack,
    required this.onShowModifyWarehouseInOrderRequestProcessLoadingCallback,
    required this.onModifyWarehouseInOrderRequestProcessSuccessCallback,
    required this.onShowModifyWarehouseInOrderRequestProcessFailedCallback,
    required this.onObserveOrderTransactionDirectly,
    required this.onGetCountdownComponentDataAction,
    required this.onGetErrorProvider,
    required this.orderTransactionAdditionalSummaryWidgetParameter
  });
}

class _OnObserveOrderTransactionDirectlyParameter {
  LoadDataResult<OrderTransactionResponse> orderTransactionResponseLoadDataResult;

  _OnObserveOrderTransactionDirectlyParameter({
    required this.orderTransactionResponseLoadDataResult
  });
}