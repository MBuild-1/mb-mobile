import '../../../../misc/product_helper.dart';
import '../../cart/support_cart.dart';
import '../../discussion/support_discussion.dart';
import '../../order/support_order_product.dart';
import '../../search/support_search.dart';
import '../../wishlist/support_wishlist.dart';
import '../product.dart';
import '../product_appearance_data.dart';
import '../productvariant/product_variant.dart';
import '../support_product_indicator.dart';

class ProductEntry implements ProductEntryAppearanceData, SupportCart, SupportWishlist, SupportOrderProduct, SupportDiscussion, SupportSearch, SupportProductIndicator {
  String id;
  @override
  String productId;
  @override
  String productEntryId;
  String sku;
  String sustension;
  @override
  double weight;
  @override
  int isViral;
  @override
  int isKitchen;
  @override
  int isHandycrafts;
  @override
  int isFashionable;
  int purchasePrice;
  int sellingPrice;
  @override
  int isBestSelling;
  Product product;
  List<String> imageUrlList;
  List<ProductVariant> productVariantList;
  String? shareCode;
  @override
  int soldCount;
  bool _hasAddedToWishlist;
  bool _hasAddedToCart;

  @override
  String get cartTitle => name;

  @override
  double get cartPrice => sellingPrice.toDouble();

  @override
  String get cartImageUrl => imageUrl;

  @override
  String get orderTitle => name;

  @override
  double get orderPrice => sellingPrice.toDouble();

  @override
  String get orderImageUrl => imageUrl;

  @override
  String get discussionTitle => name;

  @override
  double get discussionPrice => sellingPrice.toDouble();

  @override
  String get discussionImageUrl => imageUrl;

  @override
  String get productIndicatorTitle => name;

  @override
  double get productIndicatorPrice => sellingPrice.toDouble();

  @override
  String get productIndicatorImageUrl => imageUrl;

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
    required this.purchasePrice,
    required this.sellingPrice,
    required this.isBestSelling,
    required this.product,
    required this.productVariantList,
    required this.shareCode,
    required this.imageUrlList,
    required this.soldCount,
    required bool hasAddedToWishlist,
    required bool hasAddedToCart
  }) : _hasAddedToWishlist = hasAddedToWishlist,
      _hasAddedToCart = hasAddedToCart;

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
  double get price => sellingPrice.toDouble();

  @override
  String get supportWishlistContentId => productEntryId;

  @override
  String get supportCartContentId => productEntryId;

  @override
  bool get hasAddedToWishlist => _hasAddedToWishlist;

  @override
  set hasAddedToWishlist(bool value) => _hasAddedToWishlist = value;

  @override
  bool get hasAddedToCart => _hasAddedToCart;

  @override
  set hasAddedToCart(bool value) => _hasAddedToCart = value;

  @override
  String get productVariantDescription => ProductHelper.getProductVariantDescription(this);
}