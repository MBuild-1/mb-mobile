import '../../cart/support_cart.dart';
import '../../order/support_order_product.dart';
import '../../wishlist/support_wishlist.dart';

class ProductBundle implements SupportCart, SupportWishlist, SupportOrderProduct {
  String id;
  String name;
  String slug;
  String description;
  String imageUrl;
  double price;
  double rating;
  int soldOut;
  bool _hasAddedToWishlist = false;

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
  bool get hasAddedToWishlist => _hasAddedToWishlist;

  @override
  set hasAddedToWishlist(bool value) => _hasAddedToWishlist = value;

  ProductBundle({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.soldOut,
    required bool hasAddedToWishlist
  }) : _hasAddedToWishlist = hasAddedToWishlist;
}