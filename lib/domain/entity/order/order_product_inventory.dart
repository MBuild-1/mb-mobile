import '../product/productentry/product_entry.dart';

class OrderProductInventory {
  String id;
  String orderProductId;
  String productEntryId;
  int quantity;
  int checkoutPrice;
  int? defaultQuantity;
  String? notes;
  String status;
  ProductEntry productEntry;

  OrderProductInventory({
    required this.id,
    required this.orderProductId,
    required this.productEntryId,
    required this.quantity,
    required this.checkoutPrice,
    required this.defaultQuantity,
    required this.notes,
    required this.status,
    required this.productEntry
  });
}