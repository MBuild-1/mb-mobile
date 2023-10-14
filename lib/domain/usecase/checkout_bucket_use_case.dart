import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/bucket/checkoutbucket/checkout_bucket_parameter.dart';
import '../entity/bucket/checkoutbucket/checkout_bucket_response.dart';
import '../repository/bucket_repository.dart';

class CheckoutBucketUseCase {
  final BucketRepository bucketRepository;

  const CheckoutBucketUseCase({
    required this.bucketRepository
  });

  FutureProcessing<LoadDataResult<CheckoutBucketResponse>> execute(CheckoutBucketParameter checkoutBucketParameter) {
    return bucketRepository.checkoutBucket(checkoutBucketParameter);
  }
}