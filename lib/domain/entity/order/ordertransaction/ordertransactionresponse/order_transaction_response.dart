import 'dart:core';

import '../../../payment/paymentinstruction/payment_instruction_group.dart';
import '../../../payment/paymentinstruction/paymentinstructiontransactionsummary/payment_instruction_transaction_summary.dart';
import '../ordertransactionsummary/order_transaction_summary.dart';

class OrderTransactionResponse {
  String orderId;
  String transactionId;
  double grossAmount;
  DateTime transactionDateTime;
  DateTime expiryDateTime;
  OrderTransactionSummary orderTransactionSummary;
  PaymentInstructionTransactionSummary paymentInstructionTransactionSummary;

  OrderTransactionResponse({
    required this.orderId,
    required this.transactionId,
    required this.grossAmount,
    required this.transactionDateTime,
    required this.expiryDateTime,
    required this.orderTransactionSummary,
    required this.paymentInstructionTransactionSummary
  });
}