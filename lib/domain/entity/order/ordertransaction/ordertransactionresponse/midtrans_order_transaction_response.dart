import 'dart:core';

import 'order_transaction_response.dart';

class MidtransOrderTransactionResponse extends OrderTransactionResponse {
  String orderId;
  String transactionId;
  @override
  String transactionStatus;
  String statusCode;
  String statusMessage;
  double grossAmount;
  DateTime transactionDateTime;
  @override
  DateTime expiryDateTime;

  MidtransOrderTransactionResponse({
    required this.orderId,
    required this.transactionId,
    required this.transactionStatus,
    required this.statusCode,
    required this.statusMessage,
    required this.grossAmount,
    required this.transactionDateTime,
    required this.expiryDateTime,
    required super.paymentType,
    required super.paymentStepType,
    required super.orderTransactionSummary,
    required super.paymentInstructionTransactionSummary
  });
}