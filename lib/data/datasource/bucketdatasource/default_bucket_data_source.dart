import 'package:dio/dio.dart';
import 'package:masterbagasi/data/entitymappingext/bucket_entity_mapping_ext.dart';
import 'package:masterbagasi/data/entitymappingext/cart_entity_mapping_ext.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/response_wrapper_ext.dart';

import '../../../domain/entity/bucket/approveorrejectrequestbucket/approve_or_reject_request_bucket_parameter.dart';
import '../../../domain/entity/bucket/approveorrejectrequestbucket/approve_or_reject_request_bucket_response.dart';
import '../../../domain/entity/bucket/checkbucket/check_bucket_parameter.dart';
import '../../../domain/entity/bucket/checkbucket/check_bucket_response.dart';
import '../../../domain/entity/bucket/checkoutbucket/checkout_bucket_parameter.dart';
import '../../../domain/entity/bucket/checkoutbucket/checkout_bucket_response.dart';
import '../../../domain/entity/bucket/createbucket/create_bucket_parameter.dart';
import '../../../domain/entity/bucket/createbucket/create_bucket_response.dart';
import '../../../domain/entity/bucket/destroybucket/destroy_bucket_parameter.dart';
import '../../../domain/entity/bucket/destroybucket/destroy_bucket_response.dart';
import '../../../domain/entity/bucket/leavebucket/leave_bucket_parameter.dart';
import '../../../domain/entity/bucket/leavebucket/leave_bucket_response.dart';
import '../../../domain/entity/bucket/removememberbucket/remove_member_bucket_parameter.dart';
import '../../../domain/entity/bucket/removememberbucket/remove_member_bucket_response.dart';
import '../../../domain/entity/bucket/requestjoinbucket/request_join_bucket_parameter.dart';
import '../../../domain/entity/bucket/requestjoinbucket/request_join_bucket_response.dart';
import '../../../domain/entity/bucket/shared_cart_summary_parameter.dart';
import '../../../domain/entity/bucket/showbucketbyid/show_bucket_by_id_parameter.dart';
import '../../../domain/entity/bucket/showbucketbyid/show_bucket_by_id_response.dart';
import '../../../domain/entity/bucket/triggerbucketready/trigger_bucket_ready_parameter.dart';
import '../../../domain/entity/bucket/triggerbucketready/trigger_bucket_ready_response.dart';
import '../../../domain/entity/cart/cart_summary.dart';
import '../../../misc/processing/dio_http_client_processing.dart';
import '../../../misc/processing/future_processing.dart';
import 'bucket_data_source.dart';

class DefaultBucketDataSource implements BucketDataSource {
  final Dio dio;

  const DefaultBucketDataSource({
    required this.dio,
  });

  @override
  FutureProcessing<CreateBucketResponse> createBucket(CreateBucketParameter createBucketParameter) {
    FormData formData = FormData.fromMap(
      <String, dynamic> {
        "bucket_username": createBucketParameter.bucketUsername,
        "bucket_password": createBucketParameter.bucketPassword
      }
    );
    return DioHttpClientProcessing((cancelToken) {
      return dio.post("/user/bucket", data: formData, cancelToken: cancelToken)
        .map(onMap: (value) => value.wrapResponse().mapFromResponseToCreateBucketResponse());
    });
  }

  @override
  FutureProcessing<RemoveMemberBucketResponse> removeMemberBucket(RemoveMemberBucketParameter removeMemberBucketParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.delete("/user/bucket/remove/${removeMemberBucketParameter.userId}", cancelToken: cancelToken)
        .map(onMap: (value) => value.wrapResponse().mapFromResponseToRemoveMemberBucketResponse());
    });
  }

  @override
  FutureProcessing<RequestJoinBucketResponse> requestJoinBucket(RequestJoinBucketParameter requestJoinBucketParameter) {
    FormData formData = FormData.fromMap(
      <String, dynamic> {
        "bucket_username": requestJoinBucketParameter.bucketUsername,
        "bucket_password": requestJoinBucketParameter.bucketPassword
      }
    );
    return DioHttpClientProcessing((cancelToken) {
      return dio.post("/user/bucket/request/join", data: formData, cancelToken: cancelToken)
        .map(onMap: (value) => value.wrapResponse().mapFromResponseToRequestJoinBucketResponse());
    });
  }

  @override
  FutureProcessing<ShowBucketByIdResponse> showBucketById(ShowBucketByIdParameter showBucketByIdParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/user/bucket/${showBucketByIdParameter.bucketId}", cancelToken: cancelToken)
        .map(onMap: (value) => value.wrapResponse().mapFromResponseToShowBucketByIdResponse());
    });
  }

  @override
  FutureProcessing<ApproveOrRejectRequestBucketResponse> approveOrRejectRequestBucket(ApproveOrRejectRequestBucketParameter approveOrRejectRequestBucketParameter) {
    FormData formData = FormData.fromMap(
      <String, dynamic> {
        "type": approveOrRejectRequestBucketParameter.type,
        "user_id": approveOrRejectRequestBucketParameter.userId,
        "bucket_id": approveOrRejectRequestBucketParameter.bucketId
      }
    );
    return DioHttpClientProcessing((cancelToken) {
      return dio.post("/user/bucket/request/action", data: formData, cancelToken: cancelToken)
        .map(onMap: (value) => value.wrapResponse().mapFromResponseToApproveOrRejectRequestBucketResponse());
    });
  }

  @override
  FutureProcessing<CheckBucketResponse> checkBucket(CheckBucketParameter checkBucketParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/user/bucket/user/check", cancelToken: cancelToken)
        .map(onMap: (value) => value.wrapResponse().mapFromResponseToCheckBucketResponse());
    });
  }

  @override
  FutureProcessing<CheckoutBucketResponse> checkoutBucket(CheckoutBucketParameter checkoutBucketParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.post("/user/bucket/checkout/${checkoutBucketParameter.bucketId}", cancelToken: cancelToken)
        .map(onMap: (value) => value.wrapResponse().mapFromResponseToCheckoutBucketResponse());
    });
  }

  @override
  FutureProcessing<TriggerBucketReadyResponse> triggerBucketReady(TriggerBucketReadyParameter triggerBucketReadyParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.post("/user/bucket/ready", cancelToken: cancelToken)
        .map(onMap: (value) => value.wrapResponse().mapFromResponseToTriggerBucketReadyResponse());
    });
  }

  @override
  FutureProcessing<DestroyBucketResponse> destroyBucket(DestroyBucketParameter destroyBucketParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.delete("/user/bucket/destroy", cancelToken: cancelToken)
        .map(onMap: (value) => value.wrapResponse().mapFromResponseToDestroyBucketResponse());
    });
  }

  @override
  FutureProcessing<LeaveBucketResponse> leaveBucket(LeaveBucketParameter leaveBucketParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.delete("/user/bucket/leave", cancelToken: cancelToken)
        .map(onMap: (value) => value.wrapResponse().mapFromResponseToLeaveBucketResponse());
    });
  }

  @override
  FutureProcessing<CartSummary> sharedCartSummary(SharedCartSummaryParameter sharedCartSummaryParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/user/bucket/order/summary/${sharedCartSummaryParameter.bucketId}", cancelToken: cancelToken)
        .map(onMap: (value) => value.wrapResponse().mapFromResponseToCartSummary());
    });
  }
}