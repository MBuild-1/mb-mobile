import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/coupon/check_coupon_parameter.dart';
import '../entity/coupon/check_coupon_response.dart';
import '../repository/coupon_repository.dart';

class CheckCouponUseCase {
  final CouponRepository couponRepository;

  const CheckCouponUseCase({
    required this.couponRepository
  });

  FutureProcessing<LoadDataResult<CheckCouponResponse>> execute(CheckCouponParameter checkCouponParameter) {
    return couponRepository.checkCoupon(checkCouponParameter);
  }
}