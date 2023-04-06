import '../../misc/load_data_result.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/coupon/coupon.dart';
import '../entity/coupon/coupon_paging_parameter.dart';

abstract class CouponRepository {
  FutureProcessing<LoadDataResult<PagingDataResult<Coupon>>> couponPaging(CouponPagingParameter couponPagingParameter);
}