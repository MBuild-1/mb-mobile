import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/bucket/destroybucket/destroy_bucket_parameter.dart';
import '../entity/bucket/destroybucket/destroy_bucket_response.dart';
import '../repository/bucket_repository.dart';

class DestroyBucketUseCase {
  final BucketRepository bucketRepository;

  const DestroyBucketUseCase({
    required this.bucketRepository
  });

  FutureProcessing<LoadDataResult<DestroyBucketResponse>> execute(DestroyBucketParameter destroyBucketParameter) {
    return bucketRepository.destroyBucket(destroyBucketParameter);
  }
}