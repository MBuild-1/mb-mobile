import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/bucket/createbucket/create_bucket_parameter.dart';
import '../entity/bucket/createbucket/create_bucket_response.dart';
import '../repository/bucket_repository.dart';

class CreateBucketUseCase {
  final BucketRepository bucketRepository;

  const CreateBucketUseCase({
    required this.bucketRepository
  });

  FutureProcessing<LoadDataResult<CreateBucketResponse>> execute(CreateBucketParameter createBucketParameter) {
    return bucketRepository.createBucket(createBucketParameter);
  }
}