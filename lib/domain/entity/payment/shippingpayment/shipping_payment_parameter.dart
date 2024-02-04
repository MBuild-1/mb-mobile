class ShippingPaymentParameter {
  String settlingId;
  String combinedOrderId;
  int expire;

  ShippingPaymentParameter({
    required this.settlingId,
    required this.combinedOrderId,
    required this.expire
  });
}