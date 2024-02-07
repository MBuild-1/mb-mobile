import '../../../../domain/entity/order/ordertransaction/ordertransactionresponse/order_transaction_response.dart';
import '../../../additionalsummarywidgetparameter/order_transaction_additional_summary_widget_parameter.dart';
import '../../../errorprovider/error_provider.dart';
import '../../../load_data_result.dart';
import '../list_item_controller_state.dart';

class OrderTransactionListItemControllerState extends ListItemControllerState {
  LoadDataResult<OrderTransactionResponse> orderTransactionResponseLoadDataResult;
  OrderTransactionAdditionalSummaryWidgetParameter Function() orderTransactionAdditionalSummaryWidgetParameter;
  ErrorProvider Function() errorProvider;

  OrderTransactionListItemControllerState({
    required this.orderTransactionResponseLoadDataResult,
    required this.orderTransactionAdditionalSummaryWidgetParameter,
    required this.errorProvider
  });
}