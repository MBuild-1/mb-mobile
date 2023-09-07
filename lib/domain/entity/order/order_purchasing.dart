class OrderPurchasing {
  String id;
  String? productEntryId;
  String? bundlingId;
  String combinedOrderId;
  int buyingPrice;
  String name;
  int price;
  double weight;
  int quantity;
  int quantityItem;
  double totalWeight;
  int totalPrice;

  OrderPurchasing({
    required this.id,
    required this.productEntryId,
    required this.bundlingId,
    required this.combinedOrderId,
    required this.buyingPrice,
    required this.name,
    required this.price,
    required this.weight,
    required this.quantity,
    required this.quantityItem,
    required this.totalWeight,
    required this.totalPrice
  });
}