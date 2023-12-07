import '../../domain/entity/coupon/check_coupon_parameter.dart';
import '../../domain/entity/coupon/check_coupon_response.dart';
import '../../domain/entity/coupon/coupon.dart';
import '../../domain/entity/coupon/coupon_detail_parameter.dart';
import '../../domain/entity/coupon/coupon_list_parameter.dart';
import '../../domain/entity/coupon/coupon_paging_parameter.dart';
import '../../domain/entity/coupon/coupon_tac.dart';
import '../../domain/entity/coupon/coupon_tac_list_parameter.dart';
import '../../domain/repository/coupon_repository.dart';
import '../../misc/load_data_result.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../datasource/coupondatasource/coupon_data_source.dart';

class DefaultCouponRepository implements CouponRepository {
  final CouponDataSource couponDataSource;

  const DefaultCouponRepository({
    required this.couponDataSource
  });

  @override
  FutureProcessing<LoadDataResult<PagingDataResult<Coupon>>> couponPaging(CouponPagingParameter couponPagingParameter) {
    return couponDataSource.couponPaging(couponPagingParameter).mapToLoadDataResult<PagingDataResult<Coupon>>();
  }

  @override
  FutureProcessing<LoadDataResult<List<Coupon>>> couponList(CouponListParameter couponListParameter) {
    return couponDataSource.couponList(couponListParameter).mapToLoadDataResult<List<Coupon>>();
  }

  @override
  FutureProcessing<LoadDataResult<Coupon>> couponDetail(CouponDetailParameter couponDetailParameter) {
    return couponDataSource.couponDetail(couponDetailParameter).mapToLoadDataResult<Coupon>();
  }

  @override
  FutureProcessing<LoadDataResult<List<CouponTac>>> couponTacList(CouponTacListParameter couponTacListParameter) {
    return couponDataSource.couponTacList(couponTacListParameter).mapToLoadDataResult<List<CouponTac>>();
  }

  @override
  FutureProcessing<LoadDataResult<CheckCouponResponse>> checkCoupon(CheckCouponParameter checkCouponParameter) {
    return couponDataSource.checkCoupon(checkCouponParameter).mapToLoadDataResult<CheckCouponResponse>();
  }
}