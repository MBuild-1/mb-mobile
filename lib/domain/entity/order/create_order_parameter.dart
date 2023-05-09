import '../additionalitem/additional_item.dart';
import '../address/address.dart';
import '../cart/cart.dart';
import '../coupon/coupon.dart';

class CreateOrderParameter {
  Coupon? coupon;
  Address? address;
  List<Cart> cartList;
  List<AdditionalItem> additionalItemList;

  CreateOrderParameter({
    required this.cartList,
    required this.additionalItemList,
    required this.coupon,
    required this.address
  });
}