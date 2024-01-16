import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/bucket/checkoutbucket/checkout_bucket_version_1_point_1_parameter.dart';
import '../entity/bucket/checkoutbucket/checkout_bucket_version_1_point_1_response.dart';
import '../repository/bucket_repository.dart';

class CheckoutBucketVersion1Point1UseCase {
  final BucketRepository bucketRepository;

  const CheckoutBucketVersion1Point1UseCase({
    required this.bucketRepository
  });

  FutureProcessing<LoadDataResult<CheckoutBucketVersion1Point1Response>> execute(CheckoutBucketVersion1Point1Parameter checkoutBucketVersion1Point1Parameter) {
    return bucketRepository.checkoutBucketVersion1Point1(checkoutBucketVersion1Point1Parameter);
  }
}