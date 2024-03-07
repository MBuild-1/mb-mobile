import '../../../domain/entity/address/address.dart';
import '../../../domain/entity/coupon/coupon.dart';
import '../../../domain/entity/payment/payment_method.dart';
import '../../errorprovider/error_provider.dart';
import '../../load_data_result.dart';
import 'list_item_controller_state.dart';

class PaymentParameterListItemControllerState extends ListItemControllerState {
  PaymentMethod? Function() onGetPaymentMethod;
  LoadDataResult<Coupon> Function() onGetCouponLoadDataResult;
  LoadDataResult<Address> Function() onGetCurrentSelectedAddressLoadDataResult;
  void Function(LoadDataResult<Coupon>) onSetCouponLoadDataResult;
  void Function() onSelectPaymentMethod;
  void Function() onRemovePaymentMethod;
  void Function() onSelectCoupon;
  void Function() onRemoveCoupon;
  void Function() onSelectAddress;
  ErrorProvider Function() errorProvider;
  void Function() onUpdateState;
  bool showSelectCoupon;
  bool showSelectAddress;

  PaymentParameterListItemControllerState({
    required this.onGetPaymentMethod,
    required this.onGetCurrentSelectedAddressLoadDataResult,
    required this.onGetCouponLoadDataResult,
    required this.onSetCouponLoadDataResult,
    required this.onSelectPaymentMethod,
    required this.onRemovePaymentMethod,
    required this.onSelectCoupon,
    required this.onRemoveCoupon,
    required this.onSelectAddress,
    required this.errorProvider,
    required this.onUpdateState,
    required this.showSelectCoupon,
    required this.showSelectAddress
  });
}