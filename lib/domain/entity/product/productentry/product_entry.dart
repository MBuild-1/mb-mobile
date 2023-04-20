import '../product.dart';
import '../product_appearance_data.dart';
import '../productvariant/product_variant.dart';

class ProductEntry implements ProductEntryAppearanceData {
  String id;
  @override
  String productId;
  @override
  String productEntryId;
  String sku;
  String sustension;
  @override
  double weight;
  int isViral;
  int isKitchen;
  int isHandycrafts;
  int isFashionable;
  int sellingPrice;
  int isBestSelling;
  Product product;
  List<String> imageUrlList;
  List<ProductVariant> productVariantList;
  @override
  int soldCount;

  ProductEntry({
    required this.id,
    required this.productId,
    required this.productEntryId,
    required this.sku,
    required this.sustension,
    required this.weight,
    required this.isViral,
    required this.isKitchen,
    required this.isHandycrafts,
    required this.isFashionable,
    required this.sellingPrice,
    required this.isBestSelling,
    required this.product,
    required this.productVariantList,
    required this.imageUrlList,
    required this.soldCount
  });

  @override
  double? get discountPrice => product.discountPrice;

  @override
  String get imageUrl {
    if (imageUrlList.isEmpty) {
      return "";
    }
    return imageUrlList.first;
  }

  @override
  String get name => product.name;

  @override
  double get price => product.price;
}