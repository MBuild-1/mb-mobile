import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/bucket/triggerbucketready/trigger_bucket_ready_parameter.dart';
import '../entity/bucket/triggerbucketready/trigger_bucket_ready_response.dart';
import '../repository/bucket_repository.dart';

class TriggerBucketReadyUseCase {
  final BucketRepository bucketRepository;

  const TriggerBucketReadyUseCase({
    required this.bucketRepository
  });

  FutureProcessing<LoadDataResult<TriggerBucketReadyResponse>> execute(TriggerBucketReadyParameter triggerBucketReadyParameter) {
    return bucketRepository.triggerBucketReady(triggerBucketReadyParameter);
  }
}