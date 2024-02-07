import '../short_product.dart';
import 'product_brand.dart';

class ProductBrandDetail extends ProductBrand {
  final List<ShortProduct> shortProductList;

  ProductBrandDetail({
    required String id,
    required String name,
    required String slug,
    required String? description,
    String? icon,
    String? bannerDesktop,
    String? bannerMobile,
    required this.shortProductList,
    bool isAddedToFavorite = false
  }) : super(
    id: id,
    name: name,
    slug: slug,
    description: description,
    icon: icon,
    bannerDesktop: bannerDesktop,
    bannerMobile: bannerMobile,
    isAddedToFavorite: isAddedToFavorite
  );
}