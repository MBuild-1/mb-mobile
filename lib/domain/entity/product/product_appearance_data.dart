abstract class ProductAppearanceData {
  String get productId;
  String get name;
  double get price;
  double? get discountPrice;
  double get weight;
  String get imageUrl;
}

abstract class ProductEntryAppearanceData extends ProductAppearanceData {
  String get productEntryId;
  int get soldCount;
  bool get hasAddedToWishlist;
  set hasAddedToWishlist(bool value);
  bool get hasAddedToCart;
  set hasAddedToCart(bool value);
  int get isViral;
  set isViral(int value);
  int get isKitchen;
  set isKitchen(int value);
  int get isHandycrafts;
  set isHandycrafts(int value);
  int get isFashionable;
  set isFashionable(int value);
  int get isBestSelling;
  set isBestSelling(int value);
  String get productVariantDescription;
}