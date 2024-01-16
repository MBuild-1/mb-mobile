import '../../../domain/entity/bucket/approveorrejectrequestbucket/approve_or_reject_request_bucket_parameter.dart';
import '../../../domain/entity/bucket/approveorrejectrequestbucket/approve_or_reject_request_bucket_response.dart';
import '../../../domain/entity/bucket/checkbucket/check_bucket_parameter.dart';
import '../../../domain/entity/bucket/checkbucket/check_bucket_response.dart';
import '../../../domain/entity/bucket/checkoutbucket/checkout_bucket_parameter.dart';
import '../../../domain/entity/bucket/checkoutbucket/checkout_bucket_response.dart';
import '../../../domain/entity/bucket/checkoutbucket/checkout_bucket_version_1_point_1_parameter.dart';
import '../../../domain/entity/bucket/checkoutbucket/checkout_bucket_version_1_point_1_response.dart';
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
import '../../../misc/processing/future_processing.dart';

abstract class BucketDataSource {
  FutureProcessing<CreateBucketResponse> createBucket(CreateBucketParameter createBucketParameter);
  FutureProcessing<RemoveMemberBucketResponse> removeMemberBucket(RemoveMemberBucketParameter removeMemberBucketParameter);
  FutureProcessing<RequestJoinBucketResponse> requestJoinBucket(RequestJoinBucketParameter requestJoinBucketParameter);
  FutureProcessing<ShowBucketByIdResponse> showBucketById(ShowBucketByIdParameter showBucketByIdParameter);
  FutureProcessing<ApproveOrRejectRequestBucketResponse> approveOrRejectRequestBucket(ApproveOrRejectRequestBucketParameter approveOrRejectRequestBucketParameter);
  FutureProcessing<CheckBucketResponse> checkBucket(CheckBucketParameter checkBucketParameter);
  FutureProcessing<CheckoutBucketResponse> checkoutBucket(CheckoutBucketParameter checkoutBucketParameter);
  FutureProcessing<CheckoutBucketVersion1Point1Response> checkoutBucketVersion1Point1(CheckoutBucketVersion1Point1Parameter checkoutBucketVersion1Point1Parameter);
  FutureProcessing<TriggerBucketReadyResponse> triggerBucketReady(TriggerBucketReadyParameter triggerBucketReadyParameter);
  FutureProcessing<DestroyBucketResponse> destroyBucket(DestroyBucketParameter destroyBucketParameter);
  FutureProcessing<LeaveBucketResponse> leaveBucket(LeaveBucketParameter leaveBucketParameter);
  FutureProcessing<CartSummary> sharedCartSummary(SharedCartSummaryParameter sharedCartSummaryParameter);
}