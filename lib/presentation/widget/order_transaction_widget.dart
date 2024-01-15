import 'package:flutter/material.dart';

import '../../domain/entity/order/ordertransaction/ordertransactionresponse/order_transaction_response.dart';
import '../../misc/additionalsummarywidgetparameter/order_transaction_additional_summary_widget_parameter.dart';
import 'transaction_summary_widget.dart';

class OrderTransactionWidget extends StatelessWidget {
  final OrderTransactionResponse orderTransactionResponse;
  final OrderTransactionAdditionalSummaryWidgetParameter orderTransactionAdditionalSummaryWidgetParameter;

  const OrderTransactionWidget({
    super.key,
    required this.orderTransactionResponse,
    required this.orderTransactionAdditionalSummaryWidgetParameter
  });

  @override
  Widget build(BuildContext context) {
    return TransactionSummaryWidget(
      transactionSummaryValueList: orderTransactionResponse.orderTransactionSummary.orderTransactionSummaryValueList,
      additionalSummaryWidgetParameter: orderTransactionAdditionalSummaryWidgetParameter
    );
  }
}