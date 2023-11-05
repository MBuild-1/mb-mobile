class AdditionalItem {
  String id;
  String name;
  double estimationPrice;
  double estimationWeight;
  int quantity;
  String notes;

  AdditionalItem({
    required this.id,
    required this.name,
    required this.estimationPrice,
    required this.estimationWeight,
    required this.quantity,
    this.notes = ""
  });
}