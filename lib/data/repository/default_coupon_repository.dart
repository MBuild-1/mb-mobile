import '../../domain/entity/coupon/coupon.dart';
import '../../domain/entity/coupon/coupon_paging_parameter.dart';
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
}