import '../../cart/support_cart.dart';

class ProductBundle implements SupportCart {
  String id;
  String name;
  String slug;
  String description;
  String imageUrl;
  double price;
  double rating;
  int soldOut;

  @override
  String get cartTitle => name;

  @override
  double get cartPrice => price;

  @override
  String get cartImageUrl => imageUrl;

  ProductBundle({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.soldOut
  });
}