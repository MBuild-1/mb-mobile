class PaymentMethod {
  String settlingId;
  String paymentName;
  String paymentGroupId;
  String paymentGroup;
  String paymentType;
  int paymentActive;
  String paymentImage;
  int serviceFee;
  int? taxRate;

  PaymentMethod({
    required this.settlingId,
    required this.paymentName,
    required this.paymentGroupId,
    required this.paymentGroup,
    required this.paymentType,
    required this.paymentActive,
    required this.paymentImage,
    required this.serviceFee,
    required this.taxRate
  });
}