import 'product_brand.dart';

class SelectedProductBrand extends ProductBrand {
  String? bannerBrandChosenMobile;
  String? bannerBrandChosenDesktop;

  SelectedProductBrand({
    required super.id,
    required super.name,
    required super.slug,
    required super.description,
    required super.icon,
    required super.bannerDesktop,
    required super.bannerMobile,
    required this.bannerBrandChosenDesktop,
    required this.bannerBrandChosenMobile,
    super.isAddedToFavorite = false
  });
}