import '../../domain/entity/coupon/coupon.dart';
import '../../domain/entity/coupon/coupon_detail_parameter.dart';
import '../../domain/usecase/get_coupon_detail_use_case.dart';
import '../../misc/load_data_result.dart';
import 'modal_dialog_controller.dart';

class PurchaseDirectModalDialogController extends ModalDialogController {
  final GetCouponDetailUseCase getCouponDetailUseCase;

  PurchaseDirectModalDialogController(
    super.controllerManager,
    this.getCouponDetailUseCase
  );

  Future<LoadDataResult<Coupon>> getCouponDetail(CouponDetailParameter couponDetailParameter) {
    return getCouponDetailUseCase.execute(couponDetailParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("coupon-detail").value
    );
  }
}