import 'product.dart';

class ProductDetail extends Product {
  String description;

  ProductDetail({
    required super.id,
    required super.name,
    required super.defaultImageUrl,
    required super.pricePerGram,
    required super.productPlu,
    required super.productCode,
    required super.unit,
    required super.price,
    required super.sku,
    required super.productSellingPrice,
    required super.productDiscountPrice,
    required this.description
  });
}