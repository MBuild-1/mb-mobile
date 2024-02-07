import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/bucket/shared_cart_summary_parameter.dart';
import '../entity/cart/cart_summary.dart';
import '../repository/bucket_repository.dart';

class GetSharedCartSummaryUseCase {
  final BucketRepository bucketRepository;

  const GetSharedCartSummaryUseCase({
    required this.bucketRepository
  });

  FutureProcessing<LoadDataResult<CartSummary>> execute(SharedCartSummaryParameter sharedCartSummaryParameter) {
    return bucketRepository.sharedCartSummary(sharedCartSummaryParameter);
  }
}