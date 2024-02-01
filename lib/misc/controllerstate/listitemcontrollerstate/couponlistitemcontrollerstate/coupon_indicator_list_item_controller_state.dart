import '../../../../domain/entity/coupon/coupon.dart';
import '../../../errorprovider/error_provider.dart';
import '../../../load_data_result.dart';
import '../list_item_controller_state.dart';

class CouponIndicatorListItemControllerState extends ListItemControllerState {
  LoadDataResult<Coupon> Function() getSelectedCouponLoadDataResult;
  void Function(LoadDataResult<Coupon>) setSelectedCouponLoadDataResult;
  ErrorProvider Function() errorProvider;
  void Function(Coupon?) onUpdateCoupon;
  void Function() onUpdateState;
  void Function()? onSelectCoupon;

  CouponIndicatorListItemControllerState({
    required this.getSelectedCouponLoadDataResult,
    required this.setSelectedCouponLoadDataResult,
    required this.errorProvider,
    required this.onUpdateCoupon,
    required this.onUpdateState,
    this.onSelectCoupon
  });
}