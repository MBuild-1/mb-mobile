import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/bucket/showbucketbyid/show_bucket_by_id_parameter.dart';
import '../entity/bucket/showbucketbyid/show_bucket_by_id_response.dart';
import '../repository/bucket_repository.dart';

class ShowBucketByIdUseCase {
  final BucketRepository bucketRepository;

  const ShowBucketByIdUseCase({
    required this.bucketRepository
  });

  FutureProcessing<LoadDataResult<ShowBucketByIdResponse>> execute(ShowBucketByIdParameter showBucketByIdParameter) {
    return bucketRepository.showBucketById(showBucketByIdParameter);
  }
}