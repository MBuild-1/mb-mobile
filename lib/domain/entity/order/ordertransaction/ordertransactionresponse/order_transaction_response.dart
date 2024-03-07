import '../../../payment/paymentinstruction/paymentinstructiontransactionsummary/payment_instruction_transaction_summary.dart';
import '../ordertransactionsummary/order_transaction_summary.dart';

abstract class OrderTransactionResponse {
  String get transactionStatus;
  DateTime? get expiryDateTime => null;
  String paymentType;
  String paymentStepType;
  OrderTransactionSummary orderTransactionSummary;
  PaymentInstructionTransactionSummary paymentInstructionTransactionSummary;

  OrderTransactionResponse({
    required this.paymentType,
    required this.paymentStepType,
    required this.orderTransactionSummary,
    required this.paymentInstructionTransactionSummary
  });
}