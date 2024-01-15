import 'package:masterbagasi/misc/ext/summary_value_ext.dart';

import '../../domain/entity/order/ordertransaction/ordertransactionsummary/order_transaction_summary.dart';

extension OrderTransactionSummaryExt on OrderTransactionSummary {
  List<Map<String, dynamic>> toJsonListMap() {
    return orderTransactionSummaryValueList.map<Map<String, dynamic>>(
      (summaryValue) => summaryValue.toJsonMap()
    ).toList();
  }
}