import 'package:masterbagasi/misc/ext/future_ext.dart';

import '../../domain/entity/address/address.dart';
import '../../domain/entity/address/current_selected_address_parameter.dart';
import '../../domain/entity/coupon/coupon.dart';
import '../../domain/entity/coupon/coupon_detail_parameter.dart';
import '../../domain/usecase/get_coupon_detail_use_case.dart';
import '../../domain/usecase/get_current_selected_address_use_case.dart';
import '../../misc/load_data_result.dart';
import 'modal_dialog_controller.dart';

class PaymentParameterModalDialogController extends ModalDialogController {
  final GetCouponDetailUseCase getCouponDetailUseCase;
  final GetCurrentSelectedAddressUseCase getCurrentSelectedAddressUseCase;

  PaymentParameterModalDialogController(
    super.controllerManager,
    this.getCouponDetailUseCase,
    this.getCurrentSelectedAddressUseCase
  );

  Future<LoadDataResult<Coupon>> getCouponDetail(CouponDetailParameter couponDetailParameter) {
    return getCouponDetailUseCase.execute(couponDetailParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("coupon-detail").value
    );
  }

  Future<LoadDataResult<Address>> getCurrentSelectedAddress(CurrentSelectedAddressParameter currentSelectedAddressParameter) {
    return getCurrentSelectedAddressUseCase.execute(currentSelectedAddressParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("current-selected-address").value
    ).map<Address>((currentSelectedAddressResponse) {
      return currentSelectedAddressResponse.address;
    });
  }
}