import 'package:masterbagasi/misc/ext/response_wrapper_ext.dart';

import '../../domain/entity/coupon/coupon.dart';
import '../../domain/entity/wishlist/wishlist.dart';
import '../../misc/date_util.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/response_wrapper.dart';

extension CouponEntityMappingExt on ResponseWrapper {
  List<Coupon> mapFromResponseToCouponList() {
    return response.map<Coupon>((couponResponse) => ResponseWrapper(couponResponse).mapFromResponseToCoupon()).toList();
  }

  PagingDataResult<Coupon> mapFromResponseToCouponPaging() {
    return ResponseWrapper(response).mapFromResponseToPagingDataResult(
      (dataResponse) => dataResponse.map<Wishlist>(
        (wishlistResponse) => ResponseWrapper(wishlistResponse).mapFromResponseToCoupon()
      ).toList()
    );
  }
}

extension CouponDetailEntityMappingExt on ResponseWrapper {
  Coupon mapFromResponseToCoupon() {
    return Coupon(
      id: response["id"],
      title: response["title"],
      code: response["code"],
      type: response["type"],
      discount: ResponseWrapper(response["discount"]).mapFromResponseToDouble()!,
      minOrder: response["min_order"],
      activePeriodStart: ResponseWrapper(response["active_period_start"]).mapFromResponseToDateTime(dateFormat: DateUtil.standardDateFormat3)!,
      activePeriodEnd: ResponseWrapper(response["active_period_end"]).mapFromResponseToDateTime(dateFormat: DateUtil.standardDateFormat3)!,
      minPerUser: response["min_per_user"],
      image: response["image"],
      banner: response["banner"],
      notes: response["notes"],
    );
  }
}