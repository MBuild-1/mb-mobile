import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/bucket/checkbucket/check_bucket_parameter.dart';
import '../entity/bucket/checkbucket/check_bucket_response.dart';
import '../repository/bucket_repository.dart';

class CheckBucketUseCase {
  final BucketRepository bucketRepository;

  const CheckBucketUseCase({
    required this.bucketRepository
  });

  FutureProcessing<LoadDataResult<CheckBucketResponse>> execute(CheckBucketParameter checkBucketParameter) {
    return bucketRepository.checkBucket(checkBucketParameter);
  }
}