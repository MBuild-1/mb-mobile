import 'product.dart';

class ProductWithDetailEndpoint extends Product {
  String detailEndpoint;

  ProductWithDetailEndpoint({
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
    required this.detailEndpoint
  });
}