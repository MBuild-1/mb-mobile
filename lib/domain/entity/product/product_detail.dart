import '../discussion/support_discussion.dart';
import 'product.dart';
import 'productentry/product_entry.dart';
import 'support_product_indicator.dart';

class ProductDetail extends Product implements SupportDiscussion, SupportProductIndicator {
  List<ProductEntry> productEntry;

  ProductDetail({
    required super.id,
    required super.userId,
    required super.productBrandId,
    required super.productCategoryId,
    required super.provinceId,
    required super.name,
    required super.slug,
    required super.description,
    required super.price,
    required super.discountPrice,
    required super.rating,
    required super.imageUrl,
    required super.productBrand,
    required super.productCategory,
    required super.province,
    required super.productCertificationList,
    required this.productEntry
  });

  String get _imageUrl {
    if (productEntry.isEmpty) {
      return "";
    }
    return productEntry.first.imageUrl;
  }

  @override
  String get discussionTitle => name;

  @override
  double get discussionPrice => price;

  @override
  String get discussionImageUrl => _imageUrl;

  @override
  String get productIndicatorTitle => name;

  @override
  double get productIndicatorPrice => price;

  @override
  String get productIndicatorImageUrl => _imageUrl;
}