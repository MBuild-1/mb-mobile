import 'additional_item.dart';

class WithImageAdditionalItem extends AdditionalItem {
  String? imageUrl;

  WithImageAdditionalItem({
    required super.id,
    required super.name,
    required super.estimationPrice,
    required super.estimationWeight,
    required super.quantity,
    super.notes = "",
    required this.imageUrl
  });
}