import '../../../../../domain/entity/summaryvalue/summary_value.dart';

abstract class OrderDetailSummaryValueSource {
  SummaryValue orderDetailSummaryValue;
  List<SummaryValue> orderTransactionSummaryValueList;

  OrderDetailSummaryValueSource({
    required this.orderDetailSummaryValue,
    required this.orderTransactionSummaryValueList
  });
}