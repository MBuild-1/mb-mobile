import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/bucket/approveorrejectrequestbucket/approve_or_reject_request_bucket_parameter.dart';
import '../entity/bucket/approveorrejectrequestbucket/approve_or_reject_request_bucket_response.dart';
import '../entity/bucket/checkbucket/check_bucket_parameter.dart';
import '../entity/bucket/checkbucket/check_bucket_response.dart';
import '../entity/bucket/checkoutbucket/checkout_bucket_parameter.dart';
import '../entity/bucket/checkoutbucket/checkout_bucket_response.dart';
import '../entity/bucket/createbucket/create_bucket_parameter.dart';
import '../entity/bucket/createbucket/create_bucket_response.dart';
import '../entity/bucket/removememberbucket/remove_member_bucket_parameter.dart';
import '../entity/bucket/removememberbucket/remove_member_bucket_response.dart';
import '../entity/bucket/requestjoinbucket/request_join_bucket_parameter.dart';
import '../entity/bucket/requestjoinbucket/request_join_bucket_response.dart';
import '../entity/bucket/shared_cart_summary_parameter.dart';
import '../entity/bucket/showbucketbyid/show_bucket_by_id_parameter.dart';
import '../entity/bucket/showbucketbyid/show_bucket_by_id_response.dart';
import '../entity/bucket/triggerbucketready/trigger_bucket_ready_parameter.dart';
import '../entity/bucket/triggerbucketready/trigger_bucket_ready_response.dart';
import '../entity/cart/cart_summary.dart';

abstract class BucketRepository {
  FutureProcessing<LoadDataResult<CreateBucketResponse>> createBucket(CreateBucketParameter createBucketParameter);
  FutureProcessing<LoadDataResult<RemoveMemberBucketResponse>> removeMemberBucket(RemoveMemberBucketParameter removeMemberBucketParameter);
  FutureProcessing<LoadDataResult<RequestJoinBucketResponse>> requestJoinBucket(RequestJoinBucketParameter requestJoinBucketParameter);
  FutureProcessing<LoadDataResult<ShowBucketByIdResponse>> showBucketById(ShowBucketByIdParameter showBucketByIdParameter);
  FutureProcessing<LoadDataResult<ApproveOrRejectRequestBucketResponse>> approveOrRejectRequestBucket(ApproveOrRejectRequestBucketParameter approveOrRejectRequestBucketParameter);
  FutureProcessing<LoadDataResult<CheckBucketResponse>> checkBucket(CheckBucketParameter checkBucketParameter);
  FutureProcessing<LoadDataResult<CheckoutBucketResponse>> checkoutBucket(CheckoutBucketParameter checkoutBucketParameter);
  FutureProcessing<LoadDataResult<TriggerBucketReadyResponse>> triggerBucketReady(TriggerBucketReadyParameter triggerBucketReadyParameter);
  FutureProcessing<LoadDataResult<CartSummary>> sharedCartSummary(SharedCartSummaryParameter sharedCartSummaryParameter);
}