import 'package:dio/dio.dart';
import 'package:masterbagasi/data/entitymappingext/bucket_entity_mapping_ext.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/response_wrapper_ext.dart';

import '../../../domain/entity/bucket/approveorrejectrequestbucket/approve_or_reject_request_bucket_parameter.dart';
import '../../../domain/entity/bucket/approveorrejectrequestbucket/approve_or_reject_request_bucket_response.dart';
import '../../../domain/entity/bucket/createbucket/create_bucket_parameter.dart';
import '../../../domain/entity/bucket/createbucket/create_bucket_response.dart';
import '../../../domain/entity/bucket/removememberbucket/remove_member_bucket_parameter.dart';
import '../../../domain/entity/bucket/removememberbucket/remove_member_bucket_response.dart';
import '../../../domain/entity/bucket/requestjoinbucket/request_join_bucket_parameter.dart';
import '../../../domain/entity/bucket/requestjoinbucket/request_join_bucket_response.dart';
import '../../../domain/entity/bucket/showbucketbyid/show_bucket_by_id_parameter.dart';
import '../../../domain/entity/bucket/showbucketbyid/show_bucket_by_id_response.dart';
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
      return dio.delete("/user/bucket/remove/${removeMemberBucketParameter.bucketId}", cancelToken: cancelToken)
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
        "user_id": approveOrRejectRequestBucketParameter.userId
      }
    );
    return DioHttpClientProcessing((cancelToken) {
      return dio.post("/user/bucket/request/action", data: formData, cancelToken: cancelToken)
        .map(onMap: (value) => value.wrapResponse().mapFromResponseToApproveOrRejectRequestBucketResponse());
    });
  }
}