import '../../../domain/entity/coupon/coupon.dart';
import '../../../domain/entity/payment/payment_method.dart';
import 'list_item_controller_state.dart';

class PurchaseDirectListItemControllerState extends ListItemControllerState {
  PaymentMethod? Function() onGetPaymentMethod;
  Coupon? Function() onGetCoupon;

  PurchaseDirectListItemControllerState({
    required this.onGetPaymentMethod,
    required this.onGetCoupon
  });
}