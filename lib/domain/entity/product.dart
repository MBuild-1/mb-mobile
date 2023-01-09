class Product {
  int id;
  String name;
  String defaultImageUrl;
  int pricePerGram;
  String productPlu;
  String productCode;
  String unit;
  int price;
  String sku;
  int productSellingPrice;
  int productDiscountPrice;

  Product({
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
  });
}