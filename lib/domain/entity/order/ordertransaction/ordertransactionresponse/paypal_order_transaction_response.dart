import 'order_transaction_response.dart';

class PaypalOrderTransactionResponse extends OrderTransactionResponse {
  String status;
  String? selfLink;
  String? approveLink;

  @override
  String get transactionStatus => status;

  PaypalOrderTransactionResponse({
    required this.status,
    required this.selfLink,
    required super.paymentType,
    required super.paymentStepType,
    required super.orderTransactionSummary,
    required super.paymentInstructionTransactionSummary
  });
}