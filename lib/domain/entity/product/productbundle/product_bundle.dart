import '../../cart/support_cart.dart';
import '../../discussion/support_discussion.dart';
import '../../order/support_order_product.dart';
import '../../wishlist/support_wishlist.dart';
import '../support_product_indicator.dart';

class ProductBundle implements SupportCart, SupportWishlist, SupportOrderProduct, SupportDiscussion, SupportProductIndicator {
  String id;
  String name;
  String slug;
  String description;
  String imageUrl;
  double price;
  double rating;
  int soldOut;
  bool _hasAddedToWishlist = false;
  bool _hasAddedToCart = false;

  @override
  String get cartTitle => name;

  @override
  double get cartPrice => price;

  @override
  String get cartImageUrl => imageUrl;

  @override
  String get orderTitle => name;

  @override
  double get orderPrice => price;

  @override
  String get orderImageUrl => imageUrl;

  @override
  String get supportWishlistContentId => id;

  @override
  String get supportCartContentId => id;

  @override
  bool get hasAddedToWishlist => _hasAddedToWishlist;

  @override
  set hasAddedToWishlist(bool value) => _hasAddedToWishlist = value;

  @override
  bool get hasAddedToCart => _hasAddedToCart;

  @override
  set hasAddedToCart(bool value) => _hasAddedToCart = value;

  @override
  String get discussionTitle => name;

  @override
  double get discussionPrice => price;

  @override
  String get discussionImageUrl => imageUrl;

  @override
  String get productIndicatorTitle => name;

  @override
  double get productIndicatorPrice => price;

  @override
  String get productIndicatorImageUrl => imageUrl;

  ProductBundle({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.soldOut,
    required bool hasAddedToWishlist,
    required bool hasAddedToCart
  }) : _hasAddedToWishlist = hasAddedToWishlist,
      _hasAddedToCart = hasAddedToCart;
}