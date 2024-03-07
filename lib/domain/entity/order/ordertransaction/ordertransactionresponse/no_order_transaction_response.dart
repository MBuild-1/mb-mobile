import '../../../payment/paymentinstruction/paymentinstructiontransactionsummary/payment_instruction_transaction_summary.dart';
import '../ordertransactionsummary/order_transaction_summary.dart';
import 'order_transaction_response.dart';

class NoOrderTransactionResponse extends OrderTransactionResponse {
  NoOrderTransactionResponse(): super(
    paymentType: "",
    paymentStepType: "",
    orderTransactionSummary: OrderTransactionSummary(
      orderTransactionSummaryValueList: []
    ),
    paymentInstructionTransactionSummary: PaymentInstructionTransactionSummary(
      paymentInstructionTransactionSummaryValueList: []
    )
  );

  @override
  String get transactionStatus => "";
}