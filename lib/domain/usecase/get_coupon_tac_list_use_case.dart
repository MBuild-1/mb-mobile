import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/coupon/coupon_tac.dart';
import '../entity/coupon/coupon_tac_list_parameter.dart';
import '../repository/coupon_repository.dart';

class GetCouponTacListUseCase {
  final CouponRepository couponRepository;

  const GetCouponTacListUseCase({
    required this.couponRepository
  });

  FutureProcessing<LoadDataResult<List<CouponTac>>> execute(CouponTacListParameter couponTacListParameter) {
    return couponRepository.couponTacList(couponTacListParameter);
  }
}