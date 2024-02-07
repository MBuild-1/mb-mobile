class PurchaseDirectParameter {
  String productEntryId;
  String settlingId;
  String? couponId;
  int quantity;
  String notes;

  PurchaseDirectParameter({
    required this.productEntryId,
    required this.settlingId,
    required this.couponId,
    required this.quantity,
    required this.notes
  });
}