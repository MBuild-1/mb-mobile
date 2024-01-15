import 'payment_instruction_group.dart';
import 'paymentinstructiontransactionsummary/payment_instruction_transaction_summary.dart';

class PaymentInstructionResponse {
  PaymentInstructionTransactionSummary paymentInstructionTransactionSummary;
  List<PaymentInstructionGroup> paymentInstructionGroupList;

  PaymentInstructionResponse({
    required this.paymentInstructionTransactionSummary,
    required this.paymentInstructionGroupList
  });
}