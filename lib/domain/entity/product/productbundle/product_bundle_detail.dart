import '../short_product.dart';
import 'product_bundle.dart';

class ProductBundleDetail extends ProductBundle {
  final List<ShortProduct> shortProductList;

  ProductBundleDetail({
    required String id,
    required String name,
    required String slug,
    required String description,
    required String imageUrl,
    required double price,
    required double rating,
    required this.shortProductList
  }) : super(
    id: id,
    name: name,
    slug: slug,
    description: description,
    imageUrl: imageUrl,
    price: price,
    rating: rating
  );
}