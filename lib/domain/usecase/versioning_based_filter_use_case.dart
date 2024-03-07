import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/versioning/versioningbasedfilter/versioning_based_filter_parameter.dart';
import '../entity/versioning/versioningbasedfilter/versioning_based_filter_response.dart';
import '../repository/versioning_repository.dart';

class VersioningBasedFilterUseCase {
  final VersioningRepository versioningRepository;

  const VersioningBasedFilterUseCase({
    required this.versioningRepository
  });

  FutureProcessing<LoadDataResult<VersioningBasedFilterResponse>> execute(VersioningBasedFilterParameter versioningBasedFilterParameter) {
    return versioningRepository.versioningBasedFilter(versioningBasedFilterParameter);
  }
}