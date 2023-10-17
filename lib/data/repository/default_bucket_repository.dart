import '../../domain/entity/bucket/approveorrejectrequestbucket/approve_or_reject_request_bucket_parameter.dart';
import '../../domain/entity/bucket/approveorrejectrequestbucket/approve_or_reject_request_bucket_response.dart';
import '../../domain/entity/bucket/checkbucket/check_bucket_parameter.dart';
import '../../domain/entity/bucket/checkbucket/check_bucket_response.dart';
import '../../domain/entity/bucket/checkoutbucket/checkout_bucket_parameter.dart';
import '../../domain/entity/bucket/checkoutbucket/checkout_bucket_response.dart';
import '../../domain/entity/bucket/createbucket/create_bucket_parameter.dart';
import '../../domain/entity/bucket/createbucket/create_bucket_response.dart';
import '../../domain/entity/bucket/removememberbucket/remove_member_bucket_parameter.dart';
import '../../domain/entity/bucket/removememberbucket/remove_member_bucket_response.dart';
import '../../domain/entity/bucket/requestjoinbucket/request_join_bucket_parameter.dart';
import '../../domain/entity/bucket/requestjoinbucket/request_join_bucket_response.dart';
import '../../domain/entity/bucket/shared_cart_summary_parameter.dart';
import '../../domain/entity/bucket/showbucketbyid/show_bucket_by_id_parameter.dart';
import '../../domain/entity/bucket/showbucketbyid/show_bucket_by_id_response.dart';
import '../../domain/entity/bucket/triggerbucketready/trigger_bucket_ready_parameter.dart';
import '../../domain/entity/bucket/triggerbucketready/trigger_bucket_ready_response.dart';
import '../../domain/entity/cart/cart_summary.dart';
import '../../domain/repository/bucket_repository.dart';
import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../datasource/bucketdatasource/bucket_data_source.dart';

class DefaultBucketRepository implements BucketRepository {
  final BucketDataSource bucketDataSource;

  const DefaultBucketRepository({
    required this.bucketDataSource
  });

  @override
  FutureProcessing<LoadDataResult<CreateBucketResponse>> createBucket(CreateBucketParameter createBucketParameter) {
    return bucketDataSource.createBucket(createBucketParameter).mapToLoadDataResult<CreateBucketResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<RemoveMemberBucketResponse>> removeMemberBucket(RemoveMemberBucketParameter removeMemberBucketParameter) {
    return bucketDataSource.removeMemberBucket(removeMemberBucketParameter).mapToLoadDataResult<RemoveMemberBucketResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<RequestJoinBucketResponse>> requestJoinBucket(RequestJoinBucketParameter requestJoinBucketParameter) {
    return bucketDataSource.requestJoinBucket(requestJoinBucketParameter).mapToLoadDataResult<RequestJoinBucketResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<ShowBucketByIdResponse>> showBucketById(ShowBucketByIdParameter showBucketByIdParameter) {
    return bucketDataSource.showBucketById(showBucketByIdParameter).mapToLoadDataResult<ShowBucketByIdResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<ApproveOrRejectRequestBucketResponse>> approveOrRejectRequestBucket(ApproveOrRejectRequestBucketParameter approveOrRejectRequestBucketParameter) {
    return bucketDataSource.approveOrRejectRequestBucket(approveOrRejectRequestBucketParameter).mapToLoadDataResult<ApproveOrRejectRequestBucketResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<CheckBucketResponse>> checkBucket(CheckBucketParameter checkBucketParameter) {
    return bucketDataSource.checkBucket(checkBucketParameter).mapToLoadDataResult<CheckBucketResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<CheckoutBucketResponse>> checkoutBucket(CheckoutBucketParameter checkoutBucketParameter) {
    return bucketDataSource.checkoutBucket(checkoutBucketParameter).mapToLoadDataResult<CheckoutBucketResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<TriggerBucketReadyResponse>> triggerBucketReady(TriggerBucketReadyParameter triggerBucketReadyParameter) {
    return bucketDataSource.triggerBucketReady(triggerBucketReadyParameter).mapToLoadDataResult<TriggerBucketReadyResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<CartSummary>> sharedCartSummary(SharedCartSummaryParameter sharedCartSummaryParameter) {
    return bucketDataSource.sharedCartSummary(sharedCartSummaryParameter).mapToLoadDataResult<CartSummary>();
  }
}