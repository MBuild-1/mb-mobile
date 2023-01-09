import '../../domain/entity/product.dart';
import '../../domain/entity/product_detail.dart';
import '../../domain/entity/product_with_detail_endpoint.dart';

class ProductModel {
  int id;
  String name;
  String defaultImageUrl;
  String pricePerGram;
  String productPlu;
  String productCode;
  String unit;
  String price;
  String sku;
  String productSellingPrice;
  String productDiscountPrice;
  String? detailEndpoint;
  String? description;

  ProductModel({
    required this.id,
    required this.name,
    required this.defaultImageUrl,
    required this.pricePerGram,
    required this.productPlu,
    required this.productCode,
    required this.unit,
    required this.price,
    required this.sku,
    required this.productSellingPrice,
    required this.productDiscountPrice,
    required this.detailEndpoint,
    required this.description
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      defaultImageUrl: json['default_image_url'],
      pricePerGram: json['price_per_gram'],
      productPlu: json['product_plu'],
      productCode: json['product_code'],
      unit: json['unit'],
      price: json['price'],
      sku: json['sku'],
      productSellingPrice: json['product_selling_price'],
      productDiscountPrice: json['product_discount_price'],
      detailEndpoint: json['detail-endpoint'],
      description: json['description']
    );
  }
}

extension ProductDataExt on ProductModel {
  Product toProduct() {
    if (detailEndpoint != null) {
      return ProductWithDetailEndpoint(
        id: id,
        name: name,
        defaultImageUrl: defaultImageUrl,
        pricePerGram: int.parse(pricePerGram),
        productPlu: productPlu,
        productCode: productCode,
        unit: unit,
        price: int.parse(price),
        sku: sku,
        productSellingPrice: int.parse(productSellingPrice),
        productDiscountPrice: int.parse(productDiscountPrice),
        detailEndpoint: detailEndpoint!
      );
    } else if (description != null) {
      return ProductDetail(
        id: id,
        name: name,
        defaultImageUrl: defaultImageUrl,
        pricePerGram: int.parse(pricePerGram),
        productPlu: productPlu,
        productCode: productCode,
        unit: unit,
        price: int.parse(price),
        sku: sku,
        productSellingPrice: int.parse(productSellingPrice),
        productDiscountPrice: int.parse(productDiscountPrice),
        description: description!
      );
    } else {
      return Product(
        id: id,
        name: name,
        defaultImageUrl: defaultImageUrl,
        pricePerGram: int.parse(pricePerGram),
        productPlu: productPlu,
        productCode: productCode,
        unit: unit,
        price: int.parse(price),
        sku: sku,
        productSellingPrice: int.parse(productSellingPrice),
        productDiscountPrice: int.parse(productDiscountPrice),
      );
    }
  }
}