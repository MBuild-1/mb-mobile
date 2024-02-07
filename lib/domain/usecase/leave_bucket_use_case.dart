import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/bucket/leavebucket/leave_bucket_parameter.dart';
import '../entity/bucket/leavebucket/leave_bucket_response.dart';
import '../repository/bucket_repository.dart';

class LeaveBucketUseCase {
  final BucketRepository bucketRepository;

  const LeaveBucketUseCase({
    required this.bucketRepository
  });

  FutureProcessing<LoadDataResult<LeaveBucketResponse>> execute(LeaveBucketParameter leaveBucketParameter) {
    return bucketRepository.leaveBucket(leaveBucketParameter);
  }
}