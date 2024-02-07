import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../../domain/entity/order/ordertransaction/ordertransactionresponse/order_transaction_response.dart';
import '../../presentation/page/modaldialogpage/payment_instruction_modal_dialog_page.dart';
import '../errorprovider/error_provider.dart';
import '../load_data_result.dart';
import 'additional_summary_widget_parameter.dart';

class OrderTransactionAdditionalSummaryWidgetParameter extends AdditionalSummaryWidgetParameter {
  void Function() onRefreshOrderDetail;
  ErrorProvider Function() onGetErrorProvider;
  PaymentInstructionModalDialogPageDelegate paymentInstructionModalDialogPageDelegate;
  void Function() onSuccess;

  LoadDataResult<OrderTransactionResponse> _orderTransactionResponseLoadDataResult;
  set orderTransactionResponseLoadDataResult(LoadDataResult<OrderTransactionResponse> orderTransactionResponseLoadDataResult) {
    _orderTransactionResponseLoadDataResult = orderTransactionResponseLoadDataResult;
    paymentInstructionModalDialogPageDelegate.onRefresh();
    if (_orderTransactionResponseLoadDataResult.isSuccess) {
      OrderTransactionResponse orderTransactionResponse = _orderTransactionResponseLoadDataResult.resultIfSuccess!;
      if (orderTransactionResponse.transactionStatus == "settlement") {
        paymentInstructionModalDialogPageDelegate.onSuccess();
        onSuccess();
      }
    }
  }
  LoadDataResult<OrderTransactionResponse> get orderTransactionResponseLoadDataResult {
    return _orderTransactionResponseLoadDataResult;
  }

  OrderTransactionAdditionalSummaryWidgetParameter({
    required this.onRefreshOrderDetail,
    required this.onGetErrorProvider,
    required this.paymentInstructionModalDialogPageDelegate,
    required this.onSuccess,
    required LoadDataResult<OrderTransactionResponse> orderTransactionResponseLoadDataResult,
  }) : _orderTransactionResponseLoadDataResult = orderTransactionResponseLoadDataResult;
}