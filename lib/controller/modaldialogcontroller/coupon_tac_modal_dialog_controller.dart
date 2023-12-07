import '../../domain/entity/coupon/coupon_tac.dart';
import '../../domain/entity/coupon/coupon_tac_list_parameter.dart';
import '../../domain/usecase/get_coupon_tac_list_use_case.dart';
import '../../misc/load_data_result.dart';
import 'modal_dialog_controller.dart';

class CouponTacModalDialogController extends ModalDialogController {
  final GetCouponTacListUseCase getCouponTacListUseCase;

  CouponTacModalDialogController(
    super.controllerManager,
    this.getCouponTacListUseCase
  );

  Future<LoadDataResult<List<CouponTac>>> getCouponTacList(CouponTacListParameter couponTacListParameter) {
    return getCouponTacListUseCase.execute(couponTacListParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("coupon-tac-list").value
    );
  }
}