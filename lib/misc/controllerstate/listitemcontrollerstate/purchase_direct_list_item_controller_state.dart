import '../../../domain/entity/coupon/coupon.dart';
import '../../../domain/entity/payment/payment_method.dart';
import '../../errorprovider/error_provider.dart';
import '../../load_data_result.dart';
import 'list_item_controller_state.dart';

class PurchaseDirectListItemControllerState extends ListItemControllerState {
  PaymentMethod? Function() onGetPaymentMethod;
  LoadDataResult<Coupon> Function() onGetCouponLoadDataResult;
  void Function(LoadDataResult<Coupon>) onSetCouponLoadDataResult;
  void Function() onSelectPaymentMethod;
  void Function() onRemovePaymentMethod;
  void Function() onSelectCoupon;
  void Function() onRemoveCoupon;
  ErrorProvider Function() errorProvider;
  void Function() onUpdateState;

  PurchaseDirectListItemControllerState({
    required this.onGetPaymentMethod,
    required this.onGetCouponLoadDataResult,
    required this.onSetCouponLoadDataResult,
    required this.onSelectPaymentMethod,
    required this.onRemovePaymentMethod,
    required this.onSelectCoupon,
    required this.onRemoveCoupon,
    required this.errorProvider,
    required this.onUpdateState
  });
}