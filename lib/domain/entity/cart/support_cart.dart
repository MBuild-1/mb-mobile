abstract class SupportCart {
  String get supportCartContentId;
  String get cartTitle;
  double get cartPrice;
  String get cartImageUrl;
  bool get hasAddedToCart;
  set hasAddedToCart(bool value);
}