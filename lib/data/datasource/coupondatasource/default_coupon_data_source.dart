import 'package:dio/dio.dart';
import 'package:masterbagasi/data/entitymappingext/coupon_entity_mapping_ext.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/response_wrapper_ext.dart';

import '../../../domain/entity/coupon/coupon.dart';
import '../../../domain/entity/coupon/coupon_paging_parameter.dart';
import '../../../misc/paging/pagingresult/paging_data_result.dart';
import '../../../misc/processing/dio_http_client_processing.dart';
import '../../../misc/processing/future_processing.dart';
import 'coupon_data_source.dart';

class DefaultCouponDataSource implements CouponDataSource {
  final Dio dio;

  const DefaultCouponDataSource({
    required this.dio
  });

  @override
  FutureProcessing<PagingDataResult<Coupon>> couponPaging(CouponPagingParameter couponPagingParameter) {
    return DioHttpClientProcessing((cancelToken) {
      String pageParameterPath = "/${couponPagingParameter.itemEachPageCount}?page=${couponPagingParameter.page}";
      return dio.get("/coupon$pageParameterPath", cancelToken: cancelToken)
        .map<PagingDataResult<Coupon>>(onMap: (value) => value.wrapResponse().mapFromResponseToCouponPaging());
    });
  }
}