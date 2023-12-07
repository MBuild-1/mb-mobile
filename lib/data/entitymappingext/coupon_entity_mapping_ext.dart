import 'package:masterbagasi/misc/ext/response_wrapper_ext.dart';

import '../../domain/entity/coupon/check_coupon_response.dart';
import '../../domain/entity/coupon/coupon.dart';
import '../../domain/entity/coupon/coupon_detail.dart';
import '../../domain/entity/coupon/coupon_detail_value.dart';
import '../../domain/entity/coupon/coupon_tac.dart';
import '../../misc/date_util.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/response_wrapper.dart';

extension CouponEntityMappingExt on ResponseWrapper {
  List<Coupon> mapFromResponseToCouponList() {
    return response.map<Coupon>((couponResponse) => ResponseWrapper(couponResponse).mapFromResponseToCoupon()).toList();
  }

  List<CouponTac> mapFromResponseToCouponTacList() {
    return response.map<CouponTac>((couponTacResponse) => ResponseWrapper(couponTacResponse).mapFromResponseToCouponTac()).toList();
  }

  PagingDataResult<Coupon> mapFromResponseToCouponPaging() {
    return ResponseWrapper(response).mapFromResponseToPagingDataResult(
      (dataResponse) => dataResponse.map<Coupon>(
        (couponResponse) => ResponseWrapper(couponResponse).mapFromResponseToCoupon()
      ).toList()
    );
  }
}

extension CouponDetailEntityMappingExt on ResponseWrapper {
  Coupon mapFromResponseToCoupon() {
    late dynamic effectiveResponse;
    if (response is List) {
      effectiveResponse = response[0];
    } else {
      effectiveResponse = response;
    }
    dynamic voucherImages = effectiveResponse["voucher_images"];
    return Coupon(
      id: effectiveResponse["id"],
      userProfessionId: effectiveResponse["user_profession_id"],
      active: effectiveResponse["active"],
      needVerify: effectiveResponse["need_verify"],
      title: effectiveResponse["title"],
      code: effectiveResponse["code"],
      startPeriod: ResponseWrapper(effectiveResponse["start_period"]).mapFromResponseToDateTime(dateFormat: DateUtil.standardDateFormat3)!,
      endPeriod: ResponseWrapper(effectiveResponse["end_period"]).mapFromResponseToDateTime(dateFormat: DateUtil.standardDateFormat3)!,
      quota: effectiveResponse["quota"],
      imageMobile: voucherImages["image_mobile"],
      imageDesktop: voucherImages["image_desktop"],
      bannerDesktop: voucherImages["banner_desktop"],
      bannerMobile: voucherImages["banner_mobile"]
    );
  }

  CouponDetail mapFromResponseToCouponDetail() {
    Coupon coupon = ResponseWrapper(response).mapFromResponseToCoupon();
    return CouponDetail(
      id: coupon.id,
      userProfessionId: coupon.userProfessionId,
      active: coupon.active,
      needVerify: coupon.needVerify,
      title: coupon.title,
      code: coupon.code,
      startPeriod: coupon.startPeriod,
      endPeriod: coupon.endPeriod,
      quota: coupon.quota,
      imageMobile: coupon.imageMobile,
      imageDesktop: coupon.imageDesktop,
      bannerDesktop: coupon.bannerDesktop,
      bannerMobile: coupon.bannerMobile,
      couponDetailValue: ResponseWrapper(response["voucher_detail"]).mapFromResponseToCouponDetailValue()
    );
  }

  CouponDetailValue mapFromResponseToCouponDetailValue() {
    return CouponDetailValue(
      id: response["id"],
      voucherId: response["voucher_id"],
      voucherTacId: response["voucher_tac_id"],
      discount: ResponseWrapper(response["discount"]).mapFromResponseToDouble()!
    );
  }

  CouponTac mapFromResponseToCouponTac() {
    return CouponTac(
      id: response["id"],
      voucherId: response["voucher_id"],
      text: response["text"]
    );
  }

  CheckCouponResponse mapFromResponseToCheckCouponResponse() {
    return CheckCouponResponse();
  }
}