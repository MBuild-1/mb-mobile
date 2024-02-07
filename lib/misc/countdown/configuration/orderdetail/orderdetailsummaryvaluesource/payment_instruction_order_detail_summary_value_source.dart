import '../../../../../domain/entity/summaryvalue/summary_value.dart';
import 'order_detail_summary_value_source.dart';

class PaymentInstructionOrderDetailSummaryValueSource extends OrderDetailSummaryValueSource {
  List<SummaryValue> paymentTransactionOrderTransactionSummaryValueList;

  PaymentInstructionOrderDetailSummaryValueSource({
    required super.orderDetailSummaryValue,
    required super.orderTransactionSummaryValueList,
    required this.paymentTransactionOrderTransactionSummaryValueList
  });
}