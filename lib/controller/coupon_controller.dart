import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../domain/entity/coupon/check_coupon_parameter.dart';
import '../domain/entity/coupon/check_coupon_response.dart';
import '../domain/entity/coupon/coupon.dart';
import '../domain/entity/coupon/coupon_list_parameter.dart';
import '../domain/entity/coupon/coupon_paging_parameter.dart';
import '../domain/usecase/check_coupon_use_case.dart';
import '../domain/usecase/get_coupon_list_use_case.dart';
import '../domain/usecase/get_coupon_paging_use_case.dart';
import '../misc/load_data_result.dart';
import '../misc/paging/pagingresult/paging_data_result.dart';
import '../misc/typedef.dart';
import 'base_getx_controller.dart';

typedef _OnCouponBack = void Function();
typedef _OnShowCheckCouponProcessLoadingCallback = Future<void> Function();
typedef _OnCheckCouponProcessSuccessCallback = Future<void> Function(CheckCouponResponse);
typedef _OnShowCheckCouponProcessFailedCallback = Future<void> Function(dynamic e);

class CouponController extends BaseGetxController {
  final GetCouponPagingUseCase getCouponPagingUseCase;
  final GetCouponListUseCase getCouponListUseCase;
  final CheckCouponUseCase checkCouponUseCase;
  CouponDelegate? _couponDelegate;

  CouponController(
    super.controllerManager,
    this.getCouponPagingUseCase,
    this.getCouponListUseCase,
    this.checkCouponUseCase
  );

  Future<LoadDataResult<PagingDataResult<Coupon>>> getCouponPaging(CouponPagingParameter couponPagingParameter) {
    return getCouponPagingUseCase.execute(couponPagingParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("coupon-paging").value
    );
  }

  Future<LoadDataResult<List<Coupon>>> getCouponList(CouponListParameter couponListParameter) {
    return getCouponListUseCase.execute(couponListParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("coupon-list").value
    );
  }

  CouponController setCouponDelegate(CouponDelegate couponDelegate) {
    _couponDelegate = couponDelegate;
    return this;
  }

  void checkCoupon(String couponId) async {
    if (_couponDelegate != null) {
      _couponDelegate!.onUnfocusAllWidget();
      _couponDelegate!.onShowCheckCouponProcessLoadingCallback();
      LoadDataResult<CheckCouponResponse> checkCouponResponseLoadDataResult = await checkCouponUseCase.execute(
        CheckCouponParameter(
          couponId: couponId
        )
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart('check-coupon').value
      );
      _couponDelegate!.onCouponBack();
      if (checkCouponResponseLoadDataResult.isSuccess) {
        _couponDelegate!.onCheckCouponProcessSuccessCallback(checkCouponResponseLoadDataResult.resultIfSuccess!);
      } else {
        _couponDelegate!.onShowCheckCouponProcessFailedCallback(checkCouponResponseLoadDataResult.resultIfFailed);
      }
    }
  }
}

class CouponDelegate {
  OnUnfocusAllWidget onUnfocusAllWidget;
  _OnCouponBack onCouponBack;
  _OnShowCheckCouponProcessLoadingCallback onShowCheckCouponProcessLoadingCallback;
  _OnCheckCouponProcessSuccessCallback onCheckCouponProcessSuccessCallback;
  _OnShowCheckCouponProcessFailedCallback onShowCheckCouponProcessFailedCallback;

  CouponDelegate({
    required this.onUnfocusAllWidget,
    required this.onCouponBack,
    required this.onShowCheckCouponProcessLoadingCallback,
    required this.onCheckCouponProcessSuccessCallback,
    required this.onShowCheckCouponProcessFailedCallback
  });
}