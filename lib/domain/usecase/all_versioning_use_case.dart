import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/versioning/canbeupdatedversioning/all_versioning_parameter.dart';
import '../entity/versioning/canbeupdatedversioning/all_versioning_response.dart';
import '../repository/versioning_repository.dart';

class AllVersioningUseCase {
  final VersioningRepository versioningRepository;

  const AllVersioningUseCase({
    required this.versioningRepository
  });

  FutureProcessing<LoadDataResult<AllVersioningResponse>> execute(AllVersioningParameter canBeUpdatedVersioningParameter) {
    return versioningRepository.allVersioning(canBeUpdatedVersioningParameter);
  }
}