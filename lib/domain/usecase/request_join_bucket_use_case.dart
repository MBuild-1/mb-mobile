import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/bucket/requestjoinbucket/request_join_bucket_parameter.dart';
import '../entity/bucket/requestjoinbucket/request_join_bucket_response.dart';
import '../repository/bucket_repository.dart';

class RequestJoinBucketUseCase {
  final BucketRepository bucketRepository;

  const RequestJoinBucketUseCase({
    required this.bucketRepository
  });

  FutureProcessing<LoadDataResult<RequestJoinBucketResponse>> execute(RequestJoinBucketParameter requestJoinBucketParameter) {
    return bucketRepository.requestJoinBucket(requestJoinBucketParameter);
  }
}