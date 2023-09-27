import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/bucket/removememberbucket/remove_member_bucket_parameter.dart';
import '../entity/bucket/removememberbucket/remove_member_bucket_response.dart';
import '../repository/bucket_repository.dart';

class RemoveMemberBucketUseCase {
  final BucketRepository bucketRepository;

  const RemoveMemberBucketUseCase({
    required this.bucketRepository
  });

  FutureProcessing<LoadDataResult<RemoveMemberBucketResponse>> execute(RemoveMemberBucketParameter removeMemberBucketParameter) {
    return bucketRepository.removeMemberBucket(removeMemberBucketParameter);
  }
}