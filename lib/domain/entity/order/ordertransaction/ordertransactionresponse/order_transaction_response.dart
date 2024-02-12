import 'dart:core';

import '../../../payment/paymentinstruction/paymentinstructiontransactionsummary/payment_instruction_transaction_summary.dart';
import '../ordertransactionsummary/order_transaction_summary.dart';

class OrderTransactionResponse {
  String paymentStepType;
  String orderId;
  String transactionId;
  String transactionStatus;
  double grossAmount;
  DateTime transactionDateTime;
  DateTime expiryDateTime;
  OrderTransactionSummary orderTransactionSummary;
  PaymentInstructionTransactionSummary paymentInstructionTransactionSummary;

  OrderTransactionResponse({
    required this.paymentStepType,
    required this.orderId,
    required this.transactionId,
    required this.transactionStatus,
    required this.grossAmount,
    required this.transactionDateTime,
    required this.expiryDateTime,
    required this.orderTransactionSummary,
    required this.paymentInstructionTransactionSummary
  });
}