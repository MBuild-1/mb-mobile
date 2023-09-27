import '../../domain/entity/bucket/approveorrejectrequestbucket/approve_or_reject_request_bucket_response.dart';
import '../../domain/entity/bucket/createbucket/create_bucket_response.dart';
import '../../domain/entity/bucket/removememberbucket/remove_member_bucket_response.dart';
import '../../domain/entity/bucket/requestjoinbucket/request_join_bucket_response.dart';
import '../../domain/entity/bucket/showbucketbyid/show_bucket_by_id_response.dart';
import '../../misc/response_wrapper.dart';

extension BucketDetailEntityMappingExt on ResponseWrapper {
  CreateBucketResponse mapFromResponseToCreateBucketResponse() {
    return CreateBucketResponse();
  }

  RemoveMemberBucketResponse mapFromResponseToRemoveMemberBucketResponse() {
    return RemoveMemberBucketResponse();
  }

  RequestJoinBucketResponse mapFromResponseToRequestJoinBucketResponse() {
    return RequestJoinBucketResponse();
  }

  ShowBucketByIdResponse mapFromResponseToShowBucketByIdResponse() {
    return ShowBucketByIdResponse();
  }

  ApproveOrRejectRequestBucketResponse mapFromResponseToApproveOrRejectRequestBucketResponse() {
    return ApproveOrRejectRequestBucketResponse();
  }
}