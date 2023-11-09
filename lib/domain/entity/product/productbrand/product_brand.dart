class ProductBrand {
  String id;
  String name;
  String slug;
  String? description;
  String? icon;
  String? bannerDesktop;
  String? bannerMobile;
  bool isAddedToFavorite;

  ProductBrand({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.icon,
    required this.bannerDesktop,
    required this.bannerMobile,
    this.isAddedToFavorite = false
  });
}