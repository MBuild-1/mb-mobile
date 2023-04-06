import '../domain/entity/coupon/coupon.dart';
import '../domain/entity/coupon/coupon_paging_parameter.dart';
import '../domain/usecase/get_coupon_paging_use_case.dart';
import '../misc/load_data_result.dart';
import '../misc/paging/pagingresult/paging_data_result.dart';
import 'base_getx_controller.dart';

class CouponController extends BaseGetxController {
  final GetCouponPagingUseCase getCouponPagingUseCase;

  CouponController(super.controllerManager, this.getCouponPagingUseCase);

  Future<LoadDataResult<PagingDataResult<Coupon>>> getCouponPaging(CouponPagingParameter couponPagingParameter) {
    return getCouponPagingUseCase.execute(couponPagingParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("coupon-paging").value
    );
  }
}