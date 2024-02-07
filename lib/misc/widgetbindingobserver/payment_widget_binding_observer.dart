import 'package:flutter/material.dart';

class PaymentWidgetBindingObserver extends WidgetsBindingObserver {
  void Function() checkOrderTransactionWhileResuming;

  PaymentWidgetBindingObserver({
    required this.checkOrderTransactionWhileResuming,
  });

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      checkOrderTransactionWhileResuming();
    }
  }
}