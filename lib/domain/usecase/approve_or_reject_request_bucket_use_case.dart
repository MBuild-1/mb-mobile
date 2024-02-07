import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/bucket/approveorrejectrequestbucket/approve_or_reject_request_bucket_parameter.dart';
import '../entity/bucket/approveorrejectrequestbucket/approve_or_reject_request_bucket_response.dart';
import '../repository/bucket_repository.dart';

class ApproveOrRejectRequestBucketUseCase {
  final BucketRepository bucketRepository;

  const ApproveOrRejectRequestBucketUseCase({
    required this.bucketRepository
  });

  FutureProcessing<LoadDataResult<ApproveOrRejectRequestBucketResponse>> execute(ApproveOrRejectRequestBucketParameter approveOrRejectRequestBucketParameter) {
    return bucketRepository.approveOrRejectRequestBucket(approveOrRejectRequestBucketParameter);
  }
}