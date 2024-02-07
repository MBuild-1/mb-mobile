import 'package:flutter/material.dart';

import '../../domain/entity/summaryvalue/summary_value.dart';
import '../../misc/additionalsummarywidgetparameter/additional_summary_widget_parameter.dart';
import '../../misc/widget_helper.dart';

class TransactionSummaryWidget extends StatelessWidget {
  final List<SummaryValue> transactionSummaryValueList;
  final AdditionalSummaryWidgetParameter? additionalSummaryWidgetParameter;

  const TransactionSummaryWidget({
    super.key,
    required this.transactionSummaryValueList,
    this.additionalSummaryWidgetParameter
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> summaryWidgetList = WidgetHelper.summaryWidgetList(
      transactionSummaryValueList,
      additionalSummaryWidgetParameter: additionalSummaryWidgetParameter
    );
    if (summaryWidgetList.isEmpty) {
      for (int i = 0; i < transactionSummaryValueList.length; i++) {
        SummaryValue summaryValue = transactionSummaryValueList[i];
        String summaryValueType = summaryValue.type;
        if (summaryValueType == "") {

        }
      }
    }
    return Column(
      children: summaryWidgetList
    );
  }
}