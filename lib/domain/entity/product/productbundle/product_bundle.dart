class ProductBundle {
  String id;
  String name;
  String slug;
  String description;
  String imageUrl;
  double price;
  double rating;

  ProductBundle({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.rating
  });
}